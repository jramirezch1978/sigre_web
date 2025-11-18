$PBExportHeader$w_cm311_orden_compra.srw
forward
global type w_cm311_orden_compra from w_abc
end type
type rb_catalogo from radiobutton within w_cm311_orden_compra
end type
type cb_1 from commandbutton within w_cm311_orden_compra
end type
type st_nro from statictext within w_cm311_orden_compra
end type
type sle_ori from singlelineedit within w_cm311_orden_compra
end type
type st_ori from statictext within w_cm311_orden_compra
end type
type pb_1 from picturebutton within w_cm311_orden_compra
end type
type rb_ot from radiobutton within w_cm311_orden_compra
end type
type rb_programa from radiobutton within w_cm311_orden_compra
end type
type gb_1 from groupbox within w_cm311_orden_compra
end type
type dw_master from u_dw_abc within w_cm311_orden_compra
end type
type dw_detail from u_dw_abc within w_cm311_orden_compra
end type
type em_vn from editmask within w_cm311_orden_compra
end type
type em_imp from editmask within w_cm311_orden_compra
end type
type em_dcto from editmask within w_cm311_orden_compra
end type
type em_vb from editmask within w_cm311_orden_compra
end type
type st_4 from statictext within w_cm311_orden_compra
end type
type st_3 from statictext within w_cm311_orden_compra
end type
type st_2 from statictext within w_cm311_orden_compra
end type
type st_1 from statictext within w_cm311_orden_compra
end type
type sle_nro from u_sle_codigo within w_cm311_orden_compra
end type
end forward

global type w_cm311_orden_compra from w_abc
integer width = 4201
integer height = 4732
string title = "Orden de Compras [CM311]"
string menuname = "m_mtto_lista"
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
event ue_cancelar ( )
event ue_mail ( )
event ue_cerrar ( )
rb_catalogo rb_catalogo
cb_1 cb_1
st_nro st_nro
sle_ori sle_ori
st_ori st_ori
pb_1 pb_1
rb_ot rb_ot
rb_programa rb_programa
gb_1 gb_1
dw_master dw_master
dw_detail dw_detail
em_vn em_vn
em_imp em_imp
em_dcto em_dcto
em_vb em_vb
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
sle_nro sle_nro
end type
global w_cm311_orden_compra w_cm311_orden_compra

type variables
String 	is_action = '' 
String 	is_ref, is_doc_oc, is_salir, is_doc_prog, is_cencos, is_cnta_prsp, &
			is_soles, is_cod_igv, is_oper_ing_oc, is_doc_sc, is_oper_cons_int, &
			is_cencos_oc, is_cnta_prsp_oc, is_doc_ot, is_FLAG_RESTRIC_COMP_OC, &
			is_flag_aut_oc, is_flag_cntrl_fondos, is_doc_aoc, is_flag_mod_fec_oc, &
			is_FLAG_OC_PRSP
			
REAL 		in_tipo_cambio, in_precio = 0.00, in_cantidad = 0.00 
string	is_backColor
DateTime	id_fecha_proc
Boolean	ib_log = TRUE
// Para el registro del Log
string 	is_tabla_m, is_colname_m[], is_coltype_m[], &
			is_tabla_d, is_colname_d[], is_coltype_d[]

n_cst_log_diario	in_log
end variables

forward prototypes
public subroutine of_email ()
public subroutine of_retrieve (string as_origen, string as_nro)
public function integer of_set_status_doc (datawindow idw)
public function integer of_set_numera ()
public function integer of_verifica_datos ()
public function integer of_verifica_datos_det ()
public function integer of_get_param ()
public subroutine of_set_total_oc ()
public function integer of_crea_mov_proy ()
public function boolean of_set_articulo (string as_cod_art)
public function integer of_oc_importacion ()
public function boolean of_cambios_amp ()
public function boolean of_proc_precio_amp (string as_origen, long al_nro_mov, decimal adc_precio_unit, decimal adc_descuento, string as_moneda)
public subroutine of_set_modify ()
public function integer of_comprador ()
public function integer of_verifica_precio ()
public function boolean of_validar_oc (string as_nro_oc)
public function integer of_verifica_fondo_oc ()
public function integer of_verifica_aoc ()
public function integer of_precio_unit (long al_row)
public function integer of_precio_con_igv (long al_row)
public function integer of_fondo_oc (string as_origen)
public function integer of_nro_cnta_banco (string as_banco)
public function integer of_banco_prov ()
end prototypes

event ue_anular;Integer 	li_j
decimal 	ln_cant_procesada
string	ls_null
Long		ll_null

SetNull(ls_null)
SetNull(ll_null)

if of_comprador() = 0 then return

if MessageBox('Aviso', 'Deseas anular la Orden de Compra', Information!, YesNo!, 2) = 2 then return

// Verifica que exista el detalle
IF dw_master.rowcount() = 0 then return
if dw_detail.rowcount() = 0 then return

if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then
	MessageBox('Aviso', 'No puede anular esta Orden de Compra')
	RETURN
end if

ln_cant_procesada = 0
for li_j=1 to dw_detail.RowCount()
	ln_cant_procesada += Long(dw_detail.object.cant_procesada[li_j])
next

if ln_Cant_procesada > 0 then
	MessageBox('Aviso', 'No puede anular esta Orden de Compra porque ya tiene Ingresos al almacen')
	RETURN
end if

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

is_action = 'anu'
// Anulando Cabecera
dw_master.object.flag_estado[dw_master.getrow()] = '0'

for li_j=1 to dw_detail.RowCount()
	dw_detail.object.flag_estado  [li_j] = '0'
	dw_detail.object.cant_proyect [li_j] = 0
	dw_detail.object.oper_sec 		[li_j] = ls_null
	dw_detail.object.org_amp_ref	[li_j] = ls_null
	dw_detail.object.nro_amp_ref	[li_j] = ll_null
next

dw_master.ii_update = 1
dw_detail.ii_update = 1

of_set_status_doc(dw_master)
end event

event ue_cancelar;// Cancela operacion, limpia todo
EVENT ue_update_request()   // Verifica actualizaciones pendientes

dw_master.reset()
dw_master.ii_update = 0

dw_detail.reset()
dw_detail.ii_update = 0

sle_ori.text = ''
sle_nro.text = ''
sle_ori.SetFocus()
idw_1 = dw_master
dw_master.il_row = 0

is_Action = ''
of_set_status_doc(dw_master)
end event

event ue_mail();str_parametros lstr_rep

IF dw_master.getrow() > 0 THEN
	lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
	lstr_rep.string2 = dw_master.object.nro_oc[dw_master.getrow()]
	lstr_rep.string3 = dw_master.object.proveedor[dw_master.getrow()]

	openWithParm (w_sel_orden_compra_email, lstr_rep)
END IF

end event

event ue_cerrar();string 	ls_estado
long		ll_row, ll_i

if of_comprador() = 0 then return

// opcion que me permite cerrar una Oc, cuando quiero
// que ya no sea atendida
if is_action = 'new' then
	MessageBox('Aviso', 'Para Cerrar la Orden debe grabarla primeramente')
	return
end if

if MessageBox('Aviso', 'Deseas Cerrar la Orden de Compra', Information!, YesNo!, 2) = 2 then return

ll_Row = dw_master.GetRow()
if ll_row = 0 then 
	MessageBox('Aviso', 'No ha deifinido cabecera de Orden de Compra')
	return
end if

ls_estado = dw_master.object.flag_estado [ll_row]
if ls_estado = '0' then
	MessageBox('Aviso', 'Orden de Compra esta anulada no se puede cerrar')
	return
end if

dw_master.object.flag_estado [ll_row] = '2'
dw_master.ii_update = 1
	
for ll_i = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado [ll_i] = '2'
	dw_detail.ii_update = 1
next
	

end event

public subroutine of_email ();Messagebox( "of_email", '')
n_cst_email	lnv_1
String	ls_ini_file, ls_file, ls_name, ls_address, ls_subject, ls_note, ls_path
Datastore	lds_data

lnv_1 = CREATE n_cst_email

ls_ini_file = "\Pb_exe\Proc_Test.ini"
               
ls_name		= ProfileString (ls_ini_file, "Mail", "name", "")
ls_address	= ProfileString (ls_ini_file, "Mail", "address", "")
ls_subject	= ProfileString (ls_ini_file, "Mail", "subject", "")
ls_note		= ProfileString (ls_ini_file, "Mail", "message", "")

lds_data = Create DataStore
lds_data.DataObject = 'd_articulo_tbl'
lds_data.SetTransObject(SQLCA)
lds_data.Retrieve()

lnv_1.of_logon()

lnv_1.of_send_mail(ls_name, ls_address, ls_subject, ls_note)
end subroutine

public subroutine of_retrieve (string as_origen, string as_nro);String 	ls_origen, ls_nro, ls_imp
Long 		ll_row

ll_row = dw_master.retrieve(as_origen, as_nro)
is_action = 'open'

if ll_row > 0 then	

	ls_origen = dw_master.object.cod_origen		[dw_master.getrow()]
	ls_nro 	 = dw_master.object.nro_oc				[dw_master.getrow()]
	ls_imp	 = dw_master.object.flag_importacion[dw_master.getrow()]
	
	dw_detail.retrieve(is_doc_oc, ls_nro, ls_imp)
	of_set_total_oc()	
	
	of_set_status_doc( dw_master )
	of_fondo_oc(as_origen)
else
	dw_detail.Reset()
end if

dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

dw_detail.ii_update = 0
dw_detail.ii_protect = 0
dw_detail.of_protect()

//of_set_modify()
return 

end subroutine

public function integer of_set_status_doc (datawindow idw);/*
  Funcion que verifica el status del documento
*/
this.changemenu(m_mtto_lista )

Int li_estado

// Activa todas las opciones
m_master.m_file.m_basedatos.m_insertar.enabled  = f_niveles( is_niveles, 'I')  // true
m_master.m_file.m_basedatos.m_eliminar.enabled  = f_niveles( is_niveles, 'E')  //true
m_master.m_file.m_basedatos.m_modificar.enabled = f_niveles( is_niveles, 'M') //true
m_master.m_file.m_basedatos.m_anular.enabled 	= f_niveles( is_niveles, 'A') //true
m_master.m_file.m_basedatos.m_grabar.enabled 		= true
m_master.m_file.m_basedatos.m_abrirlista.enabled 	= true
m_master.m_file.m_basedatos.m_cancelar.enabled 		= true
m_master.m_file.m_printer.m_print1.enabled 			= true

if dw_master.getrow() = 0 then return 0

if is_Action = 'new' then
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_printer.m_print1.enabled 			= false	
	m_master.m_file.m_basedatos.m_insertar.enabled = false
	m_master.m_file.m_basedatos.m_email.enabled 	= false
//	m_master.m_file.m_basedatos.m_cerrar.enabled 		= false

	if idw = dw_detail then
		m_master.m_file.m_basedatos.m_eliminar.enabled = f_niveles(is_niveles, 'E')
		if rb_catalogo.checked = true then
	   	m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles(is_niveles, 'I')
		else	
			m_master.m_file.m_basedatos.m_insertar.enabled = false
		end if
	END IF
	
elseif is_Action = 'open' then
	
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])
	if idw = dw_detail then		
		if rb_catalogo.checked = true and li_estado = 1 then
   		m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles(is_niveles, 'I')
		else	
			m_master.m_file.m_basedatos.m_insertar.enabled = false
		end if
	END IF
	
	Choose case li_estado
		case 0		// Anulado			
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
			m_master.m_file.m_basedatos.m_modificar.enabled 	= false
			m_master.m_file.m_basedatos.m_anular.enabled 		= false
			m_master.m_file.m_basedatos.m_email.enabled 	= false
//			m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
		CASE 1   // Activo
			if is_flag_aut_oc = '1' then
				m_master.m_file.m_basedatos.m_eliminar.enabled = false
				if idw_1 = dw_detail then
					m_master.m_file.m_basedatos.m_modificar.enabled 	= f_niveles( is_niveles, 'M') //true
				else
					m_master.m_file.m_basedatos.m_modificar.enabled 	= false
				end if
			end if
		CASE 2   // Cerrado
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
			if idw_1 = dw_master then
				m_master.m_file.m_basedatos.m_modificar.enabled 	= false
			else
				m_master.m_file.m_basedatos.m_modificar.enabled 	= f_niveles( is_niveles, 'M')  // true
			end if
			m_master.m_file.m_basedatos.m_anular.enabled 		= false
//			m_master.m_file.m_basedatos.m_cerrar.enabled 		= false			
			
		CASE 3   // Pendiente VoBo
			if is_flag_aut_oc = '1' then
//				m_master.m_file.m_basedatos.m_anular.enabled 		= false
//				m_master.m_file.m_basedatos.m_cerrar.enabled 		= false			
			end if

	end CHOOSE
	
elseif is_Action = 'edit' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= true
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_printer.m_print1.enabled 			= false	
	m_master.m_file.m_basedatos.m_insertar.enabled = false
	m_master.m_file.m_basedatos.m_email.enabled 	= false	
//	m_master.m_file.m_basedatos.m_cerrar.enabled 		= false			
	
elseif is_Action = 'anu' OR is_Action = 'del' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_printer.m_print1.enabled 			= false	
	m_master.m_file.m_basedatos.m_insertar.enabled = false
	m_master.m_file.m_basedatos.m_email.enabled 	= false	
//	m_master.m_file.m_basedatos.m_cerrar.enabled 		= false			
end if

return 1
end function

public function integer of_set_numera ();// Numera documento
Long 		ll_long, ll_count
string	ls_mensaje

if is_action = 'new' then
	Long ll_nro, j
	String ls_nro, ls_table
	
	Select count(*)
		into :ll_count
	from num_ord_comp 
	where origen = :gnvo_app.is_origen;
	
	IF ll_count = 0 then
		Insert into NUM_ORD_COMP (origen, ult_nro)
			values( :gnvo_app.is_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = 'Error al insertar en NUM_ORD_COMP: ' &
						  + SQLCA.SQLErrText
			ROLLBACK;
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje )
			return 0
		end if
	end if

	Select ult_nro 
		into :ll_nro 
	from num_ord_comp 
	where origen = :gnvo_app.is_origen for update;

	// Asigna numero a cabecera
	if ll_nro = 0 then ll_nro++
	ls_nro = String(ll_nro)	
	ll_long = 10 - len( TRIM( gnvo_app.is_origen))
   ls_nro = TRIM( gnvo_app.is_origen) + f_llena_caracteres('0',Trim(ls_nro),ll_long) 		
	
	dw_master.object.nro_oc[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update num_ord_comp 
		set ult_nro = :ll_nro + 1 
	 where origen = :gnvo_app.is_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = 'Error al actualizar NUM_ORC_COMP: ' &
					  + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_log.of_errorlog(ls_mensaje)
		gnvo_app.of_showmessagedialog( ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_oc[dw_master.getrow()] 
end if

// Asigna numero a detalle
dw_master.object.nro_oc[dw_master.getrow()] = ls_nro
for j = 1 to dw_detail.RowCount()	
	dw_detail.object.nro_doc[j] = ls_nro	
next
return 1
end function

public function integer of_verifica_datos ();// Verifica datos si han sido ingresados
Long ll_row

if dw_master.getrow() = 0 then return 0

ll_row = dw_master.getrow()

if ISNULL(dw_master.object.proveedor[ll_row] ) OR TRIM( dw_master.object.proveedor[ll_row]) = '' THEN
	Messagebox( "Error", "Ingrese proveedor")
	dw_master.setcolumn( "proveedor")
	dw_master.Setfocus()
	Return 0
END IF
if ISNULL(dw_master.object.forma_pago[ll_row] ) OR TRIM( dw_master.object.forma_pago[ll_row]) = '' THEN
	Messagebox( "Error", "Ingrese la Forma pago")
	dw_master.setcolumn( "forma_pago")
	dw_master.Setfocus()
	Return 0
END IF
if ISNULL(dw_master.object.cod_moneda[ll_row] ) OR TRIM( dw_master.object.cod_moneda[ll_row]) = '' THEN
	Messagebox( "Error", "Ingrese moneda")
	dw_master.setcolumn( "cod_moneda")
	dw_master.Setfocus()
	Return 0
END IF

return 1
end function

public function integer of_verifica_datos_det ();Long j

if is_action <> 'anu' then
	For j = 1 to dw_detail.RowCount()
		if dw_detail.object.cant_proyect[j] = 0 then
			Messagebox( "Atencion", "Debera de ingresar cantidad")
			dw_detail.setcolumn( "cant_proyect") 
			return 0
		end if
		if dw_detail.object.precio_unit[j] = 0 then
			Messagebox( "Atencion", "Debera de ingresar precio")
			dw_detail.setcolumn( "precio_unit")
			return 0
		end if
		if TRIM( string( dw_detail.object.fec_registro[j], 'dd/mm/yyyy')) = '' THEN
			Messagebox( "Atencion", "Debera de ingresar fecha de entrega")
			dw_detail.setcolumn( "fec_registro")
			return 0	   
		END IF
		
	Next
end if

return 1
end function

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

// busca tipos de movimiento definidos
SELECT 	tipo_doc_prog_cmp, doc_oc, cod_soles,
			oper_ing_oc, cod_igv, doc_sc, oper_cons_interno, doc_ot,
			NVL(FLAG_RESTRIC_COMP_OC, '0'), NVL(flag_aut_oc, '0'),
			NVL(flag_cntrl_fondos, '0'), NVL(flag_mod_fec_oc, '0')
	INTO 	:is_doc_prog, :is_doc_oc, :is_soles,
			:is_oper_ing_oc, :is_cod_igv, :is_doc_sc, :is_oper_cons_int, :is_doc_ot,
			:is_FLAG_RESTRIC_COMP_OC, :is_flag_aut_oc,
			:is_flag_cntrl_fondos, :is_flag_mod_fec_oc
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
if ISNULL( is_doc_prog ) or TRIM( is_doc_prog ) = '' then
	Messagebox("Error", "Defina documento prog. compras en logparam")
	return 0
end if

if ISNULL( is_doc_oc ) or TRIM( is_doc_oc ) = '' then
	Messagebox("Error", "Defina Documento de Orden de Compra en logparam")
	return 0
end if

if ISNULL( is_soles ) or TRIM( is_soles ) = '' then
	Messagebox("Error", "Defina Codigo de Moneda Soles en logparam")
	return 0
end if

if ISNULL( is_cod_igv ) or TRIM( is_cod_igv ) = '' then
	Messagebox("Error", "Defina Codigo de IGV en logparam")
	return 0
end if

if ISNULL( is_oper_ing_oc ) or TRIM( is_oper_ing_oc ) = '' then
	Messagebox("Error", "Defina Operacion Ingreso x Compras (oper_ing_oc) en logparam")
	return 0
end if

if ISNULL( is_oper_cons_int ) or TRIM( is_oper_cons_int ) = '' then
	Messagebox("Error", "Defina Operacion Consumo Interno (oper_cons_interno) en logparam")
	return 0
end if

if ISNULL( is_doc_sc ) or TRIM( is_doc_sc ) = '' then
	Messagebox("Error", "Defina Documento Solicitud de Compras (is_doc_sc) en logparam")
	return 0
end if

if ISNULL( is_doc_ot ) or TRIM( is_doc_ot ) = '' then
	Messagebox("Error", "Defina Documento Orden de Trabajo (is_doc_ot) en logparam")
	return 0
end if

// Parametros de finanzas
SELECT 	doc_anticipo_oc
	INTO 	:is_doc_aoc
FROM finparam 
where reckey = '1';

if sqlca.sqlcode = 100 then
	Messagebox( "Error", "no ha definido parametros en FINPARAM")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", ls_mensaje)
	return 0
end if

// busca doc. prog. compras
if ISNULL( is_doc_aoc ) or TRIM( is_doc_aoc ) = '' then
	Messagebox("Error", "Defina documento Anticipo de Compras en FinParam")
	return 0
end if

if of_fondo_oc(gnvo_app.is_origen) = 0 then 
	return 0
end if
return 1
end function

public subroutine of_set_total_oc ();// Halla sub total
Decimal 	ldc_sub_total, ldc_imp_igv, ldc_importe, ldc_tot_dct, ldc_tot_igv, &
			ldc_total_oc, ldc_descuento, ldc_impuesto
Int 		li_j

if dw_master.GetRow() = 0 then return

ldc_sub_total = 0
ldc_imp_igv = 0
ldc_tot_dct = 0
ldc_tot_igv = 0
dw_detail.AcceptText()

For li_j = 1 to dw_detail.Rowcount()
	
	ldc_importe = ROUND(dw_detail.object.cant_proyect[li_j] * (dw_detail.object.Precio_unit[li_j]) ,2)
		
	ldc_sub_total += ldc_importe	
	
	if dw_detail.object.decuento[li_j] > 0 then
		ldc_descuento = ROUND(dw_detail.object.cant_proyect[li_j] * dw_detail.object.decuento[li_j],2)
		ldc_tot_dct += ldc_descuento
	else
		dw_detail.object.decuento[li_j] = 0
		ldc_descuento = 0
	end if
	
	if dw_detail.object.impuesto[li_j] > 0 then
		ldc_impuesto 	= ROUND(dw_detail.object.impuesto[li_j],2)
		ldc_tot_igv 	+= ldc_impuesto 
	else
		dw_detail.object.impuesto[li_j] = 0
		ldc_impuesto = 0
	end if	
	
Next
em_vb.text 		= String(ldc_sub_total)
em_dcto.text 	= String(ldc_tot_dct)
em_imp.text 	= String(ldc_tot_igv)
em_vn.text 		= String(ldc_sub_total - ldc_tot_dct + ldc_tot_igv) 

//ldc_total_oc = Dec(dw_master.object.monto_total[dw_master.getrow()])
//If IsNull(ldc_total_oc) then ldc_total_oc = 0

//if ldc_total_oc <> (ldc_sub_total - ldc_tot_dct + ldc_tot_igv) then
	dw_master.object.monto_total[dw_master.getrow()] = (ldc_sub_total - ldc_tot_dct + ldc_tot_igv)
	dw_master.ii_update = 1
//end if
end subroutine

public function integer of_crea_mov_proy ();/*
   Funcion: of_crea_mov_proy
	Objetivo: insertar cada registro de la orden de compra en
	    articulo_mov_proy, como salida. Solo para los casos
		 cuando la orden de compra tenga referencia a s/compra.
	Parametros: ninguno
	Retorna: 1 = Ok
				0 = fallo
*/

Integer j
string 	ls_cnta_prsp, ls_cencos, ls_cod_art, ls_nro_sc, &
			ls_ori_sc, ls_nro_oc, ls_mensaje, ls_almacen, ls_ori_oc, &
			ls_tipo_ref
Decimal{4} ln_cantid, ln_null
Datetime ln_fec_registro, ln_fec_proyect
Long ln_nro_mov

Setnull(ln_null)

dw_master.AcceptText()

ls_ori_oc = dw_master.object.cod_origen[dw_master.getrow()]
ls_nro_oc = dw_master.object.nro_oc[dw_master.getrow()]

IF is_Action = 'new' then	
   For j = 1 to dw_detail.RowCount()
		ls_nro_sc  = dw_detail.object.referencia			[j]
		ls_tipo_ref= dw_detail.object.tipo_ref				[j]
		ls_ori_sc  = dw_detail.object.origen_ref			[j]		
	   ls_cod_art = dw_detail.object.cod_art				[j]
		ls_almacen = dw_detail.object.almacen				[j]
		ln_cantid  = dw_detail.object.cant_proyect		[j]
		ln_Fec_registro = dw_detail.object.fec_registro	[j]
		ln_Fec_proyect  = dw_detail.object.fec_proyect 	[j]
		
		if isnull(ls_nro_sc) then continue
		if ls_tipo_ref <> is_doc_sc then continue
	
		// Busca cencos en cabecera de solicitud
		Select cencos 
			into :ls_cencos 
		from sol_compra 
		where cod_origen   = :ls_ori_sc
		  and nro_sol_comp = :ls_nro_sc;
			
	   // Busca cuenta prsp del detalle de la sol. compra
		Select partida_presup 
			into :ls_cnta_prsp 
		from sol_comp_det 
	   where cod_origen 		= :ls_ori_sc 
		  and nro_sol_comp 	= :ls_nro_sc
		  and cod_art 			= :ls_cod_art;	   
		
	   
	   insert into articulo_mov_proy(
				cod_origen,		flag_estado, 	cod_art, 			tipo_mov, 
	      	tipo_doc, 		nro_doc, 		fec_registro, 		fec_proyect, 
				cant_proyect, 	cencos, 			cnta_prsp, 			origen_ref, 
				tipo_ref, 		referencia, 	almacen,				flag_replicacion,
				cod_usr)
    	Values(
		 		:ls_ori_oc, 	'1', 				:ls_cod_art, 		:is_oper_cons_int, 
				:is_doc_sc, 	:ls_nro_sc, 	:ln_fec_registro,	:ln_fec_proyect, 
				:ln_Cantid, 	:ls_cencos, 	:ls_cnta_prsp, 	:ls_ori_oc, 	
				:is_doc_oc, 	:ls_nro_oc,		:ls_almacen,		'1',
				:gnvo_app.is_user);
			
		if sqlca.sqlcode <> 0 then 
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			messagebox( "Error INSERT of_crea_mov_proy", ls_mensaje)
			return 0		
		end if
	Next
	
elseif is_Action = 'anu' then
	
	For j = 1 to dw_detail.RowCount()
		ls_ori_sc  	= dw_detail.object.origen_ref		[j]
		ls_tipo_ref = dw_detail.object.tipo_ref		[j]
		ls_nro_sc  	= dw_detail.object.referencia		[j]
		ls_cod_art 	= dw_detail.object.cod_Art			[j]
		ln_cantid 	= dw_detail.object.cant_proyect	[j]	
		
		if isnull(ls_nro_sc) then continue
		if ls_tipo_ref <> is_doc_sc then continue
		
		// Dado la referencia en la o/compra, busca nro mov. asignado
		Select nro_mov 
			into :ln_nro_mov 
		from articulo_mov_proy
		where cod_origen 	 = :ls_ori_oc
		  and tipo_doc 	 = :is_doc_sc 
		  AND nro_doc 		 = :ls_nro_sc 
		  and cod_art 		 = :ls_cod_art
		  and referencia	 = :ls_nro_oc;
		
		// Quita el enlace s/compra con orden de compra
		Update sol_comp_det 
			set nro_mov = :ln_null,
				 flag_replicacion = '1'
		 where nro_mov = :ln_nro_mov;
		
		if sqlca.sqlcode <> 0 then 
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			messagebox( "Error ANULAR of_crea_mov_proy", ls_mensaje)
			return 0		
		end if
		
	   Delete from articulo_mov_proy 
		where cod_origen 	 = :ls_ori_oc
		  and tipo_doc 	 = :is_doc_sc 
		  and nro_doc 		 = :ls_nro_sc 
		  and cod_art 		 = :ls_cod_art 
		  and referencia	 = :ls_nro_oc;
		  
		if sqlca.sqlcode <> 0 then 
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			messagebox( "Error ANULAR of_crea_mov_proy" , ls_mensaje)
			return 0	
		end if
		
		dw_detail.object.flag_estado[j] = '0'
		dw_detail.object.cant_proyect[j] = 0
	Next
	
elseif is_Action = 'edit' then	
	
	// Modificar
	For j = 1 to dw_detail.RowCount()
		ls_nro_sc  = dw_detail.object.referencia	[j]
		ls_tipo_ref= dw_detail.object.tipo_ref		[j]
		ls_ori_sc  = dw_detail.object.origen_ref	[j]		
	   ls_cod_art = dw_detail.object.cod_art		[j]
		ln_cantid  = dw_detail.object.cant_proyect[j]
		ls_almacen = dw_detail.object.almacen		[j]


		if isnull(ls_nro_sc) then continue
		if ls_tipo_ref <> is_doc_sc then continue
		
		Update articulo_mov_proy 
			set cant_proyect = :ln_cantid,
				 almacen		  = :ls_almacen,
				 flag_replicacion = '1'
		where cod_origen 	= :ls_ori_oc
		  and tipo_doc 	= :is_doc_sc 
		  and nro_doc 		= :ls_nro_sc 
		  and cod_art 		= :ls_cod_art;	
		  
	   if sqlca.sqlcode <> 0 then 
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			messagebox( "Error EDIT of_crea_mov_proy", ls_mensaje )
			return 0		
		end if
	Next	
	
elseif is_action = 'del' then
	
	For j = 1 to dw_detail.deletedCount()
		ls_nro_sc  = dw_detail.object.referencia.delete	[j]
	   ls_cod_art = dw_detail.object.cod_art.delete		[j]
		ls_tipo_ref= dw_detail.object.tipo_ref.delete	[j]
	
		if isnull(ls_nro_sc) then continue
		if ls_tipo_ref <> is_doc_sc then continue
		
		// Elimina registros
		Delete from articulo_mov_proy 
		where cod_origen 	= :ls_ori_oc
		  and tipo_doc 	= :is_doc_sc 
		  and nro_doc 		= :ls_nro_sc 
		  and cod_art 		= :ls_cod_art;	   
		  
	   if sqlca.sqlcode <> 0 then 
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			messagebox( "Error DELETE of_crea_mov_proy", ls_mensaje)
			return 0		
		end if
	Next
end if

return 1
end function

public function boolean of_set_articulo (string as_cod_art);string 	ls_almacen, ls_cod_clase, ls_proveedor, ls_moneda
date		ld_fec_reg
decimal	ldc_precio, ldc_saldo, ldc_porc_dscto, &
			ldc_descuento, ldc_porc_igv, ldc_igv, ldc_cant_proyect
Long		ll_row			

// Setea las variables x defecto de acuerdo al codigo de articulo
// x ejemplo el almacen tácito y el precio en articulo_precio_pactado

if dw_master.GetRow() = 0 then return false

ls_proveedor = dw_master.object.proveedor	[dw_master.GetRow()]
ls_moneda	 = dw_master.object.cod_moneda[dw_master.GetRow()]

if trim(ls_proveedor) = '' or IsNull(ls_proveedor) then
	MessageBox('Aviso', 'Debe indicar el proveedor en la cabecera de la Orden de Compra')
	return false
end if

if trim(ls_moneda) = '' or IsNull(ls_moneda) then
	MessageBox('Aviso', 'Debe indicar el proveedor en la cabecera de la Orden de Compra')
	return false
end if

ld_fec_reg = Date(dw_master.object.fec_registro[dw_master.GetRow()])

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

//Obtengo el saldo del articulo en ese almacen
select NVL(sldo_total, 0)
  into :ldc_saldo
from articulo_almacen
where cod_art = :as_cod_art
  and almacen = :ls_almacen;

If SQLCA.SQlCode = 100 then ldc_saldo = 0

dw_detail.object.saldo_almacen [dw_detail.GetRow()] = ldc_saldo

// Obtengo el precio pactado
//create or replace function usf_cmp_prec_compra_artic(
// 	asi_cod_art         in articulo.cod_art%TYPE,
// 	asi_proveedor       in proveedor.proveedor%type,
// 	adi_fec_reg         in orden_compra.fec_registro%type,
// 	asi_almacen         in almacen.almacen%TYPE,
//		asi_moneda          in moneda.cod_moneda%type
//) return number is

SELECT usf_cmp_prec_compra_artic(:as_cod_art, :ls_proveedor, :ld_fec_reg, :ls_almacen, :ls_moneda)
	INTO :ldc_precio
FROM dual ;

if IsNull(ldc_precio) then ldc_precio = 0

ll_row = dw_detail.GetRow()

dw_detail.object.precio_unit [ll_row] = ldc_precio

ldc_cant_proyect = Dec(dw_detail.object.cant_proyect[ll_row])

ldc_porc_dscto = Dec(dw_detail.object.porc_dscto[ll_row])
If IsNull(ldc_porc_dscto) then
	ldc_porc_dscto = 0
	dw_detail.object.porc_dscto [ll_row] = 0
end if

ldc_porc_igv 	= Dec(dw_detail.object.porc_impuesto  [ll_row])
If IsNull(ldc_porc_igv) then
	ldc_porc_igv = 0
	dw_detail.object.porc_impuesto [ll_row] = 0
end if

ldc_descuento 	= ldc_precio * ldc_porc_dscto / 100
if ldc_descuento > ldc_precio then
	MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
	dw_detail.object.porc_dscto	[ll_row] = 0
	dw_detail.object.decuento			[ll_row] = 0
	return false
end if

ldc_igv = (ldc_precio - ldc_descuento) * ldc_cant_proyect * ldc_porc_igv / 100

dw_detail.object.decuento		[ll_row] = ldc_descuento
dw_detail.object.impuesto		[ll_row] = ldc_igv

this.of_set_total_oc( )

return true
end function

public function integer of_oc_importacion ();string 	ls_flag_importacion, ls_origen, ls_nro_oc, ls_mensaje
Long		ll_row, ll_count

if dw_master.GetRow() = 0 then return 0

ll_row = dw_master.GetRow()
ls_flag_importacion = dw_master.object.flag_importacion[ll_row]
ls_origen = dw_master.object.cod_origen [ll_row]
ls_nro_oc = dw_master.object.nro_oc		 [ll_row]

if ls_flag_importacion = '0' then
	if IsNull(ls_nro_oc) or trim(ls_nro_oc) = '' then
		MessageBox('Aviso', 'Numero de la Orden de Compra no esta definido')
		return 0
	end if
	
	select count(*)
		into :ll_count
	from oc_importacion
	where nro_oc 		= :ls_nro_oc
	  and cod_origen 	= :ls_origen;
	 
	
	if ll_count = 0 then return 1
	
	if MessageBox('Information', 'La Orden de Compra tiene datos de importacion, ' &
		+ 'Desea Continuar con la eliminación de los datos?', Information!, YesNo!, 2) = 2 then
		return 0
	end if
	
	delete oc_importacion
	where nro_oc 		= :ls_nro_oc
	  and cod_origen 	= :ls_origen;
	
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ' + this.ClassName(), ls_mensaje)
		return 0
	end if
end if
return 1
end function

public function boolean of_cambios_amp ();Long 		ll_i, ll_nro_mov
Decimal	ldc_precio_old, ldc_precio_new, ldc_descuento_old, &
			ldc_descuento_new
			
string	ls_origen, ls_moneda_old, ls_moneda_new

if is_action = 'new' then return true

for ll_i = 1 to dw_detail.RowCount()
	ldc_precio_old 	= dw_detail.GetItemDecimal( ll_i, 'precio_unit', Primary!, TRUE)
	ldc_precio_new 	= dw_detail.GetItemDecimal( ll_i, 'precio_unit', Primary!, FALSE)
	
	ldc_descuento_old = dw_detail.GetItemDecimal( ll_i, 'decuento', Primary!, TRUE)
	ldc_descuento_new = dw_detail.GetItemDecimal( ll_i, 'decuento', Primary!, FALSE)

	ls_moneda_old 		= dw_detail.GetItemString( ll_i, 'cod_moneda', Primary!, TRUE)
	ls_moneda_new 		= dw_detail.GetItemString( ll_i, 'cod_moneda', Primary!, FALSE)
	
	if ldc_precio_old 	<> ldc_precio_new 	or &
		ldc_descuento_old <> ldc_descuento_new or &
		ls_moneda_old		<> ls_moneda_new		then
		
		ls_origen 	= dw_detail.object.cod_origen	[ll_i]
		ll_nro_mov 	= dw_detail.object.nro_mov		[ll_i]
		
		if of_proc_precio_amp( ls_origen, ll_nro_mov, ldc_precio_new, ldc_descuento_new, ls_moneda_new) = false then
			ROLLBACK;
			return false
		end if
		
	end if
	
next

return true
end function

public function boolean of_proc_precio_amp (string as_origen, long al_nro_mov, decimal adc_precio_unit, decimal adc_descuento, string as_moneda);string ls_mensaje
//create or replace procedure USP_ALM_PREC_X_MOVPROY(
//       asi_origen        in articulo_mov_proy.cod_origen%TYPE,
//       ani_nro_mov       in articulo_mov_proy.nro_mov%TYPE,
//       ani_precio_unit   in articulo_mov_proy.precio_unit%TYPE,
//       ani_decuento      in articulo_mov_proy.decuento%TYPE,
//       asi_moneda        in articulo_mov.cod_moneda%TYPE
//) is


DECLARE USP_ALM_PREC_X_MOVPROY PROCEDURE FOR
	USP_ALM_PREC_X_MOVPROY( :as_origen,
									:al_nro_mov,
									:adc_precio_unit,
									:adc_descuento,
									:as_moneda);

EXECUTE USP_ALM_PREC_X_MOVPROY;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_ALM_PREC_X_MOVPROY:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE USP_ALM_PREC_X_MOVPROY;

return true
end function

public subroutine of_set_modify ();string ls_nro_programa

//Cantidad Proyectada
dw_detail.Modify("cant_proyect.Protect ='1~tIf(IsNull(flag_cantidad),1,0)'")
dw_detail.Modify("cant_proyect.Background.color ='1~tIf(IsNull(flag_cantidad), RGB(192,192,192),RGB(255,255,255))'")

//Codigo de Articulo
dw_detail.Modify("cod_art.Protect ='1~tIf(IsNull(flag_cantidad) or not IsNull(nro_amp_ref),1,0)'")
dw_detail.Modify("cod_art.Background.color ='1~tIf(IsNull(flag_cantidad), RGB(192,192,192),RGB(255,255,255))'")

//Almacén
dw_detail.Modify("almacen.Protect ='1~tIf(IsNull(flag_almacen),1,0)'")
dw_detail.Modify("almacen.Background.color ='1~tIf(IsNull(flag_almacen), RGB(192,192,192),RGB(255,255,255))'")

//Precio Unitario
dw_detail.Modify("precio_unit.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("precio_unit.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

//Precio Con IGV
dw_detail.Modify("precio_con_igv.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("precio_con_igv.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

//% Descuento
dw_detail.Modify("porc_dscto.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("porc_dscto.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

//Descuento
dw_detail.Modify("decuento.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("decuento.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

//% IGV
dw_detail.Modify("porc_impuesto.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("porc_impuesto.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

//Impuesto
dw_detail.Modify("impuesto.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("impuesto.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

if dw_master.GetRow() = 0 then return

ls_nro_programa = dw_master.object.nro_programa[dw_master.GetRow()]

if IsNull(ls_nro_programa) then ls_nro_programa = ''

if ls_nro_programa <> '' then
	dw_detail.object.cod_art.protect = 1
end if

if is_flag_oc_prsp = '0' then
	dw_detail.object.cencos.protect = 1
	dw_detail.object.cencos.edit.required = 'No'
	dw_detail.object.cnta_prsp.protect = 1
	dw_detail.object.cnta_prsp.edit.required = 'No'
end if

//Si esta activo el flag de autorizacion solo debe permitir cambiar el IGV nada mas
if is_flag_aut_oc = '1' and dw_master.object.flag_estado[dw_master.GetRow()] = '1' then
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.object.cod_art.protect = 1
	dw_detail.object.cant_proyect.protect = 1
	dw_detail.object.precio_unit.protect = 1
	dw_detail.object.decuento.protect = 1
	dw_detail.object.porc_dscto.protect = 1
	dw_detail.object.almacen.protect = 1
end if
end subroutine

public function integer of_comprador ();Long ll_count

Select count(*)
	into :ll_count
from comprador
where comprador = :gnvo_app.is_user
  and flag_estado = '1';

if ll_count = 0 then
	Messagebox("Error", "Usuario " + gnvo_app.is_user + " no esta definidido como comprador " &
			+	"o ya no se encuentra activo")
	return 0
end if

return 1

end function

public function integer of_verifica_precio ();// Esta funcion verifica que el precio de la Orden de Compra no sea cero si el
// flag de estado de la OC no es cero, es decir no esta anulado
string 		ls_flag_estado
Long 			ll_i

if dw_master.GetRow() = 0 then return 0

ls_flag_estado = dw_master.object.flag_estado[ dw_master.GetRow() ]

if ls_flag_Estado <> '0' then
	for ll_i = 1 to dw_detail.RowCount()
		if Dec( dw_detail.object.precio_unit[ll_i] ) = 0 then
			MessageBox('Aviso', 'NO puede ingresar un item con precio 0, por favor verifique')
			dw_detail.SelectRow( 0, false)
			dw_detail.SelectRow( ll_i, true)
			dw_detail.SetColumn('precio_unit')
			return 0
		end if
		
		if Dec( dw_detail.object.cant_proyect[ll_i] ) = 0 then
			MessageBox('Aviso', 'NO puede ingresar un item con cantidad 0, por favor verifique')
			dw_detail.SelectRow( 0, false)
			dw_detail.SelectRow( ll_i, true)
			dw_detail.SetColumn('cant_proyect')
			return 0
		end if

	next
end if

return 1
end function

public function boolean of_validar_oc (string as_nro_oc);string ls_mensaje
//create or replace procedure USP_CMP_VALIDA_COMPRA(
//       asi_nro_oc     in orden_compra.nro_oc%TYPE
//) is


DECLARE USP_CMP_VALIDA_COMPRA PROCEDURE FOR
	USP_CMP_VALIDA_COMPRA( :as_nro_oc);

EXECUTE USP_CMP_VALIDA_COMPRA;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_CMP_VALIDA_COMPRA:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE USP_CMP_VALIDA_COMPRA;

return true
end function

public function integer of_verifica_fondo_oc ();long		ll_j, ll_year, ll_count
string 	ls_cencos, ls_cnta_prsp
Date		ld_fecha

if is_flag_cntrl_fondos = '0' then return 1

if is_action <> 'anu' then
	For ll_j = 1 to dw_detail.RowCount()
		ls_cencos 		= dw_detail.object.cencos 		[ll_j]
		ls_cnta_prsp 	= dw_detail.object.cnta_prsp	[ll_j]
		ld_fecha			= Date(dw_detail.object.fec_proyect[ll_j])
		ll_year			= Year(ld_fecha)
		
		//Verifico si el fondo de compras esta en la tabla de fondos de compra
		select count(*)
			into :ll_count
		from compra_fondo
		where ano 			= :ll_year
		  and cencos 		= :ls_cencos
		  and cnta_prsp 	= :ls_cnta_prsp;
		
		if ll_count = 0 then 
			MessageBox('Error', 'La partida presupuestal que ha ingresado no es para Fondo de Compras' &
					+ '~r~n Año: ' + string(ll_year) &
					+ '~r~n Cencos: ' + ls_cencos &
					+ '~r~n Cnta Prsp: ' + ls_cnta_prsp &
					+ '~r~n Por favor verifique')
					
			dw_detail.SetColumn('cencos')
			dw_detail.SetRow(ll_j)
			dw_detail.ScrollToRow(ll_j)
			return 0
		end if
		
	Next
end if

return 1
end function

public function integer of_verifica_aoc ();long		ll_j, ll_count, ll_row_mas
string 	ls_nro_oc, ls_moneda
decimal 	ldc_monto_aoc, ldc_monto_oc

if dw_master.GetRow() = 0 then 
	MessageBox('Error', 'No existe Cabecera de Documento, Verifique')
	return 0
end if

ll_row_mas = dw_master.GetRow()

ls_nro_oc = dw_master.object.nro_oc 		[ll_row_mas]
ls_moneda = dw_master.object.cod_moneda 	[ll_row_mas]

if IsNull(ls_nro_oc) or ls_nro_oc = '' then return 1

if IsNull(ls_moneda) or ls_moneda = '' then
	MessageBox('Error', 'No ha definido el tipo de moneda en la Orden de Compra, Verifique')
	return 0
end if

select count(*)
  into :ll_count
from doc_referencias
where tipo_ref = :is_doc_oc
  and nro_ref	= :ls_nro_oc
  and tipo_doc = :is_doc_aoc;

//Si no hay anticipos entonces no debo validar nada
if ll_count = 0 then return 1

//Si existe un anticipo no debo permitir anular la OC
if is_action = 'anu' then
	MessageBox('Error', 'No puede anular la OC porque tiene ' + string(ll_count) + ' anticipo(s)')
	return 0
end if

//Calculo el total de los Anticipos
select sum(usf_fl_conv_mon(cpd.importe, cp.cod_moneda, :ls_moneda, cp.fecha_emision))
	into :ldc_monto_aoc
from cntas_pagar     cp,
     cntas_pagar_det cpd,
     doc_referencias dr
where cp.cod_relacion = cpd.cod_relacion
  and cp.tipo_doc     = cpd.tipo_doc
  and cp.nro_doc      = cpd.nro_doc
  and dr.cod_relacion = cpd.cod_relacion
  and dr.tipo_doc     = cpd.tipo_doc
  and dr.nro_doc      = cpd.nro_doc
  and dr.tipo_ref     = :is_doc_oc
  and dr.tipo_doc		 = :is_doc_aoc
  and dr.nro_ref      = :ls_nro_oc;
  
//Calculo el monto Total de la OC
of_set_total_oc( )
ldc_monto_oc = Dec(dw_master.object.monto_total[ll_row_mas])

if ldc_monto_aoc > ldc_monto_oc then
	MessageBox('Error', 'El monto de la Orden de Compra no puede ser menor al monto Total de los Anticipos' &
	+ '~r~nNro Orden Compra: ' + ls_nro_oc &
	+ '~r~nCod Moneda      : ' + ls_moneda &
	+ '~r~nMonto de la OC  : ' + string(ldc_monto_oc, '###,##0.00') &
	+ '~r~nNro de Anticipos: ' + string(ll_count)&
	+ '~r~nMonto Total de Anticipos: ' + string(ldc_monto_aoc, '###,##0.00'))
	
	return 0
end if

return 1
end function

public function integer of_precio_unit (long al_row);Decimal	ldc_cant_proyect, ldc_precio_con_igv, ldc_precio_unit, &
			ldc_impuesto, ldc_porc_imp, ldc_descuento, ldc_porc_dscto
String	ls_igv

ldc_precio_unit	= Dec(dw_detail.object.precio_unit[al_row])

ldc_cant_proyect = Dec(dw_detail.object.cant_proyect[al_row])

if ldc_cant_proyect <= 0 or IsNull(ldc_cant_proyect) then
	//MessageBox('Aviso', 'Debe Ingresar primero una cantidad a comprar')
	dw_detail.object.precio_con_igv	[al_row] = 0
	dw_detail.SetColumn('cant_proyect')
	return 0
end if
	
ldc_porc_dscto = Dec(dw_detail.object.porc_dscto[al_row])
If IsNull(ldc_porc_dscto) then
	ldc_porc_dscto = 0
	dw_detail.object.porc_dscto [al_row] = 0
end if
	
ldc_porc_imp 	= Dec(dw_detail.object.porc_impuesto  [al_row])
If IsNull(ldc_porc_imp) then
	ldc_porc_imp = 0
	dw_detail.object.porc_impuesto [al_row] = 0
end if

ldc_descuento = dec(dw_detail.object.decuento[al_row])
if ldc_descuento = 0 or IsNull(ldc_descuento) then
	ldc_descuento 	= ldc_precio_unit * ldc_porc_dscto / 100
end if

if ldc_descuento < 0  then
	MessageBox('Aviso', 'El descuento no puede ser negativo')
	dw_detail.object.porc_dscto	[al_row] = 0
	dw_detail.object.decuento		[al_row] = 0
	return 0
end if

if ldc_descuento > ldc_precio_unit then
	MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
	dw_detail.object.porc_dscto	[al_row] = 0
	dw_detail.object.decuento		[al_row] = 0
	return 0
end if

ldc_impuesto = dec(dw_detail.object.impuesto[al_row])
if ldc_impuesto = 0 or IsNull(ldc_impuesto) then
	ldc_impuesto = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100
end if
	
dw_detail.object.decuento		[al_row] = ldc_descuento
dw_detail.object.impuesto		[al_row] = ldc_impuesto

if ldc_descuento <> 0 and ldc_porc_dscto = 0 then
	ldc_porc_dscto = ldc_descuento / ldc_precio_unit * 100
	dw_detail.object.porc_dscto	[al_row] = ldc_porc_dscto
end if

if ldc_impuesto <> 0 and ldc_porc_imp = 0 then
	if ldc_cant_proyect <> 0 then
		ldc_porc_imp = ldc_impuesto / ((ldc_precio_unit - ldc_descuento) * ldc_cant_proyect) * 100
	else
		ldc_porc_imp = 0
	end if
	dw_detail.object.porc_imp	[al_row] = ldc_porc_imp
end if

if ldc_cant_proyect <> 0 then
	ldc_precio_con_igv = ldc_precio_unit - ldc_descuento + ldc_impuesto / ldc_cant_proyect
else
	ldc_precio_con_igv = 0
end if

dw_detail.object.precio_con_igv[al_row] = round(ldc_precio_con_igv,2)


return 1
end function

public function integer of_precio_con_igv (long al_row);Decimal	ldc_cant_proyect, ldc_precio_con_igv, ldc_precio_unit, &
			ldc_impuesto, ldc_porc_imp, ldc_descuento, ldc_porc_dscto
String	ls_igv

ldc_precio_con_igv = Dec(dw_detail.object.precio_con_igv[al_row])

ldc_cant_proyect = Dec(dw_detail.object.cant_proyect[al_row])

if ldc_cant_proyect <= 0 or IsNull(ldc_cant_proyect) then
	MessageBox('Aviso', 'Debe Ingresar primero una cantidad a comprar')
	dw_detail.object.precio_con_igv	[al_row] = 0
	dw_detail.object.SetColumn('cant_proyect')
	return 0
end if

ldc_porc_dscto = Dec(dw_detail.object.porc_dscto[al_row])
If IsNull(ldc_porc_dscto) then
	ldc_porc_dscto = 0
	dw_detail.object.porc_dscto [al_row] = 0
end if
	
ldc_porc_imp 	= Dec(dw_detail.object.porc_impuesto  [al_row])
If IsNull(ldc_porc_imp) then
	ldc_porc_imp = 0
	dw_detail.object.porc_impuesto [al_row] = 0
end if

//Primero obtengo el precio sin el IGV
ldc_precio_unit = ldc_precio_con_igv / (1 + ldc_porc_imp/100)

//Luego le saco el descuento, el resultado es el precio unitario
ldc_precio_unit = ldc_precio_unit / (1 - ldc_porc_dscto/100)
dw_detail.object.precio_unit[al_row] = ldc_precio_unit

//Ahora obtengo el descuento
ldc_descuento 	= ldc_precio_unit * ldc_porc_dscto / 100

if ldc_descuento < 0  then
	MessageBox('Aviso', 'El descuento no puede ser negativo')
	dw_detail.object.porc_dscto	[al_row] = 0
	dw_detail.object.decuento		[al_row] = 0
	return 0
end if

if ldc_descuento > ldc_precio_unit then
	MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
	dw_detail.object.porc_dscto	[al_row] = 0
	dw_detail.object.decuento		[al_row] = 0
	return 0
end if

//Luego el impuesto 
ldc_impuesto = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100
	
dw_detail.object.decuento		[al_row] = ldc_descuento
dw_detail.object.impuesto		[al_row] = ldc_impuesto

if ldc_descuento <> 0 and ldc_porc_dscto = 0 then
	ldc_porc_dscto = ldc_descuento / ldc_precio_unit * 100
	dw_detail.object.porc_dscto	[al_row] = ldc_porc_dscto
end if

if ldc_impuesto <> 0 and ldc_porc_imp = 0 then
	if ldc_cant_proyect <> 0 then
		ldc_porc_imp = ldc_impuesto / ((ldc_precio_unit - ldc_descuento) * ldc_cant_proyect) * 100
	else
		ldc_porc_imp = 0
	end if
	dw_detail.object.porc_imp	[al_row] = ldc_porc_imp
end if

return 1
end function

public function integer of_fondo_oc (string as_origen);// Obtengo el fondo de compras de acuerdo al origen

select cencos_oc, cnta_prsp_oc, NVL(FLAG_OC_PRSP, '0')
	into :is_cencos_oc, :is_cnta_prsp_oc, :is_flag_oc_prsp
from origen
where cod_origen = :as_origen;

IF SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No existen datos para el ORIGEN ' + as_origen)
	return 0
end if

if (IsNull(is_cencos_oc) or is_cencos_oc = '') and is_flag_oc_prsp = '1' then
	MessageBox('Aviso', 'No ha especificado el centro de costo de la Bolsa de compras para el ORIGEN ' + as_origen)
	return 0
end if

if (IsNull(is_cnta_prsp_oc) or is_cnta_prsp_oc = '') and is_flag_oc_prsp = '1' then
	MessageBox('Aviso', 'No ha especificado la cuenta presupuestal de la Bolsa de compras para el ORIGEN ' + as_origen)
	return 0
end if

return 1
end function

public function integer of_nro_cnta_banco (string as_banco);string 	ls_proveedor, ls_moneda, ls_nro_cuenta
Long 		ll_row, ll_count

if dw_master.Getrow() = 0 then return 0
dw_master.Accepttext( )

ll_row = dw_master.GetRow()

ls_proveedor = dw_master.object.proveedor	[ll_row]
ls_moneda	 = dw_master.object.cod_moneda[ll_row]

if ls_proveedor = '' or IsNull(ls_proveedor) then
	MessageBox('Aviso', 'Debe especificar un código de proveedor')
	dw_master.SetFocus()
	dw_master.SetColumn('proveedor')
	return 0
end if

if ls_moneda = '' or IsNull(ls_moneda) then
	MessageBox('Aviso', 'Debe especificar un código de moneda')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_moneda')
	return 0
end if

if as_banco = '' or IsNull(as_banco) then
	MessageBox('Aviso', 'Debe especificar un código de banco')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_banco')
	return 0
end if

select cnta_bco_prov
  into :ls_nro_cuenta
  from prov_banco_cnta
where proveedor  = :ls_proveedor
  and cod_banco  = :as_banco
  and cod_moneda = :ls_moneda;

if SQLCA.Sqlcode = 100 then SetNull(ls_nro_cuenta)

dw_master.object.nro_cuenta [ll_row] = ls_nro_cuenta

return 1
end function

public function integer of_banco_prov ();string 	ls_proveedor, ls_moneda, ls_banco, ls_nom_banco
Long 		ll_row, ll_count

if dw_master.Getrow() = 0 then return 0

dw_master.Accepttext( )

ll_row = dw_master.GetRow()

ls_proveedor = dw_master.object.proveedor	[ll_row]
ls_moneda	 = dw_master.object.cod_moneda[ll_row]

if ls_proveedor = '' or IsNull(ls_proveedor) then
	MessageBox('Aviso', 'Debe especificar un código de proveedor')
	dw_master.SetFocus()
	dw_master.SetColumn('proveedor')
	return 0
end if

if ls_moneda = '' or IsNull(ls_moneda) then
	MessageBox('Aviso', 'Debe especificar un código de moneda')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_moneda')
	return 0
end if

select count (*)
  into :ll_count
  from prov_banco_cnta 	a,
  		 banco				b
where a.cod_banco = b.cod_banco
  and a.proveedor  = :ls_proveedor
  and a.cod_moneda = :ls_moneda;

if ll_count = 1 then  
	select b.cod_banco, b.nom_banco
	  into :ls_banco, :ls_nom_banco
	  from prov_banco_cnta 	a,
			 banco				b
	where a.cod_banco = b.cod_banco
	  and a.proveedor  = :ls_proveedor
	  and a.cod_moneda = :ls_moneda;
	
	dw_master.object.cod_banco [ll_row] = ls_banco
	dw_master.object.nom_banco [ll_row] = ls_nom_banco
	
	of_nro_cnta_banco( ls_banco )
	
end if

return 1
end function

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
idw_1 = dw_master              			// asignar dw corriente
dw_detail.BorderStyle = StyleRaised! 	// indicar dw_detail como no activado
dw_master.of_protect()         			// bloquear modificaciones 
dw_detail.of_protect()

ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
// ii_help = 101           // help topic	

dw_master.object.p_logo.filename = gnvo_app.is_logo

if is_flag_aut_oc = '0' then
	dw_master.object.b_aprueba.visible = false
	dw_master.object.b_desaprueba.visible = false
end if

is_backColor = string(dw_master.object.fec_registro.background.color)
end event

on w_cm311_orden_compra.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_lista" then this.MenuID = create m_mtto_lista
this.rb_catalogo=create rb_catalogo
this.cb_1=create cb_1
this.st_nro=create st_nro
this.sle_ori=create sle_ori
this.st_ori=create st_ori
this.pb_1=create pb_1
this.rb_ot=create rb_ot
this.rb_programa=create rb_programa
this.gb_1=create gb_1
this.dw_master=create dw_master
this.dw_detail=create dw_detail
this.em_vn=create em_vn
this.em_imp=create em_imp
this.em_dcto=create em_dcto
this.em_vb=create em_vb
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_nro=create sle_nro
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_catalogo
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_nro
this.Control[iCurrent+4]=this.sle_ori
this.Control[iCurrent+5]=this.st_ori
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.rb_ot
this.Control[iCurrent+8]=this.rb_programa
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.dw_master
this.Control[iCurrent+11]=this.dw_detail
this.Control[iCurrent+12]=this.em_vn
this.Control[iCurrent+13]=this.em_imp
this.Control[iCurrent+14]=this.em_dcto
this.Control[iCurrent+15]=this.em_vb
this.Control[iCurrent+16]=this.st_4
this.Control[iCurrent+17]=this.st_3
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.st_1
this.Control[iCurrent+20]=this.sle_nro
end on

on w_cm311_orden_compra.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_catalogo)
destroy(this.cb_1)
destroy(this.st_nro)
destroy(this.sle_ori)
destroy(this.st_ori)
destroy(this.pb_1)
destroy(this.rb_ot)
destroy(this.rb_programa)
destroy(this.gb_1)
destroy(this.dw_master)
destroy(this.dw_detail)
destroy(this.em_vn)
destroy(this.em_imp)
destroy(this.em_dcto)
destroy(this.em_vb)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_nro)
end on

event ue_insert;call super::ue_insert;Long  ll_row, ll_mov_atrazados
n_cst_diaz_retrazo lnvo_amp_retr

if of_comprador() = 0 then return

if idw_1 = dw_master then 		
	// Verifica tipo de cambio
	id_fecha_proc = f_fecha_actual(1)
	in_tipo_cambio = f_get_tipo_cambio(Date(id_fecha_proc))
	
	if in_tipo_cambio = 0 THEN return
	dw_master.reset()
	dw_detail.reset()
	
	is_action = 'new'
else
	IF dw_master.getrow() = 0 then return
	if rb_programa.checked = true or rb_ot.checked = true then
		return
	end if
end if

ll_row = idw_1.Event ue_insert()
IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

of_set_modify()
end event

event ue_print;call super::ue_print;IF dw_master.rowcount() = 0 then return

IF dw_master.object.flag_estado[dw_master.getrow()] = '3' THEN 
	MessageBox('Aviso','Documento no aprobado')
	Return
END IF 

if dw_master.ii_update = 1 or dw_detail.ii_update = 1 then
	MessageBox('Aviso','Existen cambios pendientes, por favor grabe primero')
	Return
end if

w_cm311_orden_compra_frm lw_1

str_parametros lstr_rep

lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_oc[dw_master.getrow()]

lstr_rep.d_datos[1] = dec(em_vb.text)
lstr_rep.d_datos[2] = dec(em_dcto.text)
lstr_rep.d_datos[3] = dec(em_imp.text)
lstr_rep.d_datos[4] = dec(em_vn.text)

OpenSheetWithParm(lw_1, lstr_rep, w_main, 2, Layered!)
end event

event ue_update_pre;string 	ls_moneda
long		ll_i

of_set_total_oc()

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then	return

if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle")
	return
end if

if of_verifica_precio() = 0 then return	

if of_verifica_fondo_oc() = 0 then return	

if of_verifica_aoc() = 0 then return	

ls_moneda = dw_master.object.cod_moneda [dw_master.GetRow()]

for ll_i = 1 to dw_detail.RowCount()
	dw_detail.object.cod_moneda[ll_i] = ls_moneda
next

//of_set_total_oc()
if of_set_numera() = 0 then return	
IF	of_crea_mov_proy() = 0 then return

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

event ue_update;call super::ue_update;Boolean 	lb_ok = TRUE
string 	ls_mens1, ls_mens2

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 	
	ROLLBACK USING SQLCA;
	RETURN
END IF

// Verifico los cambios en el Detalle de la Orden de Compra
if of_cambios_amp() = false then return


is_tabla_m = dw_master.Object.Datawindow.Table.UpdateTable  //Nombre de tabla a grabar en el Log Diario
is_tabla_d = 'AMP_OC'//dw_detail.Object.Datawindow.Table.UpdateTable  //Nombre de tabla a grabar en el Log Diario

// Grabo el Log de Maestro
IF ib_log and dw_master.ii_update = 1 THEN
	u_ds_base		lds_log_m
	lds_log_m = Create u_ds_base
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gnvo_app.is_user, is_tabla_m, gnvo_app.invo_empresa.is_empresa)
END IF

// Grabo el Log del Detalle
IF ib_log and dw_detail.ii_update = 1 THEN
	u_ds_base		lds_log_d
	lds_log_d = Create u_ds_base
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_d.SetTransObject(SQLCA)
	in_log.of_create_log(dw_detail, lds_log_d, is_colname_d, is_coltype_d, gnvo_app.is_user, is_tabla_d, gnvo_app.invo_empresa.is_empresa)
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lb_ok = FALSE
		ls_mens1 = "Error en Grabacion Master"
		ls_mens2 = "Se ha procedido al rollback"	
	END IF
END IF

IF dw_detail.ii_update = 1 AND lb_ok = TRUE THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lb_ok = FALSE
		ls_mens1 = "Error en Grabacion Detalle"
		ls_mens2 = "Se ha procedido al rollback"		
	END IF
END IF

IF ib_log and lb_ok THEN
	if dw_master.ii_update = 1 then
		IF lds_log_m.Update() = -1 THEN
			lb_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario del maestro')
		END IF
		DESTROY lds_log_m
	end if
	
	if dw_detail.ii_update = 1 then
		IF lds_log_d.Update() = -1 THEN
			lb_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario del detalle')
		END IF
		DESTROY lds_log_d
	end if
END IF

IF lb_ok THEN
	
	if of_oc_importacion() = 0 then return
	if of_validar_oc(dw_master.object.nro_oc[dw_master.GetRow()]) = false then return
	
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	is_action = 'open'
	of_retrieve(dw_master.object.cod_origen[dw_master.GetRow()], dw_master.object.nro_oc[dw_master.GetRow()])
	
	of_set_status_doc( dw_master)
ELSE 
	ROLLBACK USING SQLCA;
	MessageBox(ls_mens1,ls_mens2,exclamation!)
END IF
end event

event ue_modify;call super::ue_modify;int 		li_protect
Long		ll_i
Decimal	ldc_cant_procesada, ldc_cant_facturada
string	ls_flag_estado

if of_comprador() = 0 then return

if is_action <> 'open' and is_action <> 'edit' then return

if is_action='edit' then
	is_action = 'open'
	dw_master.of_protect()
	dw_detail.of_protect()
	return
end if

IF dw_master.rowcount() = 0 then return

ls_flag_estado = dw_master.object.flag_estado[dw_master.GetRow()]

/*
	ls_flag_estado = 0   ---> Anulado
	ls_flag_estado = 1   ---> Abierto
	ls_flag_estado = 2   ---> Cerrado (Atendido Totalmente)
*/

if ls_flag_estado = '0' then
	MessageBox('Aviso', 'No puede modificar esta Orden de Compra, esta anulada')
	return
end if

ldc_cant_procesada = 0
ldc_cant_facturada = 0
for ll_i=1 to dw_detail.RowCount()
	ldc_cant_procesada += dec(dw_detail.object.cant_procesada[ll_i])
	ldc_cant_facturada += dec(dw_detail.object.cant_facturada[ll_i])
next
if is_action = 'open' then
	is_action = 'edit'
end if

dw_master.of_protect()
dw_detail.of_protect()

// Verifica tipo de cambio
in_tipo_cambio = f_get_tipo_cambio( DATE(dw_master.object.fec_registro[dw_master.getrow()]))
if in_tipo_cambio = 0 THEN return

//No se puede cambiar el codigo de articulo
li_protect = integer(dw_detail.Object.cod_Art.Protect)
IF li_protect = 0 THEN
	dw_detail.Object.cod_Art.Protect = 1
END IF

// No se puede cambiar el codigo de proveedor si la OC
// ya tiene ingresos a almacen
li_protect = integer(dw_master.Object.proveedor.Protect)
IF li_protect = 0 and ldc_cant_procesada > 0 THEN
	dw_master.Object.proveedor.Protect = 1
END IF

// No se puede cambiar la forma de pago si la OC
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

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - this.cii_windowborder
dw_detail.width  = newwidth  - dw_detail.x - this.cii_windowborder
dw_detail.height = p_pie.y - dw_detail.y - this.cii_windowborder

gb_1.width  = dw_master.width  - gb_1.x - 15

// Controles

em_vb.y   = p_pie.y + (p_pie.height - em_vb.height) / 2
em_dcto.y = p_pie.y + (p_pie.height - em_dcto.height) / 2
em_imp.y  = p_pie.y + (p_pie.height - em_imp.height) / 2
em_vn.y   = p_pie.y + (p_pie.height - em_vn.height) / 2
st_1.y    = p_pie.y + (p_pie.height - st_1.height) / 2
st_2.y    = p_pie.y + (p_pie.height - st_2.height) / 2
st_3.y    = p_pie.y + (p_pie.height - st_3.height) / 2
st_4.y    = p_pie.y + (p_pie.height - st_4.height) / 2

p_pie.bringtotop = false
end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

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

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_delete;// Override
Long  ll_row, ll_item

if of_comprador() = 0 then return

IF dw_master.rowcount() = 0 then return
if idw_1 = dw_master then 
	Messagebox( "Operacion no válida", "No se permite Eliminar este documento")	
	return 
end if

if dw_detail.rowcount() = 1 then
	messagebox( "Operacion no válida", "No se permite dejar el documento vacio")
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

of_Set_Status_doc(dw_detail)

end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_m, is_coltype_m)
	in_log.of_dw_map(dw_detail, is_colname_d, is_coltype_d)
END IF
end event

event ue_close_pre;call super::ue_close_pre;destroy in_log
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
this.event ue_update_request()

str_parametros sl_param

sl_param.dw1 = "d_sel_orden_compra_tbl"   //"d_dddw_orden_compra_tbl"  // //
sl_param.titulo = "Ordenes de compra"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
END IF
end event

type p_pie from w_abc`p_pie within w_cm311_orden_compra
end type

type ole_skin from w_abc`ole_skin within w_cm311_orden_compra
end type

type uo_h from w_abc`uo_h within w_cm311_orden_compra
end type

type st_box from w_abc`st_box within w_cm311_orden_compra
end type

type phl_logonps from w_abc`phl_logonps within w_cm311_orden_compra
end type

type p_mundi from w_abc`p_mundi within w_cm311_orden_compra
end type

type p_logo from w_abc`p_logo within w_cm311_orden_compra
end type

type rb_catalogo from radiobutton within w_cm311_orden_compra
integer x = 1573
integer y = 1160
integer width = 558
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Catalogo de Articulos"
end type

event clicked;is_ref = 'ca'

//// Activa input's
//dw_detail.object.cencos.background.color = RGB(255,255,255)
//dw_detail.object.cnta_prsp.background.color = RGB(255,255,255)
//dw_detail.object.cencos.protect = 0
//dw_detail.object.cnta_prsp.protect = 0


pb_1.enabled = false
of_set_status_doc( idw_1)
end event

type cb_1 from commandbutton within w_cm311_orden_compra
integer x = 1851
integer y = 160
integer width = 402
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;EVENT ue_update_request()
of_retrieve(sle_ori.text, sle_nro.text)
end event

type st_nro from statictext within w_cm311_orden_compra
integer x = 1065
integer y = 180
integer width = 251
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Numero:"
boolean focusrectangle = false
end type

type sle_ori from singlelineedit within w_cm311_orden_compra
integer x = 773
integer y = 168
integer width = 229
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type st_ori from statictext within w_cm311_orden_compra
integer x = 530
integer y = 180
integer width = 233
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Origen:"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_cm311_orden_compra
integer x = 2190
integer y = 1160
integer width = 110
integer height = 76
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "h:\Source\Bmp\file_open.bmp"
string disabledname = "h:\Source\Bmp\file_close.bmp"
end type

event clicked;// Asigna valores a structura
str_parametros 	lstr_param, lstr_datos
string			ls_nro_doc = ''

if is_action = 'open' then   // Cuando adiciona
	// Verifica tipo de cambio
	in_tipo_cambio = f_get_tipo_cambio( DATE(dw_master.object.fec_registro[dw_master.getrow()]))
	if in_tipo_cambio = 0 THEN return
end if

if of_verifica_datos() = 0 then return // Verifica que datos se han ingresado en cabecera

// Verifica que ha indicado un tipo
if rb_programa.checked = false and rb_ot.checked = false and &
	rb_catalogo.checked = false then 
	Messagebox( "Atencion", "Seleccione de donde extraer los datos")
	return 
end if

lstr_param.w1 = parent

IF rb_programa.checked = true then  	// Programa de compras
	SetNull(lstr_param.fecha1)
	SetNull(lstr_param.fecha2)
	lstr_param.tipo = 'PROG_COMPRAS'
	
	OpenWithParm( w_abc_datos_ot, lstr_param )
	
	if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return
	
	lstr_param = Message.PowerObjectParm
	if lstr_param.titulo = 'n' then return
	
	if is_FLAG_RESTRIC_COMP_OC = '1' then
		lstr_param.dw_master 	= "d_list_prog_compras_pend_usuario_tbl"
		lstr_param.dw1 			= 'd_sel_progr_compras_pend_usuario_det'
	else
		lstr_param.dw_master 	= "d_list_prog_compras_pend_tbl"
		lstr_param.dw1 			= 'd_sel_programa_compras_pend_det'
	end if
	
	lstr_param.titulo 		= "Programas de compra pendientes"
	lstr_param.dw_m 			= dw_master
	lstr_param.dw_d 			= dw_detail
	lstr_param.string6		= gnvo_app.is_user
	lstr_param.flag_cntrl_fondos	= is_flag_cntrl_fondos
	lstr_param.tipo			= 'PROG_COMPRAS'
	
	if is_FLAG_RESTRIC_COMP_OC = '1' then
		lstr_param.opcion 		= 13	
	else
		lstr_param.opcion 		= 2	
	end if
	
	OpenWithParm( w_abc_seleccion_md, lstr_param)

	
elseIF rb_ot.checked = true then  	// Ordenes de Compras a Partir de OT's
	lstr_param.tipo = ''
	SetNull(lstr_param.fecha1)
	SetNull(lstr_param.fecha2)
	
	OpenWithParm( w_abc_datos_ot, lstr_param )
	
	if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return
	
	lstr_param = Message.PowerObjectParm
	if lstr_param.titulo = 'n' then return
	
	lstr_param.dw_master 	= "d_list_orden_trabajo_grd"
	lstr_param.dw1       	= "d_list_articulo_mov_proy_x_ot_grd"	
	lstr_param.titulo 		= "Ordenes de Trabajo pendientes"
	lstr_param.dw_m 			= dw_master
	lstr_param.dw_d 			= dw_detail
	lstr_param.tipo_doc		= is_doc_ot
	lstr_param.opcion 		= 12
	lstr_param.tipo			= 'NRO_DOC'
	lstr_param.oper_cons_interno = is_oper_cons_int
	lstr_param.flag_cntrl_fondos = is_flag_cntrl_fondos

	OpenWithParm( w_abc_seleccion_md, lstr_param)
	
end if

of_set_modify()
end event

type rb_ot from radiobutton within w_cm311_orden_compra
integer x = 1074
integer y = 1160
integer width = 498
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Orden de Trabajo"
end type

event clicked;is_ref = 'ot'

//// Activa input's
//dw_detail.object.cencos.background.color = RGB(255,255,255)
//dw_detail.object.cnta_prsp.background.color = RGB(255,255,255)
//dw_detail.object.cencos.protect = 0
//dw_detail.object.cnta_prsp.protect = 0


if is_action = 'new' or is_action = 'edit' then
	pb_1.enabled = true
end if
of_set_status_doc( idw_1)
end event

type rb_programa from radiobutton within w_cm311_orden_compra
integer x = 549
integer y = 1160
integer width = 530
integer height = 76
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

event clicked;is_ref = is_doc_prog

if is_action = 'new' or is_action = 'edit' then
	pb_1.enabled = true
end if

of_set_status_doc( idw_1)
end event

type gb_1 from groupbox within w_cm311_orden_compra
integer x = 521
integer y = 1104
integer width = 1792
integer height = 140
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Extraer de:"
end type

type dw_master from u_dw_abc within w_cm311_orden_compra
event ue_display ( string as_columna,  long al_row )
event ue_cerrar ( )
integer x = 503
integer y = 280
integer width = 3333
integer height = 980
integer taborder = 50
string dataobject = "d_abc_o_compra_cab_211"
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cat_art, &
			ls_cod_art, ls_proveedor, ls_moneda, ls_banco
str_parametros sl_param

choose case lower(as_columna)
		
	case "proveedor"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor, " &
				  + "ruc AS ruc_proveedor " &
				  + "FROM proveedor " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "job"
		ls_sql = "SELECT job AS CODIGO_job, " &
				  + "DESCripcion AS DESCRIPCION_job " &
				  + "FROM job " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "1")
		
		if ls_codigo <> "" then
			this.object.job		[al_row] = ls_codigo
			this.object.desc_job	[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "cod_banco"

		ls_proveedor = this.object.proveedor  [al_row]
		ls_moneda	 = this.object.cod_moneda [al_row]
		
		if ls_proveedor = '' or IsNull(ls_proveedor) then
			MessageBox('Aviso', 'Debes Ingresar un código de proveedor')
			dw_master.SetColumn('proveedor')
			return
		end if
		
		if ls_moneda = '' or IsNull(ls_moneda) then
			MessageBox('Aviso', 'Debes Ingresar un código de moneda')
			dw_master.SetColumn('cod_moneda')
			return 
		end if

		ls_sql = "SELECT distinct a.cod_banco AS codigo_banco, " &
				  + "a.nom_banco AS nombre_banco " &
				  + "FROM banco a, " &
				  + "prov_banco_cnta b " &
				  + "where a.cod_banco = b.cod_banco " &
				  + "and b.proveedor = '" + ls_proveedor + "' " &
				  + "and b.cod_moneda = '" + ls_moneda + "' "
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cod_banco	[al_row] = ls_codigo
			this.object.nom_banco	[al_row] = ls_data
			this.ii_update = 1
			of_nro_cnta_banco( ls_codigo )
		end if
	

	case "nro_cuenta"

		ls_proveedor = this.object.proveedor  [al_row]
		ls_moneda	 = this.object.cod_moneda [al_row]
		ls_banco		 = this.object.cod_banco  [al_row]
		
		if ls_proveedor = '' or IsNull(ls_proveedor) then
			MessageBox('Aviso', 'Debes Ingresar un código de proveedor')
			dw_master.SetColumn('proveedor')
			return
		end if
		
		if ls_moneda = '' or IsNull(ls_moneda) then
			MessageBox('Aviso', 'Debes Ingresar un código de moneda')
			dw_master.SetColumn('cod_moneda')
			return 
		end if
	
		if ls_banco = '' or IsNull(ls_banco) then
			MessageBox('Aviso', 'Debes Ingresar un código de banco')
			dw_master.SetColumn('cod_banco')
			return 
		end if

		ls_sql = "SELECT distinct CNTA_BCO_PROV AS nro_cuenta, " &
				  + "TIPO_CNTA_PROV AS TIPO_CNTA_PROV " &
				  + "FROM prov_banco_cnta " &
				  + "where cod_banco = '" + ls_banco + "' " &
				  + "and proveedor = '" + ls_proveedor + "' " &
				  + "and cod_moneda = '" + ls_moneda + "' "
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "1")
		
		if ls_codigo <> "" then
			this.object.nro_cuenta	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "uo_dst_pago"
		ls_sql = "SELECT cod_origen AS codigo_origen, " &
				  + "nombre AS nombre_origen " &
				  + "FROM origen " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "1")
		
		if ls_codigo <> "" then
			this.object.uo_dst_pago	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "ot_gastos"
		sl_param.dw1     = "d_abc_lista_orden_trabajo_x_usr_tbl"
		sl_param.titulo  = "Orden de Trabajo"
		sl_param.tipo    = "1SQL"
		sl_param.string1 =  " WHERE (USUARIO = '" + gnvo_app.is_user + "') " &
								 +"ORDER BY FEC_SOLICITUD DESC"
								 
		sl_param.field_ret_i[1] = 2
		
		OpenWithParm( w_lista, sl_param)
		
		sl_param = Message.PowerObjectParm
		IF sl_param.titulo <> "n" THEN
			this.object.ot_gastos[al_row] = sl_param.field_ret[1]
			this.ii_update = 1
		END IF		

	CASE "item"					
			
		ls_proveedor = dw_master.object.proveedor [al_row]		
		IF Isnull(ls_proveedor) OR Trim(ls_proveedor)  = "" THEN
			Messagebox("Aviso","Debe Ingresar Codigo de Proveedor , Verifique!")
			Return 
		END IF
		
		// Solo Tomo la Direccion de facturacion
		ls_sql = "SELECT ITEM AS ITEM," &    
				 + "TRIM(DIR_DIRECCION)  || ' ' || TRIM(DIR_DEP_ESTADO) || ' ' || TRIM(DIR_DISTRITO) AS DIRECCION, " &
				 + "DIR_URBANIZACION AS URBANIZACION," &
				 + "DIR_MNZ          AS MANZANA		," &
				 + "DIR_LOTE         AS LOTE			," &
				 + "DIR_NUMERO       AS NUMERO		," &
				 + "DIR_PAIS         AS PAIS			," &     
				 + "DESCRIPCION      AS DESCRIPCION "  &
				 + "FROM DIRECCIONES "&
				 + "WHERE CODIGO = '" + ls_proveedor +"' " &
				 + "AND FLAG_USO = '1'"
												
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "1")
		
		if ls_codigo <> "" then
			this.object.item		[al_row] = Integer(ls_codigo)
			this.object.direccion[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event constructor;call super::constructor;is_mastdet = 'md'	
is_dwform = 'form' // tabular form
idw_det  = dw_detail
 
ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

end event

event ue_insert_pre;// Asigna datos 

// Si el flag de mod fec de la OC esta activo entonces la fecha de la OC la puedo modificar
// de lo contrario no puedo modificarlo
if is_flag_mod_fec_oc = '1' then
	this.object.fec_registro.protect = '0'
	this.object.fec_registro.Background.Color = RGB(255,255,255)
else
	this.object.fec_registro.protect = '1'
	this.object.fec_registro.background.color = is_backColor
end if

this.object.fec_registro		[al_row] = f_fecha_actual(1)
this.object.cod_origen			[al_row] = gnvo_app.is_origen
this.object.uo_dst_pago			[al_row] = gnvo_app.is_origen

if is_flag_aut_oc = '1' then
	this.object.flag_estado			[al_row] = '3' // Estado pendiente
else
	this.object.flag_estado			[al_row] = '1' // Aprobado
end if

this.object.cod_usr				[al_row] = gnvo_app.is_user
this.object.flag_cotizacion	[al_row] = '0'   // Sin cotizacion
this.object.flag_importacion	[al_row] = '0'

// Busco la bolsa de compras
of_fondo_oc(gnvo_app.is_origen)

// Limpia totales
em_vb.text = ''
em_dcto.text = ''
em_imp.text = ''
em_vn.text = ''

rb_programa.enabled 	= true
//rb_ot.enabled 			= true
rb_catalogo.enabled 	= true

rb_ot.event clicked()

is_action = 'new'		// flag cuando es nuevo documento
of_set_status_doc(this)

if is_flag_mod_fec_oc = '1' then
	this.SetColumn('fec_registro')
else
	this.SetColumn('proveedor')
end if


end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

//of_set_status_doc( dw_master)  // Activa opcion de menu
end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 
str_parametros lstr_param
String 	ls_provee, ls_estado, ls_nro_doc, ls_origen, ls_msj, ls_null
long 		ll_row, ll_count, ll_opcion 
Date 		ld_null 

this.AcceptText()

if dwo.name = 'b_reprogramar' then
	
	if MessageBox('Aviso', 'Desea reprogramar todos los items de la OC?', Question!, YesNo!, 2) = 2 then return
	
	Open(w_get_fecha)
	
	if IsNull(Message.PowerObjectparm) or not IsValid(Message.PowerObjectparm) then return
	
	if Message.PowerObjectparm.Classname() <> 'str_parametros' then return
	
	lstr_param = Message.PowerObjectParm
	
	if lstr_param.titulo = 'n' then return
	
	for ll_row = 1 to dw_detail.RowCount( )
		if dw_detail.object.flag_estado [ll_row] = '1' and &
			dw_detail.object.cant_procesada[ll_row] = 0 then
			
			dw_detail.object.fec_proyect [ll_row] = lstr_param.fecha1
			dw_detail.ii_update = 1
			
		end if;
	next
	
elseif dwo.name = 'b_aprueba' then
	// Verifica si documento previamente ha sido grabado
	IF dw_master.GetRow()=0 THEN Return
	
	ls_origen = dw_master.object.cod_origen[row] 
	ls_nro_doc = dw_master.object.nro_oc[row] 
	
	if IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
		MessageBox('Error', 'Grabe orden de compra antes de aprobar')
		return
	end if
	
	// Verifica si usuario es aprobador
	SELECT count(*) 
		INTO :ll_count 
	FROM logistica_aprobador l 
	WHERE cod_usr = :gnvo_app.is_user ;
	
	IF ll_count=0 THEN 
		MessageBox('Aviso','Usuario no es aprobador de doc. de compra')
		Return
	END IF
	
	DECLARE usp_cmp_vobo_doc_compra PROCEDURE FOR 
		usp_cmp_vobo_doc_compra ( :is_doc_oc, 
									 	  :ls_origen, 
										  :ls_nro_doc, 	
									 	  :gnvo_app.is_user ) ;
								 
	EXECUTE usp_cmp_vobo_doc_compra ;

	IF sqlca.sqlcode = -1 THEN
		ls_msj = sqlca.sqlerrtext
		ROLLBACK ;
		MessageBox( 'Error usp_cmp_vobo_doc_compra', ls_msj, StopSign! )
		return
	END IF
	
	CLOSE usp_cmp_vobo_doc_compra;
	
	of_retrieve(ls_origen, ls_nro_doc)	
	
elseif dwo.name = 'b_desaprueba' then
	// Verifica si documento previamente ha sido grabado
	IF dw_master.GetRow()=0 THEN Return
	
	ls_origen = dw_master.object.cod_origen[row] 
	ls_nro_doc = dw_master.object.nro_oc[row] 
	
	if IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
		MessageBox('Error', 'Grabe orden de compra antes de aprobar')
		return
	end if
	
	ISNULL(ls_null)
	ISNULL(ld_null)
	// Verifica si usuario es aprobador
	SELECT count(*) 
		INTO :ll_count 
	FROM logistica_aprobador l 
	WHERE cod_usr = :gnvo_app.is_user ;
	
	IF ll_count=0 THEN 
		MessageBox('Aviso','Usuario no es aprobador de doc. de compra')
		Return
	END IF
	
	DECLARE USP_CMP_DESAPROBAR_DOC_COMPRA PROCEDURE FOR 
		USP_CMP_DESAPROBAR_DOC_COMPRA ( :is_doc_oc, 
									 	  		  :ls_origen, 
										  		  :ls_nro_doc, 	
									 	  		  :gnvo_app.is_user ) ;
								 
	EXECUTE USP_CMP_DESAPROBAR_DOC_COMPRA ;

	IF sqlca.sqlcode = -1 THEN
		ls_msj = sqlca.sqlerrtext
		ROLLBACK ;
		MessageBox( 'Error usp_cmp_desaprobar_doc_compra', ls_msj, StopSign! )
		return
	END IF
	
	CLOSE USP_CMP_DESAPROBAR_DOC_COMPRA ;
	
	of_retrieve(ls_origen, ls_nro_doc)
	
END IF 

//if this.Describe( "proveedor.Protect") = '1' then return

if dwo.name = 'b_vendedor' then
	// Verificar que codigo de proveedor se halla ingresado
	ls_provee = this.object.proveedor[row]
	if isnull( ls_provee) or TRIM( ls_provee) = '' then
		Messagebox( "Atencion", "Ingresar proveedor", Exclamation!)
		dw_master.Setcolumn( 1)
		return
	end if
	
	lstr_param.dw1 = "d_abc_representante_tbl"
	lstr_param.titulo = "Representantes"
	lstr_param.field_ret_i[1] = 3		
	lstr_param.tipo = '1S'
	lstr_param.string1 = ls_provee

	OpenWithParm( w_lista, lstr_param)
	
	if IsNull(Message.PowerObjectparm) or not IsValid(Message.PowerObjectparm) then return
	
	if Message.PowerObjectparm.Classname() <> 'str_parametros' then return

	lstr_param = MESSAGE.POWEROBJECTPARM
	if lstr_param.titulo <> 'n' then
		this.object.nom_vendedor[row] = left(lstr_param.field_ret[1],40)
		this.ii_update = 1		// activa flag de modificado
	END IF
	
elseif dwo.name = 'b_prov' then
	
	lstr_param.dw1 = "d_list_proveedor"
	lstr_param.titulo = "Proveedores"
	lstr_param.field_ret_i[1] = 1
	lstr_param.field_ret_i[2] = 2

	OpenWithParm( w_lista, lstr_param)		
	
	if IsNull(Message.PowerObjectparm) or not IsValid(Message.PowerObjectparm) then return
	
	if Message.PowerObjectparm.Classname() <> 'str_parametros' then return
	
	lstr_param = MESSAGE.POWEROBJECTPARM
	if lstr_param.titulo <> 'n' then		
		this.object.proveedor		[row] = lstr_param.field_ret[1]
		this.object.nom_proveedor	[row] = lstr_param.field_ret[2]
		ii_update = 1
	END IF		
	
elseif dwo.name = 'b_importacion' then
	if is_action = 'new' then
		MessageBox('Aviso', 'Tiene que grabar primero la Orden de Compra antes de ingresar los datos')
		return
	end if
	
	if this.object.flag_importacion [row] = '0' then
		MessageBox('Aviso', 'La Orden de compra no es de importacion')
		return
	end if
	
	if IsNull(this.object.nro_oc[row]) &
		or trim(this.object.nro_oc[row]) = '' then
		MessageBox('Error', 'Numero de la Orden de Compra no se encuentra definido')
		return
	end if

	ls_estado = this.object.flag_estado [row]
	if ls_estado = '0' then
		MessageBox('Aviso', 'Orden de Compra esta anulada no se puede ingresar datos')
		return
	end if

	if ls_estado = '2' then
		MessageBox('Aviso', 'Orden de Compra esta cerrada no se puede ingresar datos')
		return
	end if
	
	lstr_param.origen = this.object.cod_origen [row]
	lstr_param.nro_oc = this.object.nro_oc	  [row]
	
	OpenWithParm(w_cm324_oc_importacion, lstr_param)
	
END IF


end event

event itemchanged;call super::itemchanged;// Verifica datos
Long 		ll_j
String 	ls_proveedor, ls_desc, ls_null, ls_moneda, ls_banco
Integer 	li_item

SetNull(ls_null)

if dwo.name = 'proveedor' then	
	
	Select nom_proveedor 
		into :ls_proveedor
	from proveedor 
	where proveedor = :data
	  and flag_estado = '1';
	  
	if sqlca.sqlcode = 100 then
		Messagebox( "Error", "Proveedor no existe o no esta activo")
		this.object.proveedor		[row] = ls_null
		this.object.nom_proveedor 	[row] = ls_null
		Return 1
	end if
	
	this.object.nom_proveedor[row] = ls_proveedor
	
elseif dwo.name = 'cod_moneda' then
	
	for ll_j = 1 to dw_detail.RowCount()
		dw_detail.object.cod_moneda[ll_j] = data
		dw_detail.ii_update = 1
	Next

	this.object.cod_banco 	[row] = ls_null
	this.object.nom_banco 	[row] = ls_null
	this.object.nro_cuenta 	[row] = ls_null

	of_banco_prov()
	
elseif dwo.name = 'job' then
	
	select descripcion
		into :ls_desc
	from job
	where job = :data;
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Codigo de Job no existe')
		this.object.job 		[row] = ls_null
		this.object.desc_job [row] = ls_null
		return 1
	end if
	
	this.object.desc_job [row] = ls_desc
	
elseif dwo.name = 'cod_banco' then
	
	ls_proveedor = this.object.proveedor  [row]
	ls_moneda	 = this.object.cod_moneda [row]
	
	if ls_proveedor = '' or IsNull(ls_proveedor) then
		MessageBox('Aviso', 'Debes Ingresar un código de proveedor')
		this.SetColumn('proveedor')
		return 1
	end if
	
	if ls_moneda = '' or IsNull(ls_moneda) then
		MessageBox('Aviso', 'Debes Ingresar un código de moneda')
		this.SetColumn('cod_moneda')
		return 1
	end if

	select distinct a.nom_banco
		into :ls_desc
	from banco a,
		  prov_banco_cnta b
	where a.cod_banco = b.cod_banco
	  and a.cod_banco = :data
	  and b.proveedor = :ls_proveedor
	  and b.cod_moneda = :ls_moneda;
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Codigo de Banco no existe, no le corresponde al proveedor o no es de la moneda correcta')
		this.object.cod_banco [row] = ls_null
		this.object.nom_banco [row] = ls_null
		return 1
	end if
	
	this.object.nom_banco [row] = ls_desc
	
	of_nro_cnta_banco( data )

elseif dwo.name = 'nro_cuenta' then

	ls_proveedor = this.object.proveedor  [row]
	ls_moneda	 = this.object.cod_moneda [row]
	ls_banco		 = this.object.cod_banco  [row]
	
	if ls_proveedor = '' or IsNull(ls_proveedor) then
		MessageBox('Aviso', 'Debes Ingresar un código de proveedor')
		this.SetColumn('proveedor')
		return
	end if
	
	if ls_moneda = '' or IsNull(ls_moneda) then
		MessageBox('Aviso', 'Debes Ingresar un código de moneda')
		this.SetColumn('cod_moneda')
		return 
	end if

	if ls_banco = '' or IsNull(ls_banco) then
		MessageBox('Aviso', 'Debes Ingresar un código de banco')
		this.SetColumn('cod_banco')
		return 
	end if

	SELECT CNTA_BCO_PROV 
	  into :ls_desc
	  FROM prov_banco_cnta
	where cod_banco = :ls_banco
	  and proveedor = :ls_proveedor
	  and cod_moneda = :ls_moneda
	  and cnta_bco_prov = :data;
			  
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Nro de Cuenta de Banco no existe, no le corresponde al proveedor o no es de la moneda correcta')
		this.object.nro_cuenta [row] = ls_null
		return 1
	end if

elseif dwo.name = 'uo_dst_pago' then
	
	select nombre
		into :ls_desc
	from origen
	where cod_origen = :data
	  and flag_estado = '1';
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Codigo de Origen no existe o no esta activo')
		this.object.uo_dst_pago [row] = ls_null
		return 1
	end if
	
elseif dwo.name = 'item' then
	
	ls_proveedor = dw_master.object.proveedor [row]		
	IF Isnull(ls_proveedor) OR Trim(ls_proveedor)  = "" THEN
		Messagebox("Aviso","Debe Ingresar Codigo de Proveedor , Verifique!")
		Return 
	END IF
	
	li_item = Integer(data)
	
	// Solo Tomo la Direccion de facturacion
	SELECT TRIM(DIR_DIRECCION) || ' ' || TRIM(DIR_DEP_ESTADO) || ' ' || TRIM(DIR_DISTRITO)
		into :ls_desc
	FROM DIRECCIONES 
	WHERE CODIGO 	= :ls_proveedor 
	  and item 		= :li_item
	  and flag_uso = '1';
											
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Item de Direccion no existe o no es de facturacion' + string(li_item))
		SetNull(li_item)
		this.object.item 		[row] = li_item
		this.object.direccion[row] = ls_null
		return 1
	end if
	
	this.object.direccion [row] = ls_desc
	
elseif dwo.name = 'flag_importacion' then
	
	if data = '1' and dw_detail.Rowcount( ) > 0 then
		if MessageBox('Pregunta', 'Esta indicando que esta Orden de Compra es de importación ' &
			+ '¿Desea que el Impuesto en el detalle de la OC sea CERO?', Information!, &
			YesNo!, 2) = 2 then return
	end if
	
	for ll_j = 1 to dw_detail.RowCount( )
		dw_detail.object.impuesto [ll_j] = 0
		dw_detail.ii_update = 1
	next
	of_set_total_oc( )
end if


end event

type dw_detail from u_dw_abc within w_cm311_orden_compra
integer x = 503
integer y = 1284
integer width = 3333
integer height = 620
integer taborder = 70
string dataobject = "d_abc_o_compra_det_211"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2

is_dwform = 'tabular'	// tabular, form (default)
end event

event itemerror;call super::itemerror;RETURN 1
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event clicked;call super::clicked;Long ll_row
Decimal ld_precio_unit


idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc(idw_1)

IF row = 0 THEN RETURN

IF is_action <> 'new' then
	
	ll_row = this.GetRow()
END IF
end event

event doubleclicked;// Abre ventana de ayuda 
String 	ls_name, ls_codigo, ls_data, ls_sql, ls_cod_art, &
			ls_mensaje, ls_referencia, ls_almacen, ls_proveedor, &
			ls_moneda, ls_string, ls_evaluate
Date 		ld_fecdig, ld_fec_reg
Double 	ln_monto
Integer 	ln_mes, li_position
boolean 	lb_ret
Decimal	ldc_precio, ldc_descuento, ldc_impuesto, &
			ldc_porc_dscto, ldc_porc_imp, ldc_cant_proyect


str_parametros sl_param
str_seleccionar lstr_seleccionar
Datawindow ldw

//if this.Describe( lower(dwo.name) + ".Protect") = '1' then return

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	 
	 do while(f_instr("'", ls_string, li_position) > 0 )
		li_position = f_instr("'", ls_string, li_position)
		ls_string = replace(ls_string, li_position, 1, "~~'")
		li_position += 3
	loop
	
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

if row <= 0 then return

this.AcceptText()
ls_name = lower(dwo.name)

// Ayuda de busqueda para articulos
IF ls_name = 'cod_art' then
	OpenWithParm (w_pop_articulos, parent)
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' then
		this.object.cod_art	[row] = sl_param.field_ret[1]
		this.object.desc_art	[row] = sl_param.field_ret[2]
		this.object.und		[row] = sl_param.field_ret[3]	
		this.object.dias_reposicion [row] = Long(sl_param.field_ret[5])
		this.object.dias_rep_import [row] = Long(sl_param.field_ret[6])
		
		of_set_articulo(sl_param.field_ret[1])
		
		this.ii_update = 1
 	END IF
elseif ls_name = 'oper_sec' then	
	
	ls_cod_art = this.object.cod_Art[row]
	if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then
		MessageBox('Aviso', 'Debe indicar un codigo de articulo')
		return
	end if
	
	/*ejecuta procedimiento*/
	DECLARE PB_USF_CMP_TT_OPER_SEC_ART PROCEDURE FOR USF_CMP_TT_OPER_SEC_ART
	(:ls_cod_art);
	EXECUTE PB_USF_CMP_TT_OPER_SEC_ART ;

	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje =SQLCA.SQLErrTExt
		ROLLBACK;
		MessageBox("SQL error", ls_mensaje)
		Return
	END IF


	CLOSE PB_USF_CMP_TT_OPER_SEC_ART ;	
	/**/
	
	
	sl_param.dw1 = "d_list_amp_opersec_grid"   // "d_sel_cnta_presup_saldos"  //
	sl_param.titulo = "Mov Pendientes x oper_sec"
	sl_param.field_ret_i[1] = 4 	// Oper_Sec
	sl_param.field_ret_i[2] = 6	// Nro_orden
	sl_param.field_ret_i[3] = 7	// Tipo_doc (OT)
	sl_param.field_ret_i[4] = 5	// Origen_ot
	sl_param.field_ret_i[5] = 8	// Cant_pendiente
	sl_param.field_ret_i[6] = 10	// Almacen

	
	OpenWithParm( w_lista, sl_param)
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then			
		this.object.oper_sec		[row] = sl_param.field_ret[1]			
		this.object.referencia	[row] = sl_param.field_ret[2]			
		this.object.tipo_ref		[row] = sl_param.field_ret[3]
		this.object.origen_ref	[row] = sl_param.field_ret[4]			
		this.object.almacen		[row] = sl_param.field_ret[6]			
		this.object.cant_pendiente	[row] = dec(sl_param.field_ret[5])
		this.object.cant_proyect	[row] = dec(sl_param.field_ret[5])
		this.SetColumn('precio_unit')
		
		this.ii_update = 1		// activa flag de modificado
	END IF
	
	
elseif ls_name = 'cnta_prsp' then
	
	if is_flag_oc_prsp = '0' then return
	
	sl_param.dw1 = "d_dddw_cntas_presupuestal"   // "d_sel_cnta_presup_saldos"  //
	sl_param.titulo = "Cuentas Presupuestales"
	sl_param.field_ret_i[1] = 1
	sl_param.tipo = 'CP'  // indicador para que ejecute proc. 
	sl_param.string1 = This.object.cencos[row]
	sl_param.int1 = MONTH( DATE( this.object.fec_proyect[row]))
	sl_param.int2 = YEAR( DATE( this.object.fec_proyect[row]))
	
	OpenWithParm( w_lista, sl_param)
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then			
		this.object.cnta_prsp	[row] = sl_param.field_ret[1]			
		this.ii_update = 1		// activa flag de modificado
		is_cnta_prsp = sl_param.field_ret[1]
	END IF
	
elseif ls_name = 'fec_proyect' then
	
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	this.ii_update = 1
	
elseif ls_name = 'cencos' then	
	
	if is_flag_oc_prsp = '0' then return
	
	sl_param.dw1 = "d_dddw_cencos"   //"d_sel_cencos_segun_presup"   //
	sl_param.titulo = "Centro de Costos"
	sl_param.field_ret_i[1] = 1
	sl_param.tipo = '1I'
	sl_param.int1 = YEAR( DATE(this.object.fec_proyect[row]))

	OpenWithParm( w_lista, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then		
		this.object.cencos[row] = sl_param.field_ret[1]
		this.ii_update = 1
		is_cencos = sl_param.field_ret[1]
	END IF
	
elseif ls_name = 'almacen' then

	ls_sql = "SELECT almacen AS CODIGO_almacen, " &
		    + "DESC_almacen AS DESCRIPCION_almacen " &
			 + "FROM almacen " &
			 + "where flag_estado = '1'"
				 
	lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
	if ls_codigo <> '' then
		this.object.almacen			[row] = ls_codigo
		this.ii_update = 1
	end if
	
end if

//Obtengo el ultimo precio de Compra por Proveedor y Almacen
if ls_name = "cod_art" or ls_name = "almacen" then
	// Obtengo los datos necesarios
	ls_almacen 	= this.object.almacen	[row]
	ls_moneda 	= this.object.cod_moneda[row]
	ls_cod_art 	= this.object.cod_art	[row]
	ldc_cant_proyect = Dec(this.object.cant_proyect[row])
	ls_proveedor= dw_master.object.proveedor[dw_master.GetRow()] 
	ld_fec_reg	= Date(dw_master.object.fec_registro[dw_master.GetRow()])

	// Obtengo el precio pactado
	//create or replace function usf_cmp_prec_compra_artic(
	// 	asi_cod_art         in articulo.cod_art%TYPE,
	// 	asi_proveedor       in proveedor.proveedor%type,
	// 	adi_fec_reg         in orden_compra.fec_registro%type,
	// 	asi_almacen         in almacen.almacen%TYPE,
	//		asi_moneda          in moneda.cod_moneda%type
	//) return number is
		
	SELECT usf_cmp_prec_compra_artic(:ls_cod_art, :ls_proveedor, :ld_fec_reg, 
		:ls_almacen, :ls_moneda)
		INTO :ldc_precio
	FROM dual ;
	
	If IsNull(ldc_precio) then ldc_precio = 0
	
	this.object.precio_unit [row] = ldc_precio
	
	ldc_porc_dscto = Dec(this.object.porc_dscto		[row])
	If IsNull(ldc_porc_dscto) then
		ldc_porc_dscto = 0
		this.object.porc_dscto [row] = 0
	end if

	ldc_porc_imp 	= Dec(this.object.porc_impuesto  [row])
	If IsNull(ldc_porc_imp) then
		ldc_porc_imp = 0
		this.object.porc_impuesto [row] = 0
	end if

	ldc_descuento 	= ldc_precio * ldc_porc_dscto / 100
	if ldc_descuento > ldc_precio then
		MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
		this.object.porc_dscto	[row] = 0
		this.object.decuento		[row] = 0
		return 1
	end if

	ldc_impuesto = (ldc_precio - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100

	this.object.decuento		[row] = ldc_descuento
	this.object.impuesto		[row] = ldc_impuesto

	of_set_total_oc()		

end if
end event

event ue_insert_pre;call super::ue_insert_pre;// Si se adiciona con referencia, desactiva el ingreso de codigo articulo
Decimal 	ld_tasa
string 	ls_importacion

if dw_master.GetRow() = 0 then return

ls_importacion = dw_master.object.flag_importacion[dw_master.GetRow()]

if rb_programa.checked = true or rb_ot.checked = true then	
	this.object.cod_art.background.color = RGB(192,192,192)
	this.object.cod_art.protect = 1
else
	this.object.cod_art.background.color = RGB(255,255,255)			
	this.object.cod_art.protect = 0
end if	

// solo para articulos, le asigna la misma fecha
this.object.fec_proyect			[al_row] = Date(f_fecha_actual(1))
this.object.tipo_doc				[al_row] = is_doc_oc
this.object.cod_origen			[al_row] = dw_master.object.cod_origen[dw_master.GetRow()]
this.object.cod_moneda			[al_row] = dw_master.object.cod_moneda[dw_master.getrow()]
this.object.flag_crg_inm_prsp	[al_row] = is_flag_oc_prsp

if is_flag_aut_oc = '1' then
	this.object.flag_estado			[al_row] = '3'  // Pendiente de Aprobación
else
	this.object.flag_estado			[al_row] = '1'  // Aprobado
end if

this.object.fec_registro		[al_row] = f_fecha_actual(1)
this.object.cencos				[al_row] = is_cencos_oc
this.object.cnta_prsp			[al_row] = is_cnta_prsp_oc
this.object.porc_dscto			[al_row] = 0
this.object.decuento				[al_row] = 0
this.object.precio_unit			[al_row] = 0
this.object.flag_modificacion [al_row] = '1'
this.object.tipo_mov				[al_row] = is_oper_ing_oc
this.object.dias_reposicion	[al_row] = 0
this.object.dias_rep_import	[al_row] = 0
this.object.cant_procesada		[al_row] = 0
this.object.cant_facturada		[al_row] = 0
this.object.flag_cantidad		[al_row] = '1'
this.object.flag_precio			[al_row] = '1'
this.object.flag_importacion	[al_row] = ls_importacion
this.object.cod_usr				[al_row] = gnvo_app.is_user
this.object.flag_almacen		[al_row] = '1'

if dw_master.GetRow() = 0 then return
// Segun el flag de Importacion coloco o no el IGV
if ls_importacion = '0' then
	// Segun tipo busca tasa
	Select tasa_impuesto 
		into :ld_tasa 
	from impuestos_tipo 
	where tipo_impuesto = :is_cod_igv;
		
	this.object.porc_impuesto[al_row] = ld_tasa
else
	this.object.porc_impuesto[al_row] = 0
end if
this.object.impuesto [al_row] = 0
	
in_precio = 0.00
in_cantidad = 0.00

this.SetColumn( 'cod_art')
of_set_modify()


end event

event itemchanged;call super::itemchanged;Long   		ll_count, ln_mes, ll_null, ll_nro_mov
String 		ls_desc_art, ls_und, ls_date, ls_null, ls_cod_origen, ls_almacen, &
				ls_moneda, ls_referencia, ls_cod_art,ls_proveedor
date   		ld_fecdig, ld_null,ld_fec_proyect_db, ld_fecha, ld_fec_reg
Decimal	 	ldc_cant_proyect, ldc_cant_pendiente, &
				ldc_cant_procesada, ldc_precio_unit, ldc_descuento, &
				ldc_porc_imp, ldc_impuesto, ldc_porc_dscto, &
				ldc_precio_con_igv, ldc_null
Integer 		li_dias_rep, li_dias_rep_imp

this.AcceptText()

Setnull(ls_null)
SetNull(ll_null)
Setnull(ld_null)
SetNull(ldc_null)

ld_fecdig = date(this.object.fec_proyect[row])	// Fecha digitada

IF dwo.name = "cod_art" then
	// Busca codigo
	if f_articulo_inventariable( data ) <> 1 then 
		this.object.cod_art	[row] = ls_null
		this.object.desc_art	[row] = ls_null
		this.object.und		[row] = ls_null
		
		return 1
	end if

	Select desc_art, und, NVL(dias_reposicion, 0), NVL(dias_rep_import, 0)
		into :ls_desc_art, :ls_und, :li_dias_rep, :li_dias_rep_imp
	from articulo 
	Where cod_Art = :data;
	
	this.object.desc_Art	[row] = ls_desc_art
	this.object.und		[row] = ls_und		
	this.object.dias_reposicion[row] = li_dias_rep
	this.object.dias_rep_import[row] = li_dias_rep_imp
	of_set_articulo(data)

elseif dwo.name = 'cencos' then
	
	ls_date = String(this.object.fec_proyect[row], 'dd/mm/yyyy')
	if TRIM( ls_date ) = '' THEN
		Messagebox( "Atencion", 'Ingrese fecha')
		this.Setcolumn( 'fec_proyect')
		this.object.cencos[row] = ls_null
		return 1
	End if
	
	Select Count(cencos) 
		into :ll_count 
	from centros_costo 
	where cencos = :data;
	
	if ll_count = 0 then
		Messagebox( "Error", "Centro de costo no existe")
		this.object.cencos[row] = ls_null
		This.SetColumn("cencos")
		this.Setfocus()
		Return 1
	end if
	
	is_cencos = data

elseif dwo.name = 'cnta_prsp' then
	
	Select Count(cnta_prsp) 
		into :ll_count 
	from presupuesto_cuenta 
	where cnta_prsp = :data;
	
	if ll_count = 0 then
		Messagebox( "Error", "Cuenta presupuestal no existe")
		this.object.cnta_prsp[row] = ls_null
		this.SetColumn('cnta_prsp')
		this.SetFocus()
		Return 1
	end if
	is_cnta_prsp = data	
	
elseif dwo.name = 'almacen' then
	
	Select Count(*) 
		into :ll_count 
	from almacen 
	where almacen = :data
	  and flag_estado = '1';
	
	if ll_count = 0 then
		Messagebox( "Error", "Almacen no existe o no esta activo")
		this.object.almacen[row] = ls_null
		this.SetColumn('almacen')
		this.SetFocus()
		Return 1
	end if

elseif dwo.name = 'cant_proyect' then
	
	ldc_cant_proyect  = Dec(data)
	
	if ldc_cant_proyect <= 0 or IsNull(ldc_cant_proyect) then
		this.object.cant_proyect[row] = ll_null
		Messagebox( "Atencion", "Cantidad no permitida")
		return 1
	end if
	
	ldc_cant_pendiente = Dec(this.object.cant_pendiente[row])
	If IsNull(ldc_cant_pendiente) then ldc_cant_pendiente = 0
	
	if ldc_cant_pendiente > 0 then
		if ldc_cant_proyect > ldc_cant_pendiente then
			MessageBox('Error', 'Cantidad Proyectada no puede ser mayor que la requerida')
			this.object.cant_proyect [row] = ldc_cant_pendiente			
			return 1
		end if
	end if
	
	ldc_precio_unit  = Dec(this.object.precio_unit[row])

	if IsNull(ldc_precio_unit) or ldc_precio_unit <= 0 then
		MessageBox('Aviso', 'El precio unitario no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = ldc_null
		this.object.impuesto		[row] = ldc_null
		this.SetColumn('precio_unit')
		return 1
	end if
	
	ldc_descuento 	= this.object.decuento [row]
	if ldc_descuento > ldc_precio_unit then
		MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
		this.object.porc_dscto	[row] = ldc_null
		this.object.decuento		[row] = ldc_null
		return 1
	end if

	ldc_porc_imp = this.object.porc_impuesto [row]
	If IsNull(ldc_porc_imp) then
		ldc_porc_dscto = 0
		this.object.porc_impuesto [row] = 0
	end if
	
	ldc_impuesto = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100
	
	this.object.impuesto		[row] = ldc_impuesto

	of_precio_unit( row )
	
	of_set_total_oc( )
	
elseif dwo.name = 'precio_con_igv' then
	
	if IsNull(data) or Dec(Data) <= 0 then
		MessageBox('Aviso', 'El precio unitario no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = ldc_null
		this.object.impuesto		[row] = ldc_null
		this.object.precio_unit	[row] = ldc_null
		this.SetColumn('precio_con_igv')
		return 1
	end if

	of_precio_con_igv( row )
	
	of_set_total_oc()

		
elseif dwo.name = 'precio_unit' then
	
	ldc_precio_unit  = Dec(data)

	if IsNull(ldc_precio_unit) or ldc_precio_unit < 0 then
		MessageBox('Aviso', 'El precio unitario no puede ser negativo o estar en blanco')
		this.object.decuento		[row] = ldc_null
		this.object.impuesto		[row] = ldc_null
		this.SetColumn('precio_unit')
		return 1
	end if
	
	ldc_cant_proyect  = Dec(this.object.cant_proyect[row])
	
	if ldc_cant_proyect <= 0 or IsNull(ldc_cant_proyect) then
		this.object.cant_proyect[row] = ll_null
		Messagebox( "Atencion", "Cantidad no permitida")
		return 1
	end if

	ldc_descuento 	= this.object.decuento [row]
	if ldc_descuento > ldc_precio_unit then
		MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
		this.object.porc_dscto	[row] = ldc_null
		this.object.decuento		[row] = ldc_null
		return 1
	end if

	ldc_porc_imp = this.object.porc_impuesto [row]
	If IsNull(ldc_porc_imp) then
		ldc_porc_dscto = 0
		this.object.porc_impuesto [row] = 0
	end if
	
	ldc_impuesto = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100
	
	this.object.impuesto		[row] = ldc_impuesto

	of_precio_unit( row )
	
	of_set_total_oc()

elseif dwo.name = 'porc_dscto' then
	ldc_precio_unit  = Dec(this.object.precio_unit[row])

	if IsNull(ldc_precio_unit) or ldc_precio_unit <= 0 then
		MessageBox('Aviso', 'El precio unitario no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = ldc_null
		this.object.impuesto		[row] = ldc_null
		this.SetColumn('precio_unit')
		return 1
	end if
	
	ldc_porc_dscto = Dec(data)
	If IsNull(ldc_porc_dscto) then
		ldc_porc_dscto = 0
		this.object.porc_dscto [row] = 0
	end if
	
	ldc_descuento 	= ldc_precio_unit * ldc_porc_dscto / 100
	if ldc_descuento > ldc_precio_unit then
		MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
		this.object.porc_dscto	[row] = ldc_null
		this.object.decuento		[row] = ldc_null
		this.SetColumn('porc_dscto')
		return 1
	end if
	
	this.object.decuento		[row] = ldc_descuento
	
	ldc_porc_imp = this.object.porc_impuesto [row]
	If IsNull(ldc_porc_imp) then
		ldc_porc_dscto = 0
		this.object.porc_impuesto [row] = 0
	end if
	
	ldc_impuesto = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100
	
	this.object.impuesto		[row] = ldc_impuesto

	of_precio_unit( row )
	
	of_set_total_oc()

	
elseif dwo.name = 'decuento' then
	ldc_precio_unit = Dec(this.object.precio_unit[row])

	if IsNull(ldc_precio_unit) or Dec(ldc_precio_unit) <= 0 then
		MessageBox('Aviso', 'El precio unit no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = ldc_null
		this.object.impuesto		[row] = ldc_null
		this.SetColumn('precio_unit')
		return 1
	end if
	
	ldc_descuento = Dec(data)
	if ldc_descuento > Dec(this.object.precio_unit[row]) then
		MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
		this.object.porc_dscto	[row] = 0
		this.object.decuento		[row] = ldc_null
		this.SetColumn('decuento')
		return 1
	end if
	this.object.porc_dscto[row] = round(ldc_descuento/ldc_precio_unit * 100,2)
	
	ldc_porc_imp = this.object.porc_impuesto [row]
	If IsNull(ldc_porc_imp) then
		ldc_porc_dscto = 0
		this.object.porc_impuesto [row] = 0
	end if
	
	ldc_impuesto = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100
	
	this.object.impuesto		[row] = ldc_impuesto

	of_precio_unit( row )
	
	of_set_total_oc()

elseif dwo.name = 'porc_impuesto' then
	
	ldc_precio_unit  = Dec(this.object.precio_unit [row])
	ldc_cant_proyect = Dec(this.object.cant_proyect[row])
	ldc_descuento	  = Dec(this.object.decuento	  [row])
	
	if IsNull(ldc_precio_unit) or Dec(ldc_precio_unit) <= 0 then
		MessageBox('Aviso', 'El precio unit no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = ldc_null
		this.object.impuesto		[row] = ldc_null
		this.SetColumn('precio_unit')
		return 1
	end if
	
	ldc_porc_imp = Dec(data)
	If IsNull(ldc_porc_imp) then
		ldc_porc_dscto = 0
		this.object.porc_impuesto [row] = 0
	end if
	
	ldc_impuesto = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100
	
	this.object.impuesto		[row] = ldc_impuesto
	
	of_precio_unit( row )
	
	of_set_total_oc()
	
elseif dwo.name = 'impuesto' then
	ldc_precio_unit  = Dec(this.object.precio_unit[row])
	ldc_cant_proyect = Dec(this.object.cant_proyect[row])
	ldc_descuento	  = Dec(this.object.decuento	  [row])
	ldc_impuesto	  = Dec(data)
	
	if IsNull(ldc_precio_unit) or Dec(ldc_precio_unit) <= 0 then
		MessageBox('Aviso', 'El precio unit no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = ldc_null
		this.object.impuesto		[row] = ldc_null
		this.SetColumn('precio_unit')
		return 1
	end if
	
	ldc_porc_imp = ldc_impuesto / ((ldc_precio_unit - ldc_descuento) * ldc_cant_proyect) * 100
	this.object.porc_impuesto [row] = ldc_porc_imp
	
	of_precio_unit( row )
	
	of_set_total_oc()
	
end if

//Obtengo el ultimo precio de Compra por Proveedor y Almacen
if dwo.name = "cod_art" or dwo.name = "almacen" then
	
	// Obtengo los datos necesarios
	ls_almacen 	= this.object.almacen	[row]
	ls_moneda 	= this.object.cod_moneda[row]
	ls_cod_art 	= this.object.cod_art	[row]
	ldc_cant_proyect = Dec(this.object.cant_proyect[row])
	ls_proveedor= dw_master.object.proveedor[dw_master.GetRow()] 
	ld_fec_reg	= Date(dw_master.object.fec_registro[dw_master.GetRow()])

	// Obtengo el precio pactado
	//create or replace function usf_cmp_prec_compra_artic(
	// 	asi_cod_art         in articulo.cod_art%TYPE,
	// 	asi_proveedor       in proveedor.proveedor%type,
	// 	adi_fec_reg         in orden_compra.fec_registro%type,
	// 	asi_almacen         in almacen.almacen%TYPE,
	//		asi_moneda          in moneda.cod_moneda%type
	//) return number is
		
	SELECT usf_cmp_prec_compra_artic(:ls_cod_art, :ls_proveedor, :ld_fec_reg, 
		:ls_almacen, :ls_moneda)
		INTO :ldc_precio_unit
	FROM dual ;
	
	If IsNull(ldc_precio_unit) then ldc_precio_unit = 0
	
	this.object.precio_unit [row] = ldc_precio_unit

	ldc_porc_dscto = Dec(this.object.porc_dscto		[row])
	If IsNull(ldc_porc_dscto) then
		ldc_porc_dscto = 0
		this.object.porc_dscto [row] = 0
	end if

	ldc_porc_imp 	= Dec(this.object.porc_impuesto  [row])
	If IsNull(ldc_porc_imp) then
		ldc_porc_imp = 0
		this.object.porc_impuesto [row] = 0
	end if

	ldc_descuento 	= ldc_precio_unit * ldc_porc_dscto / 100
	if ldc_descuento > ldc_precio_unit then
		MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
		this.object.porc_dscto	[row] = 0
		this.object.decuento		[row] = 0
		return 1
	end if

	ldc_impuesto = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100

	of_precio_unit( row )
	
	of_set_total_oc()		

end if



end event

event getfocus;IF of_verifica_datos() = 0 THEN // Verifica que datos se han ingresado en cabecera
   dw_master.setfocus()
END IF
end event

event type long dwnenter();call super::dwnenter;String ls_1, ls_2

// evalua que existe la fecha proyectada
ls_1 = '01/01/1900'
ls_2 = STRING( date(this.object.fec_proyect[this.getrow()]), 'dd/mm/yyyy') 
if ls_1 = ls_2 then
	messagebox( "Atencion", "Ingrese fecha proyectada")
	this.setcolumn( 'fec_proyect')
	return 1
end if

return 1
end event

event dberror;// OVERRIDE
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
	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
      	INTO :ls_name
      FROM ALL_CONSTRAINTS
      WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;
				 
		ROLLBACK;
		
      Messagebox('Error FK','Registro Tiene Movimientos en Tabla: '+ls_name)
      Return 1	
		
	case 20000 to 29999
		// Encontrar el error
		
		lpos = POS( sqlerrtext, ':')
		ll_error = LONG( MID( sqlerrtext, 5, 5) )			
		
		ls_cad = MID( sqlerrtext, lpos + 2, len( sqlerrtext) - lpos )			
		lpos2 = pos( ls_cad, 'ORA')
		ls_cad = MID( sqlerrtext, lpos + 2, lpos2 - 1)
		ROLLBACK;
		Messagebox( "Error", ls_cad, stopsign!)
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

event type long ue_delete();call super::ue_delete;of_set_total_oc()  // Muestra total de o/compra
return 1
end event

type em_vn from editmask within w_cm311_orden_compra
integer x = 3461
integer y = 2172
integer width = 503
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type em_imp from editmask within w_cm311_orden_compra
integer x = 2610
integer y = 2176
integer width = 503
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type em_dcto from editmask within w_cm311_orden_compra
integer x = 1774
integer y = 2176
integer width = 503
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type em_vb from editmask within w_cm311_orden_compra
integer x = 923
integer y = 2176
integer width = 503
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_cm311_orden_compra
integer x = 1458
integer y = 2192
integer width = 306
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15780518
string text = "Descuento:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cm311_orden_compra
integer x = 3141
integer y = 2192
integer width = 306
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15780518
string text = "Valor Neto:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm311_orden_compra
integer x = 2299
integer y = 2192
integer width = 302
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15780518
string text = "Impuesto:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cm311_orden_compra
integer x = 576
integer y = 2188
integer width = 315
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15780518
string text = "Valor Bruto:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nro from u_sle_codigo within w_cm311_orden_compra
integer x = 1362
integer y = 160
integer width = 471
integer height = 92
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;cb_1.Triggerevent( clicked!)
end event

