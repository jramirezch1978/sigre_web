$PBExportHeader$w_al315_orden_traslado.srw
forward
global type w_al315_orden_traslado from w_abc
end type
type st_5 from statictext within w_al315_orden_traslado
end type
type sle_vale from singlelineedit within w_al315_orden_traslado
end type
type cb_agregavale from commandbutton within w_al315_orden_traslado
end type
type sle_nro from u_sle_codigo within w_al315_orden_traslado
end type
type st_3 from statictext within w_al315_orden_traslado
end type
type st_2 from statictext within w_al315_orden_traslado
end type
type em_saldo_dst_und2 from editmask within w_al315_orden_traslado
end type
type em_saldo_dst from editmask within w_al315_orden_traslado
end type
type st_4 from statictext within w_al315_orden_traslado
end type
type em_saldo_org_und2 from editmask within w_al315_orden_traslado
end type
type cb_1 from commandbutton within w_al315_orden_traslado
end type
type st_nro from statictext within w_al315_orden_traslado
end type
type em_saldo_org from editmask within w_al315_orden_traslado
end type
type st_1 from statictext within w_al315_orden_traslado
end type
type dw_detail from u_dw_abc within w_al315_orden_traslado
end type
type dw_master from u_dw_abc within w_al315_orden_traslado
end type
type gb_1 from groupbox within w_al315_orden_traslado
end type
type r_1 from rectangle within w_al315_orden_traslado
end type
end forward

global type w_al315_orden_traslado from w_abc
integer width = 3831
integer height = 2124
string title = "Orden de Traslado (AL315)"
string menuname = "m_mov_almacen"
windowstate windowstate = maximized!
boolean clientedge = true
event ue_anular ( )
event ue_cancelar ( )
event ue_preview ( )
event ue_cerrar ( )
st_5 st_5
sle_vale sle_vale
cb_agregavale cb_agregavale
sle_nro sle_nro
st_3 st_3
st_2 st_2
em_saldo_dst_und2 em_saldo_dst_und2
em_saldo_dst em_saldo_dst
st_4 st_4
em_saldo_org_und2 em_saldo_org_und2
cb_1 cb_1
st_nro st_nro
em_saldo_org em_saldo_org
st_1 st_1
dw_detail dw_detail
dw_master dw_master
gb_1 gb_1
r_1 r_1
end type
global w_al315_orden_traslado w_al315_orden_traslado

type variables
// Tipos de movimiento
String 		is_doc_otr, is_salir, is_oper_ing_otr, is_oper_sal_otr
			
Int 			ii_ref, ii_cerrado
DATETIME 	id_fecha_proc
Boolean 		ib_mod=false, ib_control_lin = false 

u_ds_base	ids_orden_traslado_det


end variables

forward prototypes
public function integer of_get_param ()
public function integer of_set_status_doc (datawindow idw)
public function integer of_set_numera ()
public subroutine of_boton_modificar (string as_ventana)
public subroutine of_saldos_articulo (long al_row)
public function integer of_set_articulo (string as_articulo)
public subroutine of_retrieve (string as_nro_otr)
public function string of_next_nro (string as_origen)
public function boolean of_crea_mov_proy ()
public function integer of_item_duplicados ()
public subroutine of_aprobar_otr ()
public function boolean of_anular_mov_proy ()
public function integer of_verifica_dup (string as_cod_art)
end prototypes

event ue_anular;Integer j
Long ll_row, ll_ano, ll_mes
String ls_estado

IF dw_master.GetRow() = 0 then return

ll_row = dw_master.GetRow()

// Fuerza a leer detalle
dw_detail.retrieve(dw_master.object.nro_otr[ll_row], is_oper_sal_otr)
ids_orden_traslado_det.retrieve(dw_master.object.nro_otr[ll_row], is_oper_sal_otr)	

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

ls_estado	= dw_master.object.flag_estado[ll_row]
ll_ano		= YEAR( DATE(dw_master.object.fec_registro[ll_row]))
ll_mes		= MONTH( DATE(dw_master.object.fec_registro[ll_row]))

if ls_estado <> '1' then
	MessageBox('Aviso', 'El documento no se puede anular', StopSign!)
	return
end if

// Busca si esta cerrado contablemente	
Select NVL( flag_gen_asnt_autom,0) 
	into :ii_cerrado
from cntbl_cierre 
where ano = :ll_ano 
  and mes = :ll_mes;

if ii_cerrado = 0 then
	MessageBox('Aviso', 'Periodo Contable ya esta cerrado, no puede anular el documento')
	return
end if

// Anulando Cabecera
dw_master.object.flag_estado[ll_row] = '0'

// Anulando Detalle
for j = 1 to dw_detail.rowCount()	
	dw_detail.object.flag_estado		  	[j] = '0'
	dw_detail.object.flag_modificacion	[j] = '0'
next

dw_master.ii_update = 1
dw_detail.ii_update = 1
is_action = 'anular'
of_set_status_doc(idw_1)
end event

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()
dw_detail.reset()
sle_nro.text = ''
idw_1 = dw_master
is_Action = ''
of_set_status_doc(dw_master)

end event

event ue_preview();// vista previa de mov. almacen
//str_parametros lstr_rep
//
//if dw_master.rowcount() = 0 then return
//
//lstr_rep.dw1 = 'd_frm_movimiento_almacen'
//lstr_rep.titulo = 'Previo de Movimiento de almacen'
//lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
//lstr_rep.string2 = dw_master.object.nro_vale[dw_master.getrow()]
//
//OpenWithParm(w_rpt_preview, lstr_rep)
end event

event ue_cerrar();Long ll_row, ll_i
ll_row = dw_master.GetRow( )

if ll_row = 0 then
	MessageBox('Error', 'No ha definido una cebecera de Orden de Traslado')
	return
end if

if dw_master.object.flag_estado[ll_row] = '0' then
	MessageBox('Aviso', 'No puede cerrar esta Orden de Traslado porque esta anulada')
	return
end if
	
if is_action = 'new' then
	MessageBox('Aviso', 'No puede cerrar esta Orden de Traslado porque recien la esta haciendo')
	return
end if

//Verificar que la cantidad de salida sea la misma que la 
//cantidad de entrada de lo contrario no puedo cerrar la 
//Orden de Traslado
for ll_i = 1 to dw_detail.RowCount()
	if dw_detail.object.cant_procesada[ll_i] <> dw_detail.object.cant_facturada[ll_i] then
		MessageBox('Aviso', 'No Puede cerrar la Orden de Traslado porque la cantidad de salida no coincide con la cantidad de ingreso')
		return 
	end if
next

dw_master.object.flag_estado [ll_row] = '3'
dw_master.ii_update = 1
	
for ll_i = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado [ll_i] = '2'
	dw_detail.ii_update = 1
next

is_action = 'cerrar'
of_set_status_doc(idw_1)
end event

public function integer of_get_param ();//Parametros Iniciales
SELECT doc_otr, oper_ing_otr, oper_sal_otr
		INTO :is_doc_otr, :is_oper_ing_otr, :is_oper_sal_otr
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

if ISNULL( is_doc_otr ) or TRIM( is_doc_otr ) = '' then
	Messagebox("Error de parametros", "Defina Documento Orden de Traslado en logparam")
	return 0
end if

if ISNULL( is_oper_ing_otr ) or TRIM( is_oper_ing_otr ) = '' then
	Messagebox("Error de parametros", "Defina INGRESO POR ORDEN DE TRASLADO en logparam")
	return 0
end if

if ISNULL( is_oper_sal_otr ) or TRIM( is_oper_sal_otr ) = '' then
	Messagebox("Error de parametros", "Defina SALIDA POR ORDEN DE TRASLADO en logparam")
	return 0
end if

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
	m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
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
	m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
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
	end if
end if

if is_Action = 'open' then
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])	
	
	Choose case li_estado
		case 0 	// Anulado 
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
			m_master.m_file.m_basedatos.m_modificar.enabled 	= false
			m_master.m_file.m_basedatos.m_anular.enabled 		= false	
			m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
			if idw_1 = dw_master then		
				m_master.m_file.m_basedatos.m_insertar.enabled = true
			ELSE			
				m_master.m_file.m_basedatos.m_insertar.enabled = false

			end if	
			RETURN 1
		CASE 2,3   // Aprobado, Cerrado
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
			m_master.m_file.m_basedatos.m_modificar.enabled 	= false
			m_master.m_file.m_basedatos.m_anular.enabled 		= false
			if li_estado = 2 then
				m_master.m_file.m_basedatos.m_cerrar.enabled 		= true
			else
				m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
			end if
			if idw_1 = dw_master then		
				m_master.m_file.m_basedatos.m_insertar.enabled = true
			ELSE
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			end if	
			RETURN 1
	end CHOOSE
end if

if is_Action = 'anu' or is_action = 'cerrar' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
	m_master.m_file.m_printer.m_print1.enabled 			= false
end if

return 1
end function

public function integer of_set_numera ();// Numera documento
Long j
String  ls_next_nro

if dw_master.getrow() = 0 then return 0

if is_action = 'new' then
	ls_next_nro = of_next_nro(gs_origen)
	if IsNull(ls_next_nro) or ls_next_nro = '' then return 0
	
	dw_master.object.nro_otr[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
else
	ls_next_nro = dw_master.object.nro_otr[dw_master.getrow()] 
end if
// Asigna numero a detalle
for j = 1 to dw_detail.RowCount()
	dw_detail.object.nro_doc[j] = ls_next_nro
next

return 1
end function

public subroutine of_boton_modificar (string as_ventana);String ls_mod

Select NVL( flag_modificar, '') 
	into :ls_mod 
from usuario_obj 
where cod_usr = :gs_user 
  and objeto = :as_ventana;

if ls_mod <> '1' then
	m_mov_almacen.m_file.m_basedatos.m_modificar.visible = false
	m_mov_almacen.m_file.m_basedatos.m_modificar.toolbaritemvisible = false
else
	ib_mod = true	
end if




end subroutine

public subroutine of_saldos_articulo (long al_row);string 	ls_cod_art, ls_almacen_org, ls_almacen_dst
decimal 	ldc_saldo, ldc_prom_sol, ldc_prom_dol, &
			ldc_saldo_und2

if al_row = 0 then return

if dw_master.Getrow() = 0 then return

ls_cod_art 		= dw_detail.object.cod_art[al_row]
ls_almacen_org = dw_master.object.almacen_org[dw_master.GetRow()]
ls_almacen_dst = dw_master.object.almacen_dst[dw_master.GetRow()]

//Saldos en Almacen Origen
SELECT Nvl(sldo_total,0), NVL(sldo_total_und2,0)
	INTO   :ldc_saldo, :ldc_saldo_und2
FROM  articulo_almacen
WHERE almacen = :ls_almacen_org 
  AND cod_art = :ls_cod_art ; 	
  
if SQLCA.SQLCode = 100 then
	ldc_saldo = 0
	ldc_saldo_und2 = 0
end if

em_saldo_org.text 	  = String( ldc_saldo, '###,##0.00' ) 		
em_saldo_org_und2.text = String( ldc_saldo_und2, '###,##0.00' ) 	

dw_detail.object.saldo_org	[al_row] = ldc_saldo

//Saldos en almacen destino
SELECT Nvl(sldo_total,0), NVL(sldo_total_und2,0)
	INTO   :ldc_saldo, :ldc_saldo_und2
FROM  articulo_almacen
WHERE almacen = :ls_almacen_dst 
  AND cod_art = :ls_cod_art; 		

if SQLCA.SQLCode = 100 then
	ldc_saldo = 0
	ldc_saldo_und2 = 0
end if

em_saldo_dst.text 	  = String( ldc_saldo, '###,##0.00' ) 		
em_saldo_dst_und2.text = String( ldc_saldo_und2, '###,##0.00' ) 	

dw_detail.object.saldo_dst	[al_row] = ldc_saldo
end subroutine

public function integer of_set_articulo (string as_articulo);String 	ls_msg, ls_almacen_org, ls_almacen_dst
Decimal 	ldc_saldo, ldc_saldo_und2
Long 		ll_row
str_articulo	lstr_articulo

ll_row = dw_master.GetRow()
if ll_Row = 0 then return 0

ls_almacen_org = dw_master.object.almacen_org[ll_row]
ls_almacen_dst = dw_master.object.almacen_dst[ll_row]

if ls_almacen_org = '' or IsNull(ls_almacen_org) then
	MessageBox('Aviso', 'No ha definido el almacen origen', StopSign!)
	return 0
end if

if ls_almacen_org = '' or IsNull(ls_almacen_org) then
	MessageBox('Aviso', 'No ha definido el almacen destino', StopSign!)
	return 0
end if

// Verifica que codigo ingresado exista
//lstr_articulo = gnvo_app.almacen.of_get_articulo(as_articulo)
	
Select 	cod_art, cod_sku, desc_art, und
	into 	:lstr_articulo.cod_art,:lstr_articulo.cod_sku, :lstr_articulo.desc_art, :lstr_articulo.und
from articulo 
Where cod_art = :as_articulo
   or cod_sku = UPPER(:as_articulo);

if SQLCA.SQLCode = 100 then
	MESSAGEBOX('Aviso', 'Error, no existe el codigo ' + as_articulo, StopSign!)
end if
//if not lstr_articulo.b_return then return 0 ///LO QUITE MILAGROS

ll_row = dw_detail.GetRow()
if ll_row <= 0 then
	MessageBox('Aviso', 'Error, no existe ninguna fila en el detalles', StopSign!)
	return 0
end if

dw_detail.object.cod_art		[ll_row] = lstr_articulo.cod_art
dw_detail.object.cod_sku	[ll_row] = lstr_articulo.cod_sku
dw_detail.object.desc_Art	[ll_row] = lstr_articulo.desc_art
dw_detail.object.und			[ll_row] = lstr_articulo.und

//Saldos en Almacen Origen
SELECT Nvl(sldo_total,0), NVL(sldo_total_und2,0)
	INTO   :ldc_saldo, :ldc_saldo_und2
FROM  articulo_almacen
WHERE almacen = :ls_almacen_org 
  AND cod_art = :lstr_articulo.cod_art ; 		
		
if SQLCA.SQLCode = 100 then
	ldc_saldo = 0
	ldc_saldo_und2 = 0
end if


em_saldo_org.text 	  = String( ldc_saldo, '###,##0.00' ) 		
em_saldo_org_und2.text = String( ldc_saldo_und2, '###,##0.00' ) 		

//Saldos en almacen destino
SELECT Nvl(sldo_total,0), NVL(sldo_total_und2,0)
	INTO   :ldc_saldo, :ldc_saldo_und2
FROM  articulo_almacen
WHERE almacen = :ls_almacen_dst 
  AND cod_art = :lstr_articulo.cod_art ; 		
		
if SQLCA.SQLCode = 100 then
	ldc_saldo = 0
	ldc_saldo_und2 = 0
end if

em_saldo_dst.text 	  = String( ldc_saldo, '###,##0.00' ) 		
em_saldo_dst_und2.text = String( ldc_saldo_und2, '###,##0.00' ) 	

dw_detail.Modify("cant_proyect.Protect ='1~tIf(IsNull(flag_mod),1,0)'")
dw_detail.Modify("cant_proyect.Background.color ='1~tIf(IsNull(flag_mod),RGB(192,192,192),RGB(255,255,255))'")

dw_detail.Modify("cod_art.Protect ='1~tIf(IsNull(flag_mod),1,0)'")
dw_detail.Modify("cod_art.Background.color ='1~tIf(IsNull(flag_mod),RGB(192,192,192),RGB(255,255,255))'")

return 1
end function

public subroutine of_retrieve (string as_nro_otr);Long ll_row, ll_ano, ll_mes

dw_master.retrieve(as_nro_otr)


if dw_master.RowCount() > 0 then
	
	dw_master.object.p_logo.filename = gs_logo
	ll_ano = YEAR( DATE(dw_master.object.fec_registro[1]))
	ll_mes = MONTH( DATE(dw_master.object.fec_registro[1]))
	
	// Fuerza a leer detalle
	dw_detail.retrieve(as_nro_otr, is_oper_sal_otr)
	ids_orden_traslado_det.retrieve(as_nro_otr, is_oper_sal_otr)	
	
	// Busca si esta cerrado contablemente	
	Select NVL( flag_gen_asnt_autom, 0 ) 
		into :ii_cerrado
	from cntbl_cierre 
	where ano = :ll_ano 
	  and mes = :ll_mes;
	  
	if ii_cerrado = 0 then
		dw_master.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
	else
		dw_master.object.t_cierre.text = ''
	end if 
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	of_set_status_doc( dw_master )
end if

is_action = 'open'

return 
end subroutine

public function string of_next_nro (string as_origen);string ls_mensaje, ls_ult_nro

//create or replace function USF_ALM_NUM_OTR
//(      
//       ac_cod_origen origen.cod_origen%type
//       
//) return varchar2 is

DECLARE USF_ALM_NUM_OTR PROCEDURE FOR
	USF_ALM_NUM_OTR( :as_origen );

EXECUTE USF_ALM_NUM_OTR;
	
IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION USF_ALM_NUM_OTR:" + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	SetNull(ls_ult_nro)
	Return ls_ult_nro
END IF
	
FETCH USF_ALM_NUM_OTR INTO :ls_ult_nro;
CLOSE USF_ALM_NUM_OTR;

return ls_ult_nro
end function

public function boolean of_crea_mov_proy ();/*
   Funcion: of_crea_mov_proy
	Objetivo: 	Por cada registro de la Orden de Traslado se debe generar
					una linea adicional en articulo_mov_proy, como ingreso. 
	Parametros: ninguno
	Retorna: true 	= Ok
				false = fallo
*/

Long 		ll_i, ll_count, ll_row_mst
string	ls_cod_art, ls_nro_otr, ls_mensaje, ls_origen, ls_flag_estado, &
			ls_almacen_dst
decimal	ldc_cant_proyect
DateTime	ldt_fec_proyect

if dw_master.GetRow() = 0 then return false
ll_row_mst = dw_master.GetRow()

ls_nro_otr 		= dw_master.object.nro_otr		[ll_row_mst]
ls_almacen_dst = dw_master.object.almacen_dst[ll_row_mst]

if IsNull(ls_nro_otr) or ls_nro_otr = '' then 
	MessageBox('Aviso', 'Debe definir nro de la Orden de Traslado')
	return false
end if

if IsNull(ls_almacen_dst) or ls_almacen_dst = '' then 
	MessageBox('Aviso', 'Debe definir almacen destino')
	return false
end if

ls_origen = left(ls_nro_otr,2)
dw_detail.AcceptText()

// Si el detalle no ha sufrido cambios entonces no hay nada que hacer
if dw_detail.ii_update <> 1 then return true

// Primero verifico todos los elementos borrados
For ll_i = 1 to dw_detail.deletedCount()
	ls_cod_art 			= dw_detail.object.cod_art.Delete	[ll_i]
	
	// Elimina registros
	Delete from articulo_mov_proy 
	 where tipo_doc 	= :is_doc_otr
	   and nro_doc  	= :ls_nro_otr
		and cod_Art  	= :ls_cod_art
		and tipo_mov 	= :is_oper_ing_otr;
		  
   if sqlca.sqlcode <> 0 then 
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		messagebox( "Aviso", ls_mensaje)
		return false
	end if
Next

// Ahora actualizo todos los cambios de items de la Orden de Traslado
for ll_i = 1 to dw_detail.Rowcount()
	
	ls_cod_art 			= dw_detail.object.cod_art 					[ll_i]
	ls_flag_Estado    = dw_detail.object.flag_estado 				[ll_i]
	ldc_cant_proyect  = Dec(dw_detail.object.cant_proyect			[ll_i])
	ldt_fec_proyect	= DateTime(dw_detail.object.fec_proyect	[ll_i])
		
	select count(*)
	  into :ll_count
	  from articulo_mov_proy
	 where tipo_doc 	= :is_doc_otr
		and nro_doc  	= :ls_nro_otr
		and cod_Art  	= :ls_cod_art
		and tipo_mov 	= :is_oper_ing_otr;

	if ll_count = 0 then
		Insert into articulo_mov_proy(
			cod_origen, 			flag_estado, 		cod_art, 			tipo_mov, 		
			tipo_doc, 				nro_doc, 			fec_registro, 		fec_proyect, 	
			cant_proyect, 			cant_procesada, 	cant_facturada, 	precio_unit, 	
			decuento, 				impuesto, 			flag_crg_inm_prsp,
			flag_modificacion, 	almacen, 			cod_usr)
		values( 
			:gs_origen, 			'1', 					:ls_cod_art, 		:is_oper_ing_otr,
			:is_doc_otr, 			:ls_nro_otr, 		sysdate, 			:ldt_fec_proyect, 
			:ldc_cant_proyect,	0, 					0, 					0,
			0,							0, 					'0', 
			'1', 						:ls_almacen_dst, 	:gs_user);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso, no se pudo insertar el dato', ls_mensaje)
			return false
		end if

	else
		
		Update articulo_mov_proy
			set flag_estado 	= :ls_flag_estado,
				 cant_proyect 	= :ldc_cant_proyect,
				 fec_proyect	= :ldt_fec_proyect,
				 cod_art			= :ls_cod_art,
				 almacen			= :ls_almacen_dst,
				 flag_replicacion = '1'
		 where tipo_doc 	= :is_doc_otr
			and nro_doc  	= :ls_nro_otr
			and cod_Art  	= :ls_cod_art
			and tipo_mov 	= :is_oper_ing_otr;

		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso, no se pudo actualizar el dato', ls_mensaje)
			return false
		end if

	end if		
		
next

return true
end function

public function integer of_item_duplicados ();string 	ls_cod_art
date		ld_fec_proyect
Long		ll_i

for ll_i = 1 to dw_detail.RowCount()
	ls_cod_art 		= dw_detail.object.cod_art [ll_i]
	if of_verifica_dup( ls_cod_art ) > 1 then
		MessageBox('Aviso', 'No puede ingresar el Mismo Codigo de articulo mas de una vez en la Orden de Traslado')
		dw_detail.SetRow(ll_i)
		dw_detail.SetFocus()
		return 0
	end if
next

return 1
end function

public subroutine of_aprobar_otr ();string ls_nro_otr, ls_mensaje

if is_action = "new" then
	if dw_master.GetRow() = 0 then return
	
	ls_nro_otr = dw_master.object.nro_otr[dw_master.GetRow()]
	
	update orden_Traslado
		set flag_Estado = '2',
			 USR_AUTORIZA = :gs_user,
			 flag_replicacion = '1'
	 where nro_otr = :ls_nro_otr;
	 
	 if SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al Aprobar la OTR', ls_mensaje)
		return
	 end if
	 
	 COMMIT;
end if		

end subroutine

public function boolean of_anular_mov_proy ();/*
   Funcion: of_crea_mov_proy
	Objetivo: 	Por cada registro de la Orden de Traslado se debe generar
					una linea adicional en articulo_mov_proy, como ingreso. 
	Parametros: ninguno
	Retorna: true 	= Ok
				false = fallo
*/

Long 		ll_i, ll_count, ll_row_mst
string	ls_cod_art, ls_nro_otr, ls_mensaje, ls_origen, ls_flag_estado, &
			ls_almacen_dst
decimal	ldc_cant_proyect
DateTime	ldt_fec_proyect

if dw_master.GetRow() = 0 then return false
ll_row_mst = dw_master.GetRow()

ls_nro_otr 		= dw_master.object.nro_otr		[ll_row_mst]
ls_almacen_dst = dw_master.object.almacen_dst[ll_row_mst]

if IsNull(ls_nro_otr) or ls_nro_otr = '' then 
	MessageBox('Aviso', 'Debe definir nro de la Orden de Traslado')
	return false
end if

if IsNull(ls_almacen_dst) or ls_almacen_dst = '' then 
	MessageBox('Aviso', 'Debe definir almacen destino')
	return false
end if

ls_origen = left(ls_nro_otr,2)
dw_detail.AcceptText()

// Si no hay modificaciones no tengo nada que hacer
if dw_detail.ii_update = 0 then return true

for ll_i = 1 to dw_detail.Rowcount()
	ls_cod_art 			= dw_detail.object.cod_art 					[ll_i]
	ls_flag_Estado    = dw_detail.object.flag_estado 				[ll_i]
	ldc_cant_proyect  = Dec(dw_detail.object.cant_proyect			[ll_i])
	ldt_fec_proyect	= DateTime(dw_detail.object.fec_proyect	[ll_i])
		
	select count(*)
	  into :ll_count
	  from articulo_mov_proy
	 where tipo_doc 	= :is_doc_otr
		and nro_doc  	= :ls_nro_otr
		and cod_Art  	= :ls_cod_art
		and tipo_mov 	= :is_oper_ing_otr;
		
	if ll_count = 0 then
		Insert into articulo_mov_proy(
			cod_origen, flag_estado, cod_art, tipo_mov, tipo_doc, nro_doc, 
			fec_registro, fec_proyect, cant_proyect, cant_procesada, 
			cant_facturada, precio_unit, decuento, impuesto, flag_crg_inm_prsp,
			flag_modificacion, almacen)
		values( :gs_origen, '0', :ls_cod_art, :is_oper_ing_otr,
			:is_doc_otr, :ls_nro_otr, sysdate, :ldt_fec_proyect, :ldc_cant_proyect,
			0, 0, 0,0,0, '0', '1', :ls_almacen_dst);
	else
		Update articulo_mov_proy
			set flag_estado 		= '0',
				 flag_replicacion = '1'
		 where tipo_doc 	= :is_doc_otr
			and nro_doc  	= :ls_nro_otr
			and cod_Art  	= :ls_cod_art
			and tipo_mov 	= :is_oper_ing_otr;
			
	end if		
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return false
	end if
next

return true
end function

public function integer of_verifica_dup (string as_cod_art);// Verifica codigo duplicados

long ll_find = 1, ll_end, ll_vec = 0
String ls_cad

ls_cad = "cod_art = '" + as_cod_Art + "'" 
ll_vec = 0
ll_end = dw_detail.RowCount()

ll_find = dw_detail.Find(ls_cad, ll_find, ll_end)
DO WHILE ll_find > 0
	ll_vec ++
	// Collect found row
	ll_find++
	// Prevent endless loop
	IF ll_find > ll_end THEN EXIT
	ll_find = dw_detail.Find(ls_cad, ll_find, ll_end)
LOOP			


return ll_vec
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
	
	dw_master.object.p_logo.filename = gs_logo
	
	of_boton_modificar(THIS.ClassName())  // Activa/desactiva boton de modificar segun acceso
	
	ids_orden_traslado_det = create u_ds_base
	ids_orden_traslado_det.dataObject = 'd_abc_orden_traslado_det_tbl'
	ids_orden_traslado_det.setTransObject(SQLCA)
	
end if
end event

event ue_update_pre;
//Si la opcion es anular, entonces verifico y ahi termina todo
if is_action = 'anular' then
	if of_anular_mov_proy() = false then return
	ib_update_check = true
	return
end if

// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

// verifica que tenga datos de detalle
if dw_detail.rowcount() = 0 then
	Messagebox( "Atencion", "Debe ingresar algun detalle en la orden de traslado")
	return
end if

if of_item_duplicados() = 0 then return
if of_set_numera() = 0 then return

if is_action = 'new' or is_action = 'edit' then
	if of_crea_mov_proy() = false then return
end if


dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()


ib_update_check = true


end event

on w_al315_orden_traslado.create
int iCurrent
call super::create
if this.MenuName = "m_mov_almacen" then this.MenuID = create m_mov_almacen
this.st_5=create st_5
this.sle_vale=create sle_vale
this.cb_agregavale=create cb_agregavale
this.sle_nro=create sle_nro
this.st_3=create st_3
this.st_2=create st_2
this.em_saldo_dst_und2=create em_saldo_dst_und2
this.em_saldo_dst=create em_saldo_dst
this.st_4=create st_4
this.em_saldo_org_und2=create em_saldo_org_und2
this.cb_1=create cb_1
this.st_nro=create st_nro
this.em_saldo_org=create em_saldo_org
this.st_1=create st_1
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.gb_1=create gb_1
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.sle_vale
this.Control[iCurrent+3]=this.cb_agregavale
this.Control[iCurrent+4]=this.sle_nro
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.em_saldo_dst_und2
this.Control[iCurrent+8]=this.em_saldo_dst
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.em_saldo_org_und2
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.st_nro
this.Control[iCurrent+13]=this.em_saldo_org
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.dw_detail
this.Control[iCurrent+16]=this.dw_master
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.r_1
end on

on w_al315_orden_traslado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_5)
destroy(this.sle_vale)
destroy(this.cb_agregavale)
destroy(this.sle_nro)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_saldo_dst_und2)
destroy(this.em_saldo_dst)
destroy(this.st_4)
destroy(this.em_saldo_org_und2)
destroy(this.cb_1)
destroy(this.st_nro)
destroy(this.em_saldo_org)
destroy(this.st_1)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.r_1)
end on

event ue_insert;Long  	ll_row, ll_ano, ll_mes, ll_mov_atrazados
string	ls_msg
n_cst_diaz_retrazo lnvo_amp_retr

if idw_1 = dw_master and is_action = 'new' then
	Messagebox( "Atencion", "No puede adicionar otro documento, grabe el actual", exclamation!)
	return
end if

IF idw_1 = dw_detail THEN	
	if is_Action <> 'new' then
		MessageBox("Error", "No se puede insertar otro item a esta Orden de Traslado")
		RETURN
	end if
	IF dw_master.GetRow() = 0 THEN
		MessageBox("Error", "No existe cabecera de la Orden de Traslado")
		RETURN
	END IF	

	if dw_master.GetRow() <> 0 then
		if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' &
			and idw_1 = dw_detail then
			MessageBox('Aviso', 'No puede ingresar mas detalles a la Orden de Traslado')
			return
		end if
	end if
END IF

id_fecha_proc = f_fecha_actual() 

if idw_1 = dw_master then
	// Obtengo los movimientos proyectados atrazados 
	// Solo por el tipo de documento
	// Los dias de retrazo los toma de LogParam y el usuario de gs_user
	lnvo_amp_retr = CREATE n_cst_diaz_retrazo
	ll_mov_atrazados = lnvo_amp_retr.of_amp_retrazados( is_doc_otr )
	DESTROY lnvo_amp_retr
	
/*	if ll_mov_atrazados > 0 then
		MessageBox('Aviso', 'Tiene pendientes ' + string(ll_mov_atrazados) &
			+ ' movimientos Proyectados en Orden de Traslado')
		return
	end if */
end if

// Verifica indicador de cierre contable
ll_ano = YEAR( DATE(id_fecha_proc))
ll_mes = MONTH( DATE(id_fecha_proc))
	
// Busca si esta cerrado contablemente	
Select NVL( flag_gen_asnt_autom,0) 
	into :ii_cerrado
from cntbl_cierre 
where ano = :ll_ano 
  and mes = :ll_mes;
  
if sqlca.sqlcode = 100 then
	Messagebox("Atencion", "Periodo contable no encontrado, ~r~n" + &
	  "Coordinar con area contable para su apertura", Exclamation!)
	  return
end if

if ii_cerrado = 0 then
	MessageBox('Aviso', 'El periodo contable esta cerrado')
	return
end if

if idw_1 = dw_master then
	is_action = 'new'
	// Limpia dw
	dw_master.Reset()
	dw_detail.Reset()
else
	if is_action <> 'new' then
		is_action = 'edit'
	end if
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	THIS.EVENT ue_insert_pos(ll_row)
	dw_master.object.p_logo.filename = gs_logo
	of_set_status_doc(dw_master)
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

event ue_modify;call super::ue_modify;Long ll_i
IF dw_master.rowcount() = 0 then return

if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then
	MessageBox('Aviso', 'No puede modificar la Orden de Traslado')
	return
end if

dw_master.of_protect()
dw_detail.of_protect()	

is_action = 'edit'

Int li_protect

li_protect = integer(dw_master.Object.fec_registro.Protect)

IF li_protect = 0 THEN
	// fuerza a Desactivar objetos
	dw_master.Object.fec_registro.Protect = 1
	dw_master.Object.tipo_doc.Protect = 1
	dw_master.Object.nro_doc.Protect = 1
END IF 

for ll_i = 1 to dw_detail.RowCount()

	if Dec(dw_detail.object.cant_procesada[ll_i]) > 0 then
		
		dw_master.object.almacen_org.protect = 1
		dw_master.object.almacen_org.background.color = RGB(192,192,192)
		dw_master.object.almacen_org.edit.required = 'no'
		
	end if

	if Dec(dw_detail.object.cant_facturada[ll_i]) > 0 then
		
		dw_master.object.almacen_dst.protect = 1
		dw_master.object.almacen_dst.background.color = RGB(192,192,192)
		dw_master.object.almacen_dst.edit.required = 'no'
		
	end if

next

li_protect = integer(dw_detail.Object.cod_art.Protect)

IF li_protect = 0 THEN
	// fuerza a Desactivar objetos
	dw_detail.Object.cod_art.Protect = 1
END IF 

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String ls_msg1, ls_msg2

if dw_master.rowcount() = 0 then return
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
end if

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN	
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Master"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

IF dw_detail.ii_update = 1 THEN	
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Detalle"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	// En Esta parte se aprueba de Orden de Traslado
	of_aprobar_otr()	
	/**********************************************/
	
	is_action = 'open'
	of_set_status_doc( dw_master)
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	dw_master.Retrieve(dw_master.object.nro_otr[dw_master.GetRow()])
	dw_detail.retrieve( dw_master.object.nro_otr[dw_master.GetRow()],is_oper_sal_otr)
	ids_orden_traslado_det.retrieve( dw_master.object.nro_otr[dw_master.GetRow()], is_oper_sal_otr)
	
	f_mensaje('Cambios Guardados satisfactoriamente', '')
ELSE 
	ROLLBACK USING SQLCA;
	messagebox(ls_msg1,ls_msg2,exclamation!)	
END IF
end event

event resize;call super::resize;Long ll_y
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 35
dw_detail.height = newheight - dw_detail.y - gb_1.height - 10 //180	

gb_1.y 		= newheight - gb_1.height - 10
gb_1.width 	= newwidth - gb_1.x - 10

em_saldo_org.y = gb_1.y + 45
em_saldo_dst.y = gb_1.y + 45
em_saldo_org_und2.y = gb_1.y + 45
em_saldo_dst_und2.y = gb_1.y + 45

st_1.y = gb_1.y + 47
st_2.y = gb_1.y + 47
st_3.y = gb_1.y + 47
st_4.y = gb_1.y + 47

	
	

end event

event ue_list_open;call super::ue_list_open;
// Abre ventana pop
str_parametros sl_param

sl_param.dw1    = 'd_lista_ordenes_traslado_grd'
sl_param.titulo = 'Ordenes de Traslado'
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2


OpenWithParm(w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_insert_pos;call super::ue_insert_pos;idw_1.setcolumn(1)
end event

event ue_print;call super::ue_print;// vista previa de orden de traslado
str_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.titulo 	= 'Orden de Traslado'
lstr_rep.string1 	= dw_master.object.nro_otr	[dw_master.getrow()]

OpenSheetWithParm(w_al315_orden_traslado_frm, lstr_rep, w_main, 0, layered!)
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if

end event

event ue_delete;// OVerride

IF dw_master.rowcount() = 0 then return
Long  ll_row

if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then
	MessageBox('Aviso', 'Accion no permitida en la Orden de Traslado')
end if

if idw_1 = dw_master then
	Messagebox( "Atencion", "Operacion no permitida", exclamation!)
	return
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

event close;call super::close;destroy ids_orden_traslado_det
end event

type st_5 from statictext within w_al315_orden_traslado
integer x = 2583
integer y = 864
integer width = 617
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
string text = "Orden Traslado ORIGEN:"
long bordercolor = 67108864
boolean focusrectangle = false
end type

type sle_vale from singlelineedit within w_al315_orden_traslado
integer x = 2560
integer y = 940
integer width = 466
integer height = 100
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_agregavale from commandbutton within w_al315_orden_traslado
integer x = 3031
integer y = 940
integer width = 270
integer height = 100
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Agregar"
end type

event clicked;STRING ls_vale, ls_codart, ls_desc, ls_unid,ls_almacen_org,ls_almacen_dst, ls_cod_sku
int ln_cantidad,ln_sdoOrigen, ln_sdoDestino
long ll_row, ll_rowm

ll_rowm = dw_master.GetRow()
if ll_Rowm = 0 then return 0

ls_vale = sle_vale.text

ls_almacen_org = dw_master.object.almacen_org[ll_rowm]
ls_almacen_dst = dw_master.object.almacen_dst[ll_rowm]

IF trim(ls_almacen_org) = '' or IsNull(ls_almacen_org) THEN RETURN 
IF trim(ls_almacen_dst) = '' or IsNull(ls_almacen_dst) THEN RETURN 

declare cur_vale cursor for
select D.COD_ART, a.cod_sku, D.CANT_PROCESADA, A.DESC_ART, A.UND,
		nvl((select aa.sldo_total from articulo_almacen aa where aa.cod_art = d.cod_art and aa.almacen = x.almacen),0) sdo_origen,
		nvl((select aa.sldo_total from articulo_almacen aa where aa.cod_art = d.cod_art and aa.almacen = :ls_almacen_dst),0) sdo_destino
from vale_mov x , articulo_mov d, articulo a
where x.nro_vale = d.nro_vale
		and d.cod_art = a.cod_art
		and x.almacen = :ls_almacen_org
		and x.flag_estado = '1'
		and x.tipo_mov in ('I01', 'I04')
		AND X.NRO_VALE LIKE '%' || :ls_vale;

//cod_art, cant_proyectada

OPEN cur_vale; 

if SQLCA.sqlcode < 0 then 
MessageBox("Cursor Abierto",SQLCA.sqlerrtext) 
end if 

DO WHILE SQLCA.sqlcode = 0 

FETCH cur_vale INTO :ls_codart,:ls_cod_sku, :ln_cantidad, :ls_desc, :ls_unid, :ln_sdoOrigen, :ln_sdoDestino;
if SQLCA.sqlcode < 0 then 
	MessageBox("Fetch Error",SQLCA.sqlerrtext) 
elseif SQLCA.sqlcode = 0 then 
	
	ll_row = dw_detail.event ue_insert()
	
	if ll_row = 0 then return -1		
	
	dw_detail.object.cod_art				 [ll_row] = ls_codart	
	dw_detail.object.cod_sku			 [ll_row] = ls_cod_sku	
	dw_detail.object.und				     [ll_row] = ls_unid
	dw_detail.object.desc_art			 [ll_row] = ls_desc
	
	if ln_cantidad > ln_sdoOrigen then		
		dw_detail.object.cant_proyect		 [ll_row] = ln_sdoOrigen
	else 		
		dw_detail.object.cant_proyect		 [ll_row] = ln_cantidad
	end if
	
	dw_detail.object.saldo_org	[ll_row] 		= ln_sdoOrigen
	dw_detail.object.saldo_dst	[ll_row] 		= ln_sdoDestino
	
end if
LOOP 

CLOSE cur_vale; 	


	
end event

type sle_nro from u_sle_codigo within w_al315_orden_traslado
integer x = 343
integer y = 20
integer width = 471
integer height = 92
integer taborder = 10
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;dw_detail.reset()
cb_1.event clicked()
end event

type st_3 from statictext within w_al315_orden_traslado
integer x = 2414
integer y = 1732
integer width = 453
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Dest Und2:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_al315_orden_traslado
integer x = 1714
integer y = 1728
integer width = 338
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Dest:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_saldo_dst_und2 from editmask within w_al315_orden_traslado
integer x = 2866
integer y = 1724
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
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
end type

type em_saldo_dst from editmask within w_al315_orden_traslado
integer x = 2071
integer y = 1724
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
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
end type

type st_4 from statictext within w_al315_orden_traslado
integer x = 846
integer y = 1732
integer width = 425
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Org Und2:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_saldo_org_und2 from editmask within w_al315_orden_traslado
integer x = 1275
integer y = 1724
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
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
end type

type cb_1 from commandbutton within w_al315_orden_traslado
integer x = 823
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

type st_nro from statictext within w_al315_orden_traslado
integer x = 55
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

type em_saldo_org from editmask within w_al315_orden_traslado
integer x = 480
integer y = 1724
integer width = 343
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
end type

type st_1 from statictext within w_al315_orden_traslado
integer x = 105
integer y = 1732
integer width = 352
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Origen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_detail from u_dw_abc within w_al315_orden_traslado
event ue_display ( string as_columna,  long al_row )
integer y = 1096
integer width = 3323
integer height = 552
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_abc_orden_traslado_det_tbl"
borderstyle borderstyle = styleraised!
integer ii_sort = 1
end type

event ue_display;// Abre ventana de ayuda 

str_articulo 	lstr_articulo

choose case lower(as_columna)
		
	case "cod_art"
		lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )
	    
		if lstr_articulo.b_Return then
			this.object.cod_art				[al_row] = lstr_articulo.cod_art
			this.object.desc_art				[al_row] = lstr_articulo.desc_art
			this.object.und					[al_row] = lstr_articulo.und
			
			of_saldos_articulo(al_row)
			
			this.ii_update = 1

			//if of_set_articulo( lstr_articulo.cod_art) = 1 then
			//end if
		end if
		
		Send(Handle(this),256,9,Long(0,0))
		
end choose
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

idw_mst = dw_master
idw_det = dw_detail
end event

event itemchanged;call super::itemchanged;decimal	ldc_cant_proy, ldc_saldo

dw_master.Accepttext()
dw_detail.AcceptText()

CHOOSE CASE dwo.name
	CASE 'cod_art'		
		
		if of_set_articulo( data ) = 0 then 
			this.object.cod_art	[row] = gnvo_app.is_null
			this.object.desc_art	[row] = gnvo_app.is_null
			this.object.und		[row] = gnvo_app.is_null
			
			return 1
		end if
			
		of_saldos_articulo(row)
		return 2
	CASE 'cant_proyect'
		
		ldc_cant_proy 	= Dec(data)
		ldc_saldo		= Dec(this.object.saldo_org [row])
		
		if ldc_cant_proy > ldc_saldo then
			if MessageBox('Aviso', 'No dispone del suficiente saldo para hacer el traslado. Desea continuar?', &
					Information!, YesNo!, 2) = 2 then
				this.object.cant_proyect [row] = gnvo_app.idc_null
				return 1
			end if
		end if
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;//if f_row_Processing( dw_master, "form") <> true then dw_master.TriggerEvent(clicked!)

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
of_set_status_doc(THIS)



end event

event ue_insert_pre;Long		ll_row_mas
string	ls_almacen_org

if dw_master.GetRow() = 0 then return

ls_almacen_org = dw_master.object.almacen_org[dw_master.GetRow()]

if trim(ls_almacen_org) = '' or IsNull(ls_almacen_org) then
	MessageBox('Aviso', 'Almacen de origen esta en blanco')
	return
end if

this.object.cod_origen			[al_row] = gs_origen
this.object.flag_estado			[al_row] = '1'
this.object.flag_modificacion [al_row] = '1'
this.object.flag_mod 			[al_row] = '1'
this.object.fec_registro		[al_row] = gnvo_app.of_fecha_actual()
this.object.fec_proyect			[al_row] = Date(gnvo_app.of_fecha_actual())
this.object.flag_crg_inm_prsp	[al_row] = '0'
this.object.tipo_mov				[al_row] = is_oper_sal_otr
this.object.cant_proyect		[al_row] = 0
this.object.cant_procesada		[al_row] = 0
this.object.cant_facturada		[al_row] = 0
this.object.almacen				[al_row] = ls_almacen_org
this.object.cod_usr				[al_row] = gs_user

this.object.tipo_doc				[al_row] = is_doc_otr
this.object.nro_doc				[al_row] = dw_master.object.nro_otr[1]


this.Modify("cant_proyect.Protect ='1~tIf(IsNull(flag_mod),1,0)'")
this.Modify("cant_proyect.Background.color ='1~tIf(IsNull(flag_mod),RGB(192,192,192),RGB(255,255,255))'")

this.Modify("cod_art.Protect ='1~tIf(IsNull(flag_mod),1,0)'")
this.Modify("cod_art.Background.color ='1~tIf(IsNull(flag_mod),RGB(192,192,192),RGB(255,255,255))'")

this.SetColumn('cod_art')
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
u_dw_abc ldw
str_parametros sl_param
this.AcceptText()

if lower(dwo.name) = 'cant_procesada' or lower(dwo.name) = 'cant_facturada' then
	if is_action = 'new' then return
	
	sl_param.number1 = this.object.nro_mov		[row]
	sl_param.string1 = this.object.cod_origen	[row]
	
	OpenSheetWithParm(w_al730_mov_alm_x_mov_proy, sl_param, w_main, 0, Layered!)
end if

If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
if row = 0 then return

if dwo.name = 'fec_proyect' then
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	this.ii_update = 1
	return
else
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, row)
end if
end event

event dberror;// Override


String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name, ls_Cad
Integer	li_pos_ini, li_pos_fin, li_pos_nc
Long lpos, ll_error, lpos2

ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1

ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)

CHOOSE CASE sqldbcode
//	CASE 1                        // Llave Duplicada
//        Messagebox('Error PK','Llave Duplicada, Linea: ' + String(row))
//        Return 1 
	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        INTO :ls_name
        FROM ALL_CONSTRAINTS
       WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;
        Messagebox('Error FK','Registro Tiene Movimientos en Tabla: '+ls_name)
        Return 1
//	case 20000 to 29999
//		// Encontrar el error
//		
//		lpos = POS( sqlerrtext, ':')
//		ll_error = LONG( MID( sqlerrtext, 5, 5) )			
//		
//		ls_cad = MID( sqlerrtext, lpos + 2, len( sqlerrtext) - lpos )			
//		lpos2 = pos( ls_cad, 'ORA')
//		ls_cad = MID( sqlerrtext, lpos + 2, lpos2 - 1)
//		Messagebox( "Error", ls_cad, stopsign!)
//
//       Return 1
//	
	CASE ELSE
		ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'SQLErrText: ' + SQLErrText + ls_crlf
		ls_msg += 'Linea: ' + String(row) + ls_crlf
		//ls_msg += 'SQLDBCode: ' + String(SQLCA.SQLDBCode) + ls_crlf
		//ls_msg += 'SQLErrText: ' + SQLCA.SQLErrText + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		messagebox("dberror", ls_msg, StopSign!)
END CHOOSE





end event

event ue_output;call super::ue_output;of_saldos_articulo(al_row)
end event

event getfocus;call super::getfocus;if f_row_Processing( dw_master, "form") <> true then 
	dw_master.TriggerEvent(clicked!)
	dw_master.SetFocus()
end if

end event

type dw_master from u_dw_abc within w_al315_orden_traslado
event ue_display ( string as_columna,  long al_row )
integer y = 136
integer width = 3323
integer height = 948
integer taborder = 40
string dataobject = "d_abc_orden_traslado_ff"
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
		
	case "almacen_org"
		ls_almacen = this.object.almacen_dst[al_row]
		
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "desc_almacen AS descripcion_almacen " &
				  + "FROM almacen " &
				  + "where flag_estado = '1' " &
  				  + "order by almacen "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			if Not IsNull(ls_almacen) and ls_almacen <> '' then
				if ls_almacen = ls_codigo then
					MessageBox('Aviso', 'El almacen de origen no debe ser igual al destino')
					This.SetColumn('almacen_org')
					this.SetFocus()
					return
				end if
			end if
			this.object.almacen_org			[al_row] = ls_codigo
			this.object.desc_almacen_org	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
	
	case "almacen_dst"
		ls_almacen = this.object.almacen_org[al_row]
		
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "desc_almacen AS descripcion_almacen " &
				  + "FROM almacen " &
				  + "where flag_estado = '1' " &				  
  				  + "order by almacen "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			if Not IsNull(ls_almacen) and ls_almacen <> '' then
				if ls_almacen = ls_codigo then
					MessageBox('Aviso', 'El almacen de origen no debe ser igual al destino')
					This.SetColumn('almacen_dst')
					this.SetFocus()
					return
				end if
			end if
			this.object.almacen_dst			[al_row] = ls_codigo
			this.object.desc_almacen_dst	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

	case "tipo_doc"
		ls_sql = "SELECT tipo_doc AS codigo_tipo_doc, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose

end event

event constructor;call super::constructor;is_mastdet = 'md'	
is_dwform = 'form' // tabular form

ii_ck[1] = 1				// columnas de lectura de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
idw_det	= dw_detail
end event

event itemchanged;call super::itemchanged;Int 		li_val, li_saldo_consig, li_saldo_pres, li_saldo_dev
string 	ls_nombre, ls_null, ls_mensaje, ls_desc, ls_almacen
DATE 		ld_null

This.AcceptText()
if row = 0 then return

Setnull( ls_null)

CHOOSE CASE lower(dwo.name)
		
	CASE 'almacen_org'
		ls_almacen = this.object.almacen_dst[row]

		SELECT desc_almacen 
			INTO :ls_desc
		FROM almacen
   	WHERE  almacen = :data
		  and flag_estado = '1'; 
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCOde = 100 then
				Messagebox('Aviso','Codigo de almacen de origen no existe o no esta activo')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.almacen_org			[row] = ls_null
			this.object.desc_almacen_org	[row] = ls_null
			this.setcolumn( "almacen_org" )
		 	this.setfocus()
			RETURN 1
		END IF
		
		if Not IsNull(ls_almacen) and ls_almacen <> '' then
			if ls_almacen = data then
				MessageBox('Aviso', 'El almacen de origen no debe ser igual al destino')
				This.SetColumn('almacen_org')
				this.SetFocus()
				return
			end if
		end if
		
		this.object.desc_almacen_org [row] = ls_desc

	CASE 'almacen_dst'
		ls_almacen = this.object.almacen_org[row]

		SELECT desc_almacen 
			INTO :ls_desc
		FROM almacen
   	WHERE  almacen = :data
		  and flag_estado = '1'; 
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCOde = 100 then
				Messagebox('Aviso','Codigo de almacen de destino no existe o no esta activo')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.almacen_dst			[row] = ls_null
			this.object.desc_almacen_dst	[row] = ls_null
			this.setcolumn( "almacen_dst" )
		 	this.setfocus()
			RETURN 1
		END IF
		
		if Not IsNull(ls_almacen) and ls_almacen <> '' then
			if ls_almacen = data then
				MessageBox('Aviso', 'El almacen de origen no debe ser igual al destino')
				This.SetColumn('almacen_dst')
				this.SetFocus()
				return
			end if
		end if		
		
		this.object.desc_almacen_dst [row] = ls_desc
		
	CASE 'tipo_doc'
		
		SELECT desc_tipo_doc 
			INTO :ls_desc 
		FROM doc_tipo
   	WHERE  tipo_doc = :data ;
		
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCOde = 100 then
				Messagebox('Aviso','Tipo de Documento no existe ')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.tipo_doc  [row] = ls_null
			this.setcolumn( "tipo_doc" )
			this.setfocus()
			RETURN 1
		END IF
		
END CHOOSE

end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;String	ls_nom_usr
Long 		ll_ano, ll_mes

select nombre
	into :ls_nom_usr
from usuario
where cod_usr = :gs_user;

this.object.flag_estado 	[al_row] = '1'		// Activo
this.object.usr_registra 	[al_row] = gs_user
this.object.nom_usr_reg 	[al_row] = ls_nom_usr
this.object.fec_registro	[al_row] = id_fecha_proc   //ld_fec
this.object.fec_registro.protect = 1

is_action = 'new'

ll_ano = YEAR( DATE(id_fecha_proc))
ll_mes = MONTH( DATE(id_fecha_proc))

// Busca si esta cerrado contablemente	
Select NVL( flag_gen_asnt_autom,0) 
	into :ii_cerrado
from cntbl_cierre 
where ano = :ll_ano 
  and mes = :ll_mes;
  
if ii_cerrado = 0 then
	dw_master.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
else
	dw_master.object.t_cierre.text = ''
end if 

this.Object.p_logo.filename = gs_logo
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
of_set_status_doc(THIS)

end event

event dberror;//Override


String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
Integer	li_pos_ini, li_pos_fin, li_pos_nc

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
             (CONSTRAINT_NAME = :ls_const ));
		ROLLBACK;
      Messagebox('Error FK','Registro Tiene Movimientos en Tabla: '+ls_name)
      Return 1
	CASE -3
		ROLLBACK;
		Messagebox( "Error Fatal", 'Operacion no podra ser grabada, ~r~ncomunicar con sistemas', stopsign!)

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

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
u_dw_abc	ldw

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
if row = 0 then return

ls_columna = upper(dwo.name)
this.event dynamic ue_display(ls_columna, row)

end event

type gb_1 from groupbox within w_al315_orden_traslado
integer y = 1680
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

type r_1 from rectangle within w_al315_orden_traslado
integer linethickness = 4
long fillcolor = 16777215
integer x = 2583
integer y = 844
integer width = 165
integer height = 144
end type

