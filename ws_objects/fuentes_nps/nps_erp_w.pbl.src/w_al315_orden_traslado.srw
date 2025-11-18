$PBExportHeader$w_al315_orden_traslado.srw
forward
global type w_al315_orden_traslado from w_abc
end type
type dw_1 from datawindow within w_al315_orden_traslado
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
type sle_nro from singlelineedit within w_al315_orden_traslado
end type
type st_nro from statictext within w_al315_orden_traslado
end type
type em_saldo_org from editmask within w_al315_orden_traslado
end type
type dw_detail from u_dw_abc within w_al315_orden_traslado
end type
type dw_master from u_dw_abc within w_al315_orden_traslado
end type
type gb_1 from groupbox within w_al315_orden_traslado
end type
type st_1 from statictext within w_al315_orden_traslado
end type
end forward

global type w_al315_orden_traslado from w_abc
integer width = 4311
integer height = 2424
string title = "Orden de Traslado (AL315)"
string menuname = "m_mov_almacen"
windowstate windowstate = maximized!
boolean clientedge = true
event ue_anular ( )
event ue_cancelar ( )
event ue_preview ( )
event ue_cerrar ( )
dw_1 dw_1
st_3 st_3
st_2 st_2
em_saldo_dst_und2 em_saldo_dst_und2
em_saldo_dst em_saldo_dst
st_4 st_4
em_saldo_org_und2 em_saldo_org_und2
cb_1 cb_1
sle_nro sle_nro
st_nro st_nro
em_saldo_org em_saldo_org
dw_detail dw_detail
dw_master dw_master
gb_1 gb_1
st_1 st_1
end type
global w_al315_orden_traslado w_al315_orden_traslado

type variables
// Tipos de movimiento
String 		is_action, is_doc_otr, is_salir, is_tabla, is_colname[], &
				is_coltype[], is_oper_ing_otr, is_oper_sal_otr, is_doc_gr
			
Int 			ii_ref, ii_cerrado
DATETIME 	id_fecha_proc
Boolean 		ib_log = FALSE, ib_mod=false, ib_control_lin = false 

n_cst_log_diario	in_log
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
public function integer of_item_duplicados ()
public subroutine of_aprobar_otr ()
public function boolean of_anular_mov_proy ()
public function integer of_verifica_dup (string as_cod_art)
public function boolean of_anular_guia ()
public function integer of_set_numera_guia (ref string as_nro_guia)
public function boolean of_generar_guia ()
end prototypes

event ue_anular;Integer j
Long ll_row
String ls_estado

IF dw_master.GetRow() = 0 then return

ll_row = dw_master.GetRow()

// Fuerza a leer detalle
dw_detail.retrieve(dw_master.object.nro_otr[ll_row])

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

ls_estado	= dw_master.object.flag_estado[ll_row]

if ls_estado <> '1' then
	MessageBox('Aviso', 'El documento no se puede anular')
	return
end if

// Anulando Cabecera
dw_master.object.flag_estado			[ll_row] = '0'
dw_master.object.flag_generar_guia	[ll_row] = '0'

// Anulando Detalle
for j = 1 to dw_detail.rowCount()	
	dw_detail.object.flag_estado		  	[j] = '0'
	dw_detail.object.flag_modificacion	[j] = '0'
next

dw_master.ii_update = 1
dw_detail.ii_update = 1
is_action = 'anu'
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
str_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 = 'd_frm_orden_traslado'
lstr_rep.titulo = 'Previo de Orden de Traslado'
lstr_rep.string1 = dw_master.object.nro_otr[dw_master.getrow()]
lstr_rep.tipo = '1S'

OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
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
SELECT doc_otr, oper_ing_otr, oper_sal_otr, doc_gr
		INTO :is_doc_otr, :is_oper_ing_otr, :is_oper_sal_otr, :is_doc_gr
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
m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles( is_niveles, 'I')  // true
m_master.m_file.m_basedatos.m_eliminar.enabled = f_niveles( is_niveles, 'E')  //true
m_master.m_file.m_basedatos.m_modificar.enabled 	= f_niveles( is_niveles, 'M') //true
m_master.m_file.m_basedatos.m_anular.enabled 		= true
m_master.m_file.m_basedatos.m_abrirlista.enabled 	= true
//m_master.m_file.m_basedatos.m_cerrar.enabled 		= true
m_master.m_file.m_printer.m_print1.enabled 			= true


if dw_master.getrow() = 0 then return 0

if is_Action = 'new' then
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	//m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
	m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles( is_niveles, 'I')	

	if idw_1 = dw_detail then
		m_master.m_file.m_basedatos.m_eliminar.enabled = f_niveles( is_niveles, 'I')
	end if
end if

if is_Action = 'open' then
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])	
	
	Choose case li_estado
		case 0 	// Anulado 
			m_master.m_file.m_basedatos.m_eliminar.enabled 		= false
			m_master.m_file.m_basedatos.m_modificar.enabled 	= false
			m_master.m_file.m_basedatos.m_anular.enabled 		= false	
			//m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
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
	//m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
	m_master.m_file.m_printer.m_print1.enabled 			= false
end if

return 1
end function

public function integer of_set_numera ();// Numera documento
Long j
String  ls_next_nro

if dw_master.getrow() = 0 then return 0

if is_action = 'new' then
	ls_next_nro = of_next_nro(gnvo_app.is_origen)
	if IsNull(ls_next_nro) or ls_next_nro = '' then return 0
	
	dw_master.object.nro_otr[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
else
	ls_next_nro = dw_master.object.nro_otr[dw_master.getrow()] 
end if
// Asigna numero a detalle
for j = 1 to dw_detail.RowCount()
	dw_detail.object.nro_otr[j] = ls_next_nro
next

return 1
end function

public subroutine of_boton_modificar (string as_ventana);String ls_mod

Select NVL( flag_modificar, '') 
	into :ls_mod 
from usuario_obj 
where cod_usr = :gnvo_app.is_user 
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
end subroutine

public function integer of_set_articulo (string as_articulo);String 	ls_unidad, ls_desc_art, ls_und, ls_msg, ls_almacen_org, &
			ls_almacen_dst, ls_flag_inv, ls_flag_estado
Decimal 	ldc_saldo, ldc_saldo_und2
Long 		ll_row

ll_row = dw_master.GetRow()
if ll_Row = 0 then return 0

ls_almacen_org = dw_master.object.almacen_org[ll_row]
ls_almacen_dst = dw_master.object.almacen_dst[ll_row]

if ls_almacen_org = '' or IsNull(ls_almacen_org) then
	MessageBox('Aviso', 'No ha definido el almacen origen')
	return 0
end if

if ls_almacen_org = '' or IsNull(ls_almacen_org) then
	MessageBox('Aviso', 'No ha definido el almacen destino')
	return 0
end if

// Verifica que codigo ingresado exista			
Select 	desc_art, und, NVL(flag_inventariable, '0'), NVL(flag_estado, '0')
	into 	:ls_desc_art, :ls_und, :ls_flag_inv, :ls_flag_estado
from articulo 
Where cod_Art = :as_articulo;

if Sqlca.sqlcode = 100 then 
	ROLLBACK;
	Messagebox( "Atencion", "Codigo de articulo: '" + as_articulo &
		+ " no existe", StopSign!)
	Return 0
end if		

if SQLCA.SQLCode < 0 then
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_msg)
	return 0
end if

if ls_flag_estado = '0' then
	Messagebox( "Atencion", "Codigo de articulo: '" + as_articulo &
		+ " esta inactivo", StopSign!)
	Return 0
end if

if ls_flag_inv = '0' then
	Messagebox( "Atencion", "Codigo de articulo: '" + as_articulo &
		+ " no es inventariable", StopSign!)
	Return 0
end if

ll_row = dw_detail.GetRow()
if ll_row = 0 then
	MessageBox('Aviso', 'Error, no existe ninguna fila en el detalles')
	return 0
end if

dw_detail.object.cod_art	[ll_row] = as_articulo
dw_detail.object.desc_Art	[ll_row] = ls_desc_art
dw_detail.object.und			[ll_row] = ls_und	

//Saldos en Almacen Origen
SELECT Nvl(sldo_total,0), NVL(sldo_total_und2,0)
	INTO   :ldc_saldo, :ldc_saldo_und2
FROM  articulo_almacen
WHERE almacen = :ls_almacen_org 
  AND cod_art = :as_articulo ; 		
		
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
  AND cod_art = :as_articulo ; 		
		
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

ll_row = dw_master.retrieve(as_nro_otr)
is_action = 'open'

if ll_row > 0 then
	dw_master.object.p_logo.filename = gnvo_app.is_logo
	
	// Fuerza a leer detalle
	dw_detail.retrieve(as_nro_otr)
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	of_set_status_doc( dw_master )
end if

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
			 USR_AUTORIZA = :gnvo_app.is_user,
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
		values( :gnvo_app.is_user, '0', :ls_cod_art, :is_oper_ing_otr,
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

public function boolean of_anular_guia ();if dw_master.GetRow() = 0 then return true

long 		ll_row
string	ls_nro_guia, ls_org_guia, ls_mensaje, ls_nro_otr

ll_row = dw_master.GetRow()

ls_org_guia	= dw_master.object.org_guia	[ll_row]
ls_nro_guia = dw_master.object.nro_guia	[ll_row]
ls_nro_otr 	= dw_master.object.nro_otr		[ll_row]

if IsNull(ls_nro_guia) or ls_nro_guia = "" then return true

//Elimino el detalle de la guia de remisión
delete guia_vale
 where origen_guia = :ls_org_guia
   and nro_guia 	 = :ls_nro_guia;

IF SQLCA.SQLCode = -1 then
	ls_mensaje = "Error al eliminar detalle de Guia de REMISIÓN: " + ls_nro_guia &
				+ ", " + SQLCA.SQLErrText
	ROLLBACK;
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje)
	return false
end if

//Anulo la cabecera de la guía
update Guia
   set flag_estado = '0'
 where cod_origen = :ls_org_guia
   and nro_guia 	= :ls_nro_guia;

IF SQLCA.SQLCode = -1 then
	ls_mensaje = "Error al anular Cabecera de Guia de REMISIÓN: " + ls_nro_guia &
				+ ", " + SQLCA.SQLErrText
	ROLLBACK;
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje)
	return false
end if

//Quito la referencia de la guia en la Orden de Traslado
setNull(ls_org_guia) 
setNull(ls_nro_guia)

update orden_traslado
   set org_guia = :ls_org_guia,
		 nro_guia = :ls_nro_guia
 where nro_otr = :ls_nro_otr;
 
IF SQLCA.SQLCode = -1 then
	ls_mensaje = "Error al quitar le referencia de la Guia de REMISIÓN: " + ls_nro_guia &
				+ ", en la Orden de Traslado: "+ ls_nro_otr + ". Error: " + SQLCA.SQLErrText
	ROLLBACK;
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje)
	return false
end if

return true
end function

public function integer of_set_numera_guia (ref string as_nro_guia);String 	ls_table, ls_msg
Long 		ll_nro, j, ll_nro_serie, ll_count

// Numera documento
if dw_master.object.serie.text = "" then
	ROLLBACK;
	Messagebox( "Error", "Debe especificar la serie", Exclamation!)
	Return 0
end if

ll_nro_serie = Integer( dw_master.object.serie.text )

SELECT count(*)
	INTO :ll_count
FROM num_doc_tipo
WHERE tipo_doc  = :is_doc_gr 
  AND nro_serie = :ll_nro_serie
  and cod_empresa = :gnvo_app.invo_empresa.is_empresa;

if ll_count = 0 then
	ROLLBACK;
	Messagebox( "Error", "Defina la numeracion", Exclamation!)
	Return 0
end if

SELECT ultimo_numero
	INTO :ll_nro
FROM num_doc_tipo
WHERE tipo_doc  = :is_doc_gr 
  AND nro_serie = :ll_nro_serie 
  and cod_empresa = :gnvo_app.invo_empresa.is_empresa for update;

if SQLCA.SQLCode <> 0 then
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error en num_doc_tipo", ls_msg)
	Return 0
end if;

// Incrementa contador
UPDATE num_doc_tipo
	SET ultimo_numero = ultimo_numero + 1
WHERE  tipo_doc  = :is_doc_gr
  AND nro_serie  = :ll_nro_serie
  and cod_empresa = :gnvo_app.invo_empresa.is_empresa;	

IF SQLCA.SQLCode <> 0 THEN 
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("SQL error", ls_msg )
	Return 0
END IF

// Genero el nuevo numero de guia
as_nro_guia = String(ll_nro_serie, '000')+ '-' + String(ll_nro, '000000')


return 1
end function

public function boolean of_generar_guia ();if dw_master.GetRow() = 0 then return true

long 		ll_row, ll_count
string	ls_nro_guia, ls_org_guia, ls_mensaje, ls_nro_otr, ls_almacen_dst, &
			ls_direccion, ls_cliente, ls_nom_cliente, ls_org_vale, ls_nro_vale, &
			ls_almacen_org

ll_row = dw_master.GetRow()

ls_org_guia	= dw_master.object.org_guia	[ll_row]
ls_nro_guia = dw_master.object.nro_guia	[ll_row]
ls_nro_otr 	= dw_master.object.nro_otr		[ll_row]

if IsNull(ls_nro_guia) or ls_nro_guia = "" then 
	if of_set_numera_guia(ls_nro_guia) = 0 then return false
	ls_org_guia = dw_master.object.cod_origen	[ll_row]
end if

//Verifico si existe o no la cabecera de la GUIA sino la creo
select count(*)
  into :ll_count
  from guia
 where cod_origen  = :ls_org_guia
   and nro_guia 	 = :ls_nro_guia;

if ll_count = 0 then
	//Inserto la cabecera de la Guia de remision
	//Name                Type          Nullable Default Comments            
	//------------------- ------------- -------- ------- ------------------- 
	//COD_ORIGEN          CHAR(2)                        codigo origen       
	//NRO_GUIA            CHAR(10)                       nro guia            
	//ALMACEN             CHAR(6)                        cod almacen         
	//FEC_REGISTRO        DATE          Y                fec registro        
	//FEC_IMPRESION       DATE          Y                fec impresion       
	//FLAG_ESTADO         CHAR(1)       Y        '1'     flag estado         
	//MOTIVO_TRASLADO     CHAR(2)                        motivo traslado     
	//CLIENTE             CHAR(8)       Y                cod cliente         
	//CENCOS              CHAR(10)      Y                centro costo        
	//DESTINATARIO        VARCHAR2(40)  Y                destinatario        
	//NOM_CHOFER          CHAR(40)      Y                nom chofer          
	//NRO_BREVETE         CHAR(12)      Y                nro brevete         
	//NRO_PLACA           CHAR(8)       Y                nro placa camion    
	//NRO_PLACA_CARRETA   CHAR(8)       Y                nro placa carreta   
	//DESTINO             VARCHAR2(200) Y                destino             
	//TIPO_DOC            CHAR(4)       Y                tipo doc            
	//NRO_DOC             CHAR(10)      Y                nro doc             
	//COD_USR             CHAR(6)       Y                cod usuario         
	//PROV_TRANSP         CHAR(8)       Y                prov transporte     
	//OBS                 VARCHAR2(100) Y                obs                 
	//FEC_INICIO_TRASLADO DATE          Y                fec inicio traslado 
	//MARCA_VEHICULO      VARCHAR2(25)  Y                marca vehiculo      
	//CERT_INSC_MTC       VARCHAR2(29)  Y                cert insc mtc       
	//CLIENTE_FINAL       CHAR(8)       Y                cliente final       
	//NRO_CERTIFICADO     CHAR(10)      Y                nro certificado     
	//FLAG_REPLICACION    CHAR(1)       Y        '1'     flag_replicacion    
	//CANT_PARIHUELA      NUMBER(2)     Y                cant parihuela      
	//PESO_PARIHUELA      NUMBER(10,2)  Y                peso parihuela      
	//NOM_CLIENTE         VARCHAR2(100) Y              	
	
	//Obtengo el almacen destino
	ls_almacen_dst = dw_master.object.almacen_dst [ll_row]
	ls_almacen_org = dw_master.object.almacen_org [ll_row]
	
	select direccion
		into :ls_direccion
		from almacen
	where almacen = :ls_almacen_dst;
	
	insert into guia(
		cod_origen, nro_guia, almacen, fec_registro, flag_estado, motivo_traslado, 
		cliente, nom_cliente, destino, cod_usr, fec_inicio_traslado)	
	values(
		:ls_org_guia, :ls_nro_guia, :ls_almacen_org, sysdate, '1', '07',
		:gnvo_app.invo_empresa.is_empresa, :gnvo_app.invo_empresa.is_desc_empresa, 
		:ls_direccion, :gnvo_app.is_user, sysdate);
	
	IF SQLCA.SQLCode = -1 then
		ls_mensaje = "Error al eliminar detalle de Guia de REMISIÓN: " + ls_nro_guia &
					+ ", " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_log.of_errorlog( ls_mensaje )
		gnvo_app.of_showmessagedialog( ls_mensaje)
		return false
	end if

end if;

//Ahora añado el movimiento de almacen al detalle de la guia
insert into guia_vale(
	origen_guia, nro_guia, origen_vale, nro_vale)
select :ls_org_guia, :ls_nro_guia, odt.org_am_sal, am.nro_vale
from orden_traslado_det odt,
     articulo_mov       am
where odt.org_am_sal = am.cod_origen
  and odt.nro_am_sal = am.nro_mov
  and odt.nro_otr    = :ls_nro_otr
  and am.nro_vale not in (select gv.nro_vale
                            from guia_vale gv
                           where gv.origen_guia = :ls_org_guia
                             and gv.nro_guia    = :ls_nro_guia);

IF SQLCA.SQLCode = -1 then
	ls_mensaje = "Error al insertar detalle de Guia de REMISIÓN: " + ls_nro_guia &
				+ ", " + SQLCA.SQLErrText
	ROLLBACK;
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje)
	return false
end if

//Añado la referencia de la guia en la Orden de Traslado
update orden_traslado
   set org_guia = :ls_org_guia,
		 nro_guia = :ls_nro_guia
 where nro_otr = :ls_nro_otr;
 
IF SQLCA.SQLCode = -1 then
	ls_mensaje = "Error al Añadir le referencia de la Guia de REMISIÓN: " + ls_nro_guia &
				+ ", en la Orden de Traslado: "+ ls_nro_otr + ". Error: " + SQLCA.SQLErrText
	ROLLBACK;
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje)
	return false
end if

return true
end function

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
else

	dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
	dw_detail.SetTransObject(sqlca)
	dw_1.SetTransObject(sqlca)

	idw_1 = dw_master              		// asignar dw corriente
	idw_1.TriggerEvent(clicked!)

	dw_master.of_protect()         		// bloquear modificaciones 
	dw_detail.of_protect()

	ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
	// ii_help = 101     
   
	ib_log = TRUE
	is_tabla = 'orden_traslado'
	
	dw_master.object.p_logo.filename = gnvo_app.is_logo
	
	of_boton_modificar(THIS.ClassName())  // Activa/desactiva boton de modificar segun acceso
end if
end event

event ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

// verifica que tenga datos de detalle
if dw_detail.rowcount() = 0 then
	Messagebox( "Atencion", "Debe ingresar algun detalle en la orden de traslado")
	return
end if

if of_set_numera() = 0 then return

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()


ib_update_check = true


end event

on w_al315_orden_traslado.create
int iCurrent
call super::create
if this.MenuName = "m_mov_almacen" then this.MenuID = create m_mov_almacen
this.dw_1=create dw_1
this.st_3=create st_3
this.st_2=create st_2
this.em_saldo_dst_und2=create em_saldo_dst_und2
this.em_saldo_dst=create em_saldo_dst
this.st_4=create st_4
this.em_saldo_org_und2=create em_saldo_org_und2
this.cb_1=create cb_1
this.sle_nro=create sle_nro
this.st_nro=create st_nro
this.em_saldo_org=create em_saldo_org
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.gb_1=create gb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_saldo_dst_und2
this.Control[iCurrent+5]=this.em_saldo_dst
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.em_saldo_org_und2
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.sle_nro
this.Control[iCurrent+10]=this.st_nro
this.Control[iCurrent+11]=this.em_saldo_org
this.Control[iCurrent+12]=this.dw_detail
this.Control[iCurrent+13]=this.dw_master
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.st_1
end on

on w_al315_orden_traslado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_saldo_dst_und2)
destroy(this.em_saldo_dst)
destroy(this.st_4)
destroy(this.em_saldo_org_und2)
destroy(this.cb_1)
destroy(this.sle_nro)
destroy(this.st_nro)
destroy(this.em_saldo_org)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.st_1)
end on

event ue_insert;Long  	ll_row, ll_ano, ll_mes, ll_mov_atrazados
string	ls_msg
n_cst_diaz_retrazo lnvo_amp_retr

if idw_1 = dw_master and is_action = 'new' then
	Messagebox( "Atencion", "No puede adicionar otro documento, grabe el actual", exclamation!)
	return
end if

IF idw_1 = dw_detail THEN	
//	if is_Action <> 'new' then
//		MessageBox("Error", "No se puede insertar otro item a esta Orden de Traslado")
//		RETURN
//	end if
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

id_fecha_proc = f_fecha_actual(0) 

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
	dw_master.object.p_logo.filename = gnvo_app.is_logo
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
	ib_control_lin = FALSE
	u_ds_base		lds_log
	lds_log = Create u_ds_base
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gnvo_app.is_user, is_tabla, gnvo_app.invo_empresa.is_empresa)
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN	
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Master"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

IF dw_detail.ii_update = 1 THEN	
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Detalle"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update(true, false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	
	//Verifico si anulo o genero la guia de remision
	if dw_master.GetRow() > 0 then
		if dw_master.object.Flag_generar_guia [dw_master.GeTRow()] = '0' then
			if not of_anular_guia() then return
		else
			if not of_generar_guia() then return
		end if;
		
	end if;
	
	COMMIT using SQLCA;
	
	// En Esta parte se aprueba de Orden de Traslado
	//of_aprobar_otr()	
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
	dw_detail.retrieve(dw_master.object.nro_otr[dw_master.GetRow()])
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

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_lista_ordenes_traslado_grd'
sl_param.titulo = 'Ordenes de Traslado'
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.string1 = gnvo_app.invo_empresa.is_empresa
sl_param.tipo = '1S'

OpenWithParm( w_lista, sl_param)

sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_insert_pos;call super::ue_insert_pos;idw_1.setcolumn(1)
end event

event ue_print;call super::ue_print;// vista previa de orden de traslado
//str_parametros lstr_rep
//
//if dw_master.rowcount() = 0 then return
//
//lstr_rep.titulo 	= 'Orden de Traslado'
//lstr_rep.string1 	= dw_master.object.nro_otr	[dw_master.getrow()]
//
//OpenSheetWithParm(w_al315_orden_traslado_frm, lstr_rep, w_main, 0, layered!)

this.event ue_preview()
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

event ue_open_pos();call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(idw_1, is_colname, is_coltype)
END IF
end event

type p_pie from w_abc`p_pie within w_al315_orden_traslado
end type

type ole_skin from w_abc`ole_skin within w_al315_orden_traslado
end type

type uo_h from w_abc`uo_h within w_al315_orden_traslado
end type

type st_box from w_abc`st_box within w_al315_orden_traslado
end type

type phl_logonps from w_abc`phl_logonps within w_al315_orden_traslado
end type

type p_mundi from w_abc`p_mundi within w_al315_orden_traslado
end type

type p_logo from w_abc`p_logo within w_al315_orden_traslado
end type

type dw_1 from datawindow within w_al315_orden_traslado
boolean visible = false
integer x = 1751
integer y = 24
integer width = 370
integer height = 72
integer taborder = 30
boolean enabled = false
string title = "none"
string dataobject = "d_abc_orden_traslado_det_tbl"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

type st_3 from statictext within w_al315_orden_traslado
integer x = 3072
integer y = 2120
integer width = 366
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
integer x = 2231
integer y = 2120
integer width = 366
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
integer x = 3479
integer y = 2112
integer width = 366
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
integer x = 2651
integer y = 2112
integer width = 366
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
integer x = 1390
integer y = 2120
integer width = 366
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
integer x = 1810
integer y = 2112
integer width = 366
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
integer x = 1413
integer y = 172
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

type sle_nro from singlelineedit within w_al315_orden_traslado
integer x = 846
integer y = 176
integer width = 512
integer height = 92
integer taborder = 20
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

event modified;dw_detail.reset()
cb_1.event clicked()
end event

type st_nro from statictext within w_al315_orden_traslado
integer x = 553
integer y = 188
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
string text = "Numero:"
boolean focusrectangle = false
end type

type em_saldo_org from editmask within w_al315_orden_traslado
integer x = 969
integer y = 2108
integer width = 366
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

type dw_detail from u_dw_abc within w_al315_orden_traslado
event ue_display ( string as_columna,  long al_row )
integer x = 498
integer y = 1232
integer width = 3323
integer height = 552
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_abc_orden_traslado_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
integer ii_sort = 1
end type

event ue_display;// Abre ventana de ayuda 
boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_null
str_parametros sl_param

SetNull(ls_null)

choose case lower(as_columna)
		
	case "cod_art"
		
		OpenWithParm (w_pop_articulos_stock, parent)
		sl_param = MESSAGE.POWEROBJECTPARM
		IF sl_param.titulo <> 'n' then
			if sl_param.field_ret[5] <> dw_master.object.almacen_org [dw_master.GetRow()] then
				MessageBox('Error', 'Solo puede elegir articulos que salgan del almacen origen')
				return
			end if
			
			if of_set_articulo( sl_param.field_ret[1]) = 1 then
				this.object.cod_art			[al_row] = sl_param.field_ret[1]
				this.object.desc_art			[al_row] = sl_param.field_ret[2]
				this.object.und				[al_row] = sl_param.field_ret[3]
				this.object.numero_serie	[al_row] = sl_param.field_ret[4]
				this.ii_update = 1
			end if
		END IF

		
		Send(Handle(this),256,9,Long(0,0))
		
end choose
end event

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

event itemchanged;call super::itemchanged;string 	ls_null
decimal	ldc_cant_proy, ldc_saldo, ldc_null

SetNull( ldc_null )
SetNull( ls_null )

dw_master.Accepttext()
dw_detail.AcceptText()

CHOOSE CASE dwo.name
	CASE 'cod_art'		
		if of_set_articulo( data ) = 0 then 
			
			this.object.cod_art	[row] = ls_null
			this.object.desc_art	[row] = ls_null
			this.object.und		[row] = ls_null
			
			return 1
		end if
		
	CASE 'cant_proyect'
		ldc_cant_proy 	= Dec(data)
		ldc_saldo		= Dec(em_saldo_org.text)
		
		if ldc_cant_proy > ldc_saldo then
			if MessageBox('Aviso', 'No dispone del suficiente saldo. Desea continuar?', &
					Information!, YesNo!, 2) = 2 then
				this.object.cant_proyect [row] = ldc_null
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

this.object.flag_estado			[al_row] = '1'
this.object.cant_procesada		[al_row] = 0
this.object.cod_usr				[al_row] = gnvo_app.is_user
this.object.nro_item				[al_row] = f_numera_item(this)


ll_row_mas = dw_master.GetRow()
if ll_row_mas = 0 then return

this.SetColumn('cod_art')
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
integer x = 498
integer y = 280
integer width = 3323
integer height = 948
integer taborder = 40
string dataobject = "d_abc_orden_traslado_ff"
boolean livescroll = false
integer ii_sort = 1
end type

event ue_display;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_null

this.AcceptText()
SetNull(ls_null)

choose case lower(as_columna)

	case "serie"
		ls_sql = "SELECT distinct b.desc_tipo_doc as descripcion_tipo_doc, " &
				  + "a.nro_serie AS Numero_serie " &
				  + "FROM doc_tipo_usuario a, " &
				  + "doc_tipo b, " &
				  + "num_doc_tipo ndt " &
				  + "WHERE a.tipo_doc = b.tipo_doc " &
				  + "AND ndt.tipo_doc = a.tipo_doc " &
				  + "AND ndt.nro_serie = a.nro_serie " &
				  + "AND ndt.cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "' " &
				  + "AND a.cod_usr = '" + gnvo_app.is_user + "' " &
				  + "AND a.tipo_doc  = '" + is_doc_gr + "'"
				 
		lb_ret = f_lista(ls_sql, ls_data, ls_codigo, '1')
		
		if ls_codigo <> '' then
			this.object.serie.text = string(long(ls_codigo),'000')
		end if

	case "almacen_org"
		ls_almacen = this.object.almacen_dst[al_row]
		
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "desc_almacen AS descripcion_almacen " &
				  + "FROM almacen " &
				  + "where flag_estado = '1' " &
				  + "  and cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "' " &				   
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
				  + "  and cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "' " &				   
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
				  + "FROM doc_tipo " &
				  + "where flag_estado = '1'"
				 
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
ii_ck[2] = 2
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
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
where cod_usr = :gnvo_app.is_user;

this.object.flag_estado 		[al_row] = '1'		// Activo
this.object.usr_registra 		[al_row] = gnvo_app.is_user
this.object.nom_usr_reg 		[al_row] = ls_nom_usr
this.object.fec_registro		[al_row] = id_fecha_proc   //ld_fec
this.object.cod_empresa			[al_row] = gnvo_app.invo_empresa.is_empresa   //ld_fec
this.object.cod_origen			[al_row] = gnvo_app.is_origen   //ld_fec
this.object.flag_generar_guia	[al_row] = '0'

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

event buttonclicked;call super::buttonclicked;// vista previa de guia
str_parametros lstr_rep


if lower(dwo.name) = 'b_imprimir_guia' then
	
	IF gnvo_app.invo_empresa.is_empresa = 'E0000004' THEN
		lstr_rep.dw1 = 'd_rpt_guia_remision_rhh'
	else
		lstr_rep.dw1 = 'd_rpt_guia_remision'
	end if
	
	lstr_rep.titulo = 'Previo de Guia de remision'
	lstr_rep.string1 = dw_master.object.org_guia	[row]
	lstr_rep.string2 = dw_master.object.nro_guia	[row]
	lstr_rep.tipo 	  = '1S2S'
	
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
	
elseif lower(dwo.name) = 'b_masivo' then	
	
	if this.object.flag_estado[row] = '0' then
		MessageBox('Error', 'El registro esta anulado')
	end if
	
	lstr_rep.dw_m = this
	lstr_rep.dw_d = dw_detail
	lstr_rep.tipo = 'T'
	OpenWithParm(w_al302_ingreso_masivo, lstr_rep)

end if
end event

type gb_1 from groupbox within w_al315_orden_traslado
integer x = 494
integer y = 2072
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

type st_1 from statictext within w_al315_orden_traslado
integer x = 549
integer y = 2120
integer width = 366
integer height = 64
boolean bringtotop = true
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

