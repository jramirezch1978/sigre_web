$PBExportHeader$w_cm311_orden_compra.srw
forward
global type w_cm311_orden_compra from w_abc
end type
type rb_proformas from radiobutton within w_cm311_orden_compra
end type
type pb_masivo from picturebutton within w_cm311_orden_compra
end type
type st_5 from statictext within w_cm311_orden_compra
end type
type em_imp2 from editmask within w_cm311_orden_compra
end type
type sle_nro from u_sle_codigo within w_cm311_orden_compra
end type
type rb_catalogo from radiobutton within w_cm311_orden_compra
end type
type cb_1 from commandbutton within w_cm311_orden_compra
end type
type st_nro from statictext within w_cm311_orden_compra
end type
type em_vn from editmask within w_cm311_orden_compra
end type
type em_imp1 from editmask within w_cm311_orden_compra
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
end forward

global type w_cm311_orden_compra from w_abc
integer width = 4201
integer height = 4732
string title = "Orden de Compras [CM311]"
string menuname = "m_mtto_imp_mail"
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
event ue_cancelar ( )
event ue_mail ( )
event ue_cerrar ( )
rb_proformas rb_proformas
pb_masivo pb_masivo
st_5 st_5
em_imp2 em_imp2
sle_nro sle_nro
rb_catalogo rb_catalogo
cb_1 cb_1
st_nro st_nro
em_vn em_vn
em_imp1 em_imp1
em_dcto em_dcto
em_vb em_vb
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
pb_1 pb_1
rb_ot rb_ot
rb_programa rb_programa
gb_1 gb_1
dw_master dw_master
dw_detail dw_detail
end type
global w_cm311_orden_compra w_cm311_orden_compra

type variables
String 	is_ref, is_doc_oc, is_salir, is_doc_prog, is_cencos, is_cnta_prsp, &
			is_soles, is_cod_igv, is_oper_ing_oc, is_doc_sc, is_oper_cons_int, &
			is_cencos_mat, is_cnta_prsp_mat, is_doc_ot, is_FLAG_RESTRIC_COMP_OC, &
			is_flag_aut_oc, is_flag_cntrl_fondos, is_doc_aoc, is_flag_mod_fec_oc, &
			is_cod_percepcion, is_centro_benef, is_FLAG_CARGA_OC_PRESUP
			
REAL 		in_tipo_cambio, in_precio = 0.00, in_cantidad = 0.00 
string	is_backColor
DateTime	id_fecha_proc

n_cst_utilitario	invo_util

end variables

forward prototypes
public subroutine of_email ()
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
public function integer of_precio_con_igv (long al_row)
public function integer of_fondo_oc (string as_origen)
public function integer of_nro_cnta_banco (string as_banco)
public function integer of_banco_prov ()
public function integer of_update_precio_unit (long al_row)
public function integer of_update_imp1 (long al_row)
public function integer of_update_imp2 (long al_row)
public function integer of_precio_total (long al_row)
public subroutine of_retrieve (string as_nro)
end prototypes

event ue_anular;Integer 	li_j
decimal 	ln_cant_procesada
string	ls_nro_oc
Long 		ll_count


if of_comprador() = 0 then return

// Verifica que exista el detalle
IF dw_master.rowcount() = 0 then return
if dw_detail.rowcount() = 0 then return

//Valido si la OC ha sido generada a partir de las GRMP
ls_nro_oc = dw_master.object.nro_oc[dw_master.GetRow()]

select count(*)
	into :ll_count
from ap_guia_recepcion
where nro_oc = :ls_nro_oc;

if ll_count > 0 then
	MessageBox('Aviso', 'No se puede anular la OC porque ha sido generado desde Aprovisionamiento ~r~n' &
			+ 'Para anularlo proceda a ingresar al módulo de APROVISIONAMIENTO, ' &
			+ 'en el menu Procesos->Orden de Compra->Anular')
	return
end if

if MessageBox('Aviso', 'Deseas anular la Orden de Compra', Information!, YesNo!, 2) = 2 then return

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
	dw_detail.object.oper_sec 		[li_j] = gnvo_app.is_null
	dw_detail.object.org_amp_ref	[li_j] = gnvo_app.is_null
	dw_detail.object.nro_amp_ref	[li_j] = gnvo_app.il_null
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

sle_nro.text = ''
sle_nro.SetFocus()
idw_1 = dw_master
dw_master.il_row = 0

is_Action = ''
of_set_status_doc(dw_master)
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

public function integer of_set_status_doc (datawindow idw);///*
//  Funcion que verifica el status del documento
//*/
////this.changemenu( m_mtto_imp_mail)
//
//Int li_estado
//
//// Activa todas las opciones
//m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles( is_niveles, 'I')  // true
//m_master.m_file.m_basedatos.m_eliminar.enabled = f_niveles( is_niveles, 'E')  //true
//m_master.m_file.m_basedatos.m_modificar.enabled 	= f_niveles( is_niveles, 'M') //true
//m_master.m_file.m_basedatos.m_anular.enabled 		= f_niveles( is_niveles, 'A') //true
//m_master.m_file.m_basedatos.m_abrirlista.enabled 	= true
//m_master.m_file.m_basedatos.m_cerrar.enabled 		= f_niveles( is_niveles, 'C') //true
//m_master.m_file.m_printer.m_print1.enabled 			= true
//
//if dw_master.getrow() = 0 then return 0
//
//if is_Action = 'new' then
//	// Activa desactiva opcion de modificacion, eliminacion	
//	m_master.m_file.m_basedatos.m_eliminar.enabled = false
//	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
//	m_master.m_file.m_basedatos.m_anular.enabled 		= false
//	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
//	m_master.m_file.m_printer.m_print1.enabled 			= false	
//	m_master.m_file.m_basedatos.m_insertar.enabled = false
//	m_master.m_file.m_basedatos.m_email.enabled 	= false
//	m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
//
//	if idw = dw_detail then
//		m_master.m_file.m_basedatos.m_eliminar.enabled = f_niveles(is_niveles, 'E')
//		if rb_catalogo.checked = true then
//	   	m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles(is_niveles, 'I')
//		else	
//			m_master.m_file.m_basedatos.m_insertar.enabled = false
//		end if
//	END IF
//	
//elseif is_Action = 'open' then
//	
//	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])
//	if idw = dw_detail then		
//		if rb_catalogo.checked = true and li_estado = 1 then
//   		m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles(is_niveles, 'I')
//		else	
//			m_master.m_file.m_basedatos.m_insertar.enabled = false
//		end if
//	END IF
//	
//	Choose case li_estado
//		case 0		// Anulado			
//			m_master.m_file.m_basedatos.m_eliminar.enabled = false
//			m_master.m_file.m_basedatos.m_modificar.enabled 	= false
//			m_master.m_file.m_basedatos.m_anular.enabled 		= false
//			m_master.m_file.m_basedatos.m_email.enabled 	= false
//			m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
//		CASE 1   // Activo
//			if is_flag_aut_oc = '1' then
//				m_master.m_file.m_basedatos.m_eliminar.enabled = false
//				if idw_1 = dw_detail then
//					m_master.m_file.m_basedatos.m_modificar.enabled 	= f_niveles( is_niveles, 'M') //true
//				else
//					m_master.m_file.m_basedatos.m_modificar.enabled 	= false
//				end if
//			end if
//		CASE 2   // Cerrado
//			m_master.m_file.m_basedatos.m_eliminar.enabled = false
//			if idw_1 = dw_master then
//				m_master.m_file.m_basedatos.m_modificar.enabled 	= false
//			else
//				m_master.m_file.m_basedatos.m_modificar.enabled 	= f_niveles( is_niveles, 'M')  // true
//			end if
//			m_master.m_file.m_basedatos.m_anular.enabled 		= false
//			m_master.m_file.m_basedatos.m_cerrar.enabled 		= false			
//			
//		CASE 3   // Pendiente VoBo
//			if is_flag_aut_oc = '1' then
//				m_master.m_file.m_basedatos.m_cerrar.enabled 		= false			
//			end if
//
//	end CHOOSE
//	
//elseif is_Action = 'edit' then
//	m_master.m_file.m_basedatos.m_eliminar.enabled = false
//	m_master.m_file.m_basedatos.m_modificar.enabled 	= true
//	m_master.m_file.m_basedatos.m_anular.enabled 		= false
//	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
//	m_master.m_file.m_printer.m_print1.enabled 			= false	
//	m_master.m_file.m_basedatos.m_insertar.enabled = false
//	m_master.m_file.m_basedatos.m_email.enabled 	= false	
//	m_master.m_file.m_basedatos.m_cerrar.enabled 		= false			
//	
//elseif is_Action = 'anu' OR is_Action = 'del' then
//	m_master.m_file.m_basedatos.m_eliminar.enabled = false
//	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
//	m_master.m_file.m_basedatos.m_anular.enabled 		= false
//	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
//	m_master.m_file.m_printer.m_print1.enabled 			= false	
//	m_master.m_file.m_basedatos.m_insertar.enabled = false
//	m_master.m_file.m_basedatos.m_email.enabled 	= false	
//	m_master.m_file.m_basedatos.m_cerrar.enabled 		= false			
//end if
//
return 1
end function

public function integer of_set_numera ();// Numera documento
Long 		ll_long, ll_ult_nro, ll_j, ll_count
string	ls_mensaje, ls_nro_oc
Date		ld_fec_compra

try 
	if dw_master.getRow() = 0 then return 1
	
	ls_nro_oc = dw_master.object.nro_oc[dw_master.getrow()]
	
	if is_action = 'new' or IsNull(ls_nro_oc) or Trim(ls_nro_oc) = ''   then
		
		if gnvo_app.of_get_parametro( "COMPRA_NUM_PC_DIARIO", "0") = "0" then
			Select ult_nro 
				into :ll_ult_nro 
			from num_ord_comp 
			where origen = :gs_origen for update;
			
			IF SQLCA.SQLCode = 100 then
				Insert into NUM_ORD_COMP (origen, ult_nro)
					values( :gs_origen, 1);
				
				IF SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Aviso', "Error al INSERTAR en tabla num_ord_comp. Mensaje: " + ls_mensaje, StopSign!)
					return 0
				end if
				
				ll_ult_nro = 1
			end if
			
		
			ls_nro_oc = TRIM(gs_origen) + invo_util.lpad(String(ll_ult_nro), 8, '0')
			
			select count(*)
			  into :ll_count
			  from orden_compra oc
			 where oc.nro_oc = :ls_nro_oc;
			 
			
			DO WHILE ll_count > 0
				ll_ult_nro ++
				ls_nro_oc = TRIM(gs_origen) + invo_util.lpad(String(ll_ult_nro), 8, '0')
				
				select count(*)
				  into :ll_count
				  from orden_compra oc
				 where oc.nro_oc = :ls_nro_oc;
				 
			LOOP
		
		
			dw_master.object.nro_oc[dw_master.getrow()] = ls_nro_oc
			
			// Incrementa contador
			Update num_ord_comp 
				set ult_nro = :ll_ult_nro + 1 
			 where origen = :gs_origen;
			
			IF SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', "Error al ACTUALIZAR en tabla num_ord_comp. Mensaje: " + ls_mensaje, StopSign!)
				return 0
			end if
		
		else
			//Se cambia al numerador de la Orden de Compra diario
			
			//1.- Obtengo le fecha de compra de la Orden de compra
			
			
			Select ult_nro 
				into :ll_ult_nro 
			from num_ord_comp 
			where origen = :gs_origen for update;
			
			IF SQLCA.SQLCode = 100 then
				Insert into NUM_ORD_COMP (origen, ult_nro)
					values( :gs_origen, 1);
				
				IF SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Aviso', "Error al INSERTAR en tabla num_ord_comp. Mensaje: " + ls_mensaje, StopSign!)
					return 0
				end if
				
				ll_ult_nro = 1
			end if
			
		
			ls_nro_oc = TRIM(gs_origen) + invo_util.lpad(String(ll_ult_nro), 8, '0')
			
			select count(*)
			  into :ll_count
			  from orden_compra oc
			 where oc.nro_oc = :ls_nro_oc;
			 
			
			DO WHILE ll_count > 0
				ll_ult_nro ++
				ls_nro_oc = TRIM(gs_origen) + invo_util.lpad(String(ll_ult_nro), 8, '0')
				
				select count(*)
				  into :ll_count
				  from orden_compra oc
				 where oc.nro_oc = :ls_nro_oc;
				 
			LOOP
		
		
			dw_master.object.nro_oc[dw_master.getrow()] = ls_nro_oc
			
			// Incrementa contador
			Update num_ord_comp 
				set ult_nro = :ll_ult_nro + 1 
			 where origen = :gs_origen;
			
			IF SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', "Error al ACTUALIZAR en tabla num_ord_comp. Mensaje: " + ls_mensaje, StopSign!)
				return 0
			end if
		
		end if
		
		
			
	end if
	
	// Asigna numero a detalle
	for ll_j = 1 to dw_detail.RowCount()	
		dw_detail.object.nro_doc[ll_j] = ls_nro_oc	
	next
	
	return 1

catch ( Exception ex )
	gnvo_app.of_Catch_exception( ex, "Exception al generar el numerador de la Orden de Compra")
	return 0
	
finally
	/*statementBlock*/
end try

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

try 

	is_flag_aut_oc = gnvo_app.of_get_parametro('COMPRA_APROBACION_OC', '0')

catch ( Exception ex)

	gnvo_app.of_catch_exception(ex, 'Error al cargar parametros para compras')

end try


// busca tipos de movimiento definidos
SELECT 	tipo_doc_prog_cmp, cencos_almacen, cnta_prsp_mat, doc_oc, cod_soles,
			oper_ing_oc, cod_igv, doc_sc, oper_cons_interno, doc_ot,
			NVL(FLAG_RESTRIC_COMP_OC, '0'), 
			NVL(flag_cntrl_fondos, '0'), NVL(flag_mod_fec_oc, '0'), 
			cod_percepcion, NVL(FLAG_CARGA_OC_PRESUP, '0')
	INTO 	:is_doc_prog, :is_cencos_mat, :is_cnta_prsp_mat, :is_doc_oc, :is_soles,
			:is_oper_ing_oc, :is_cod_igv, :is_doc_sc, :is_oper_cons_int, :is_doc_ot,
			:is_FLAG_RESTRIC_COMP_OC,
			:is_flag_cntrl_fondos, :is_flag_mod_fec_oc, :is_cod_percepcion, :is_FLAG_CARGA_OC_PRESUP
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

if ISNULL( is_cencos_mat ) or TRIM( is_cencos_mat ) = '' then
	Messagebox("Error", "Defina Centro de Costo de Bolsa de Compras en logparam")
	return 0
end if

if ISNULL( is_cnta_prsp_mat ) or TRIM( is_cnta_prsp_mat ) = '' then
	Messagebox("Error", "Defina Cuenta Presupuestal de Bolsa de Compras en logparam")
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

if ISNULL( is_cod_percepcion ) or TRIM( is_cod_percepcion ) = '' then
	Messagebox("Error", "Defina impuesto de percepción en logparam")
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

if of_fondo_oc(gs_origen) = 0 then 
	return 0
end if



return 1
end function

public subroutine of_set_total_oc ();// Halla sub total
Decimal 	ldc_sub_total, ldc_importe, ldc_tot_dct, ldc_tot_imp1, ldc_tot_imp2, &
			ldc_total_oc, ldc_descuento, ldc_impuesto1, ldc_impuesto2
Int 		li_j

if dw_master.GetRow() = 0 then return

ldc_sub_total 	= 0
ldc_impuesto1 	= 0
ldc_impuesto2 	= 0
ldc_tot_dct 	= 0
ldc_tot_imp1 	= 0
ldc_tot_imp2 	= 0
dw_detail.AcceptText()

For li_j = 1 to dw_detail.Rowcount()
	
	ldc_importe = dw_detail.object.cant_proyect[li_j] * (dw_detail.object.Precio_unit[li_j])
		
	ldc_sub_total += ldc_importe	
	
	if dw_detail.object.decuento[li_j] > 0 then
		ldc_descuento = dw_detail.object.cant_proyect[li_j] * dw_detail.object.decuento[li_j]
		ldc_tot_dct += ldc_descuento
	else
		dw_detail.object.decuento[li_j] = 0
		ldc_descuento = 0
	end if
	
	if dw_detail.object.impuesto1[li_j] > 0 then
		ldc_tot_imp1 	+= dw_detail.object.impuesto1[li_j]
	else
		dw_detail.object.impuesto1[li_j] = 0
	end if	

	if dw_detail.object.impuesto2[li_j] > 0 then
		ldc_tot_imp2 	+= dw_detail.object.impuesto2[li_j]
	else
		dw_detail.object.impuesto2[li_j] = 0
	end if	
	
Next

ldc_total_oc	= ldc_sub_total - ldc_tot_dct + ldc_tot_imp1 + ldc_tot_imp2

em_vb.text 		= String(ldc_sub_total)
em_dcto.text 	= String(ldc_tot_dct)
em_imp1.text 	= String(ROUND(ldc_tot_imp1,2))
em_imp2.text 	= String(ldc_tot_imp2)
em_vn.text 		= String(ldc_total_oc) 

dw_master.object.monto_total[dw_master.getrow()] = ldc_total_oc
dw_master.ii_update = 1

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
				:gs_user);
			
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

public function boolean of_set_articulo (string as_cod_art);string 	ls_almacen, ls_cod_clase, ls_proveedor, ls_moneda, &
			ls_flag_percepcion, ls_uo_dst_pago
date		ld_fec_reg
decimal	ldc_precio, ldc_saldo, ldc_tasa
Long		ll_row			

// Setea las variables x defecto de acuerdo al codigo de articulo
// x ejemplo el almacen tácito y el precio en articulo_precio_pactado

if dw_master.GetRow() = 0 then return false

ls_proveedor 	= dw_master.object.proveedor	[dw_master.GetRow()]
ls_moneda	 	= dw_master.object.cod_moneda	[dw_master.GetRow()]
ls_uo_dst_pago	= dw_master.object.uo_dst_pago[dw_master.GetRow()]

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
select cod_clase, nvl(flag_percepcion, '0') 
	into :ls_cod_clase, :ls_flag_percepcion
from articulo
where cod_art = :as_cod_art;

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'Codigo de Articulo ' + as_cod_art + ' no existe. Por favor verifique!', StopSign!)
	return false
end if

if IsNull(ls_cod_clase) or ls_cod_clase = '' then
	MessageBox('Aviso', 'Articulo ' + as_cod_art + ' no esta enlazado a ninguna clase. Por favor verifique!', StopSign!)
	return false
end if

//Selecciono el almacen correspondiente
if IsNull(ls_uo_dst_pago) or trim(ls_uo_dst_pago) = '' then
	
	select almacen
	  into :ls_almacen
	from almacen_tacito
	where cod_origen = :gs_origen
	  and cod_clase  = :ls_cod_clase;
else
	
	select almacen
	  into :ls_almacen
	from almacen_tacito
	where cod_origen = :ls_uo_dst_pago
	  and cod_clase  = :ls_cod_clase;
end if

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

// Si tiene el flag de percepcion inserto el impuesto de percepcion
if ls_flag_percepcion = '1' then
	select tasa_impuesto
		into :ldc_tasa
	from impuestos_tipo
	where tipo_impuesto = :is_cod_percepcion;
	
	dw_detail.object.tipo_impuesto2 [ll_row] = is_cod_percepcion
	dw_detail.object.tasa_impuesto2 [ll_row] = ldc_tasa
end if


of_update_precio_unit( ll_row )
of_update_imp1( ll_row )
of_update_imp2( ll_row )

of_set_total_oc( )

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
	ls_mensaje = "PROCEDURE USP_ALM_PREC_X_MOVPROY: " &
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

//Si esta activo el flag de autorizacion solo debe permitir cambiar el IGV nada mas
if is_flag_aut_oc = '1' and dw_master.object.flag_estado[dw_master.GetRow()] = '1' then
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.object.cod_art.protect = 1
	dw_detail.object.cant_proyect.protect = 1
	dw_detail.object.precio_unit.protect = 1
	dw_detail.object.decuento.protect = 1
	dw_detail.object.porc_dscto.protect = 1
	dw_detail.object.cencos.protect = 1
	dw_detail.object.cnta_prsp.protect = 1
	dw_detail.object.almacen.protect = 1
end if
end subroutine

public function integer of_comprador ();Long ll_count

Select count(*)
	into :ll_count
from comprador
where comprador = :gs_user
  and flag_estado = '1';

if ll_count = 0 then
	Messagebox("Error", "Usuario " + gs_user + " no esta definidido como comprador " &
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

public function integer of_precio_con_igv (long al_row);Decimal	ldc_cant_proyect, ldc_precio_con_igv, ldc_precio_unit, &
			ldc_impuesto1, ldc_impuesto2, ldc_tasa_impuesto1, &
			ldc_tasa_impuesto2, ldc_descuento, ldc_porc_dscto
String	ls_impuesto1, ls_impuesto2

ldc_precio_con_igv = Dec(dw_detail.object.precio_con_igv[al_row])

ldc_cant_proyect = Dec(dw_detail.object.cant_proyect[al_row])

if ldc_cant_proyect <= 0 or IsNull(ldc_cant_proyect) then
	MessageBox('Aviso', 'Debe Ingresar primero una cantidad a comprar')
	dw_detail.object.precio_con_igv	[al_row] = 0
	dw_detail.object.decuento			[al_row] = 0
	dw_detail.object.impuesto1			[al_row] = 0
	dw_detail.object.impuesto2			[al_row] = 0
	dw_detail.object.precio_unit		[al_row] = 0
	dw_detail.object.SetColumn('cant_proyect')
	return 0
end if

ldc_porc_dscto = Dec(dw_detail.object.porc_dscto[al_row])
If IsNull(ldc_porc_dscto) then
	ldc_porc_dscto = 0
	dw_detail.object.porc_dscto [al_row] = 0
end if
	
ldc_tasa_impuesto1 	= Dec(dw_detail.object.tasa_impuesto1  [al_row])
ls_impuesto1 			= dw_detail.object.tipo_impuesto1  [al_row]
If IsNull(ldc_tasa_impuesto1) then
	ldc_tasa_impuesto1 = 0
	dw_detail.object.tasa_impuesto1 [al_row] = 0
end if

ldc_tasa_impuesto2 	= Dec(dw_detail.object.tasa_impuesto2  [al_row])
ls_impuesto2 			= dw_detail.object.tipo_impuesto2  [al_row]
If IsNull(ldc_tasa_impuesto2) then
	ldc_tasa_impuesto2 = 0
	dw_detail.object.tasa_impuesto2 [al_row] = 0
end if

//Primero obtengo el precio sin los impuestos
if ls_impuesto2 = is_cod_percepcion then
	ldc_precio_unit = ldc_precio_con_igv / ((1 + ldc_tasa_impuesto1/100) * (1 + ldc_tasa_impuesto2/100))
else
	ldc_precio_unit = ldc_precio_con_igv / (1 + (ldc_tasa_impuesto1 + ldc_tasa_impuesto2)/100)
end if

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

//Luego el impuesto 1
of_update_imp1( al_row )

//Luego el impuesto 2
of_update_imp2( al_row )
return 1
end function

public function integer of_fondo_oc (string as_origen);// Obtengo el fondo de compras de acuerdo al origen

select cencos_oc, cnta_prsp_oc, cen_bef_gen_oc
	into :is_cencos_mat, :is_cnta_prsp_mat, :is_centro_benef
from origen
where cod_origen = :as_origen;

IF SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No existen datos para el ORIGEN ' + as_origen)
	return 0
end if

if IsNull(is_cencos_mat) or is_cencos_mat = '' then
	MessageBox('Aviso', 'No ha especificado el centro de costo de la Bolsa de compras para el ORIGEN ' + as_origen)
	return 0
end if

if IsNull(is_cnta_prsp_mat) or is_cnta_prsp_mat = '' then
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

public function integer of_update_precio_unit (long al_row);Decimal 	ldc_precio, ldc_porc_dscto, ldc_descuento

ldc_precio = Dec(dw_detail.object.precio_unit [al_row])
if IsNull(ldc_precio) or ldc_precio = 0 then
	dw_detail.object.decuento 	[al_row] = 0
	dw_detail.object.impuesto1 [al_row] = 0
	dw_detail.object.impuesto2 [al_row] = 0
	return 0
end if

ldc_porc_dscto = Dec(dw_detail.object.porc_dscto [al_row])
If IsNull(ldc_porc_dscto) then
	ldc_porc_dscto = 0
	dw_detail.object.porc_dscto [al_row] = 0
end if

ldc_descuento 	= ldc_precio * ldc_porc_dscto / 100
if ldc_descuento > ldc_precio then
	MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
	dw_detail.object.porc_dscto	[al_row] = 0
	dw_detail.object.decuento		[al_row] = 0
	return 1
end if

dw_detail.object.decuento		[al_row] = ldc_descuento

of_update_imp1( al_row )
of_update_imp2( al_row )

return 1

end function

public function integer of_update_imp1 (long al_row);//Esta funcion actualiza el importe asi 
Decimal ldc_tasa, ldc_impuesto, ldc_cantidad, ldc_precio, ldc_descuento

ldc_precio 		= Dec(dw_detail.object.precio_unit		[al_row])
ldc_cantidad 	= Dec(dw_detail.object.cant_proyect		[al_row])
ldc_tasa			= Dec(dw_detail.object.tasa_impuesto1	[al_row])
ldc_descuento  = Dec(dw_detail.object.decuento			[al_row])

if IsNull(ldc_tasa) then
	ldc_tasa = 0
	dw_detail.object.tasa_impuesto1[al_row] = 0
end if

ldc_impuesto = (ldc_precio - ldc_descuento) * ldc_cantidad * ldc_tasa / 100

dw_detail.object.impuesto1 [al_row] = ldc_impuesto

return 1
end function

public function integer of_update_imp2 (long al_row);//Esta funcion actualiza el importe asi 
Decimal 	ldc_tasa, ldc_impuesto1, ldc_cantidad, ldc_precio, ldc_descuento, &
			ldc_impuesto2
String 	ls_impuesto1, ls_impuesto2			

ldc_precio 		= Dec(dw_detail.object.precio_unit		[al_row])
ldc_cantidad 	= Dec(dw_detail.object.cant_proyect		[al_row])
ldc_tasa			= Dec(dw_detail.object.tasa_impuesto2	[al_row])
ldc_descuento  = Dec(dw_detail.object.decuento			[al_row])
ldc_impuesto1  = Dec(dw_detail.object.impuesto1			[al_row])
ls_impuesto1 	= dw_detail.object.tipo_impuesto1		[al_row]
ls_impuesto2 	= dw_detail.object.tipo_impuesto2		[al_row]

if IsNull(ldc_tasa) then
	ldc_tasa = 0
	dw_detail.object.tasa_impuesto2[al_row] = 0
end if

if ls_impuesto2 = is_cod_percepcion and ls_impuesto1 = is_cod_igv then
	ldc_impuesto2 = ((ldc_precio - ldc_descuento) * ldc_cantidad + ldc_impuesto1) * ldc_tasa / 100
else
	ldc_impuesto2 = (ldc_precio - ldc_descuento) * ldc_cantidad * ldc_tasa / 100
end if


dw_detail.object.impuesto2 [al_row] = ldc_impuesto2

return 1
end function

public function integer of_precio_total (long al_row);Decimal	ldc_cant_proyect, ldc_precio_total, ldc_precio_unit, &
			ldc_descuento, ldc_porc_dscto, ldc_impuesto1, ldc_impuesto2
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

dw_detail.object.decuento		[al_row] = ldc_descuento

if ldc_descuento <> 0 and ldc_porc_dscto = 0 then
	ldc_porc_dscto = ldc_descuento / ldc_precio_unit * 100
	dw_detail.object.porc_dscto	[al_row] = ldc_porc_dscto
end if

ldc_impuesto1 = dec(dw_detail.object.impuesto1[al_row])
ldc_impuesto2 = dec(dw_detail.object.impuesto2[al_row])

ldc_precio_total = ldc_precio_unit - ldc_descuento + (ldc_impuesto1 + ldc_impuesto2) / ldc_cant_proyect

dw_detail.object.precio_con_igv[al_row] = round(ldc_precio_total,2)



return 1
end function

public subroutine of_retrieve (string as_nro);String 	ls_origen, ls_nro, ls_imp
Long 		ll_row

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then	

	ls_origen = dw_master.object.cod_origen		[dw_master.getrow()]
	ls_nro 	 = dw_master.object.nro_oc				[dw_master.getrow()]
	ls_imp	 = dw_master.object.flag_importacion[dw_master.getrow()]
	
	dw_detail.retrieve(is_doc_oc, ls_nro, ls_imp)
	of_set_total_oc()	
	
	of_set_status_doc( dw_master )
	of_fondo_oc(ls_origen)
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

event ue_open_pre;call super::ue_open_pre;try 
	if of_get_param() = 0 then 
		is_salir = 'S'
		post event closequery()   
		return
	end if
	
	IF gnvo_app.of_get_parametro("SHOW_NRO_SERIE_MOTOR_OC", "0") = "0" then
		dw_detail.dataObject = 'd_abc_o_compra_det_211'
	else
		dw_detail.dataObject = 'd_abc_orden_compra_det_serie_motor_tbl'
	end if
	
	dw_master.SetTransObject(sqlca)
	dw_detail.SetTransObject(sqlca)
	
	idw_1 = dw_master              			// asignar dw corriente
	dw_detail.BorderStyle = StyleRaised! 	// indicar dw_detail como no activado
	dw_master.of_protect()         			// bloquear modificaciones 
	dw_detail.of_protect()
	
	ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
	// ii_help = 101           // help topic	
	
	dw_master.object.p_logo.filename = gs_logo
	
	if is_flag_aut_oc = '0' then
		dw_master.object.b_aprueba.visible = false
		dw_master.object.b_desaprueba.visible = false
	end if
	
	is_backColor = string(dw_master.object.fec_registro.background.color)
	
	//gnvo_app.logistica.of_act_monto_facturado( )
	//gnvo_app.logistica.of_act_cant_procesada( )


catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error en evento ue_open_pre")
end try


end event

on w_cm311_orden_compra.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_imp_mail" then this.MenuID = create m_mtto_imp_mail
this.rb_proformas=create rb_proformas
this.pb_masivo=create pb_masivo
this.st_5=create st_5
this.em_imp2=create em_imp2
this.sle_nro=create sle_nro
this.rb_catalogo=create rb_catalogo
this.cb_1=create cb_1
this.st_nro=create st_nro
this.em_vn=create em_vn
this.em_imp1=create em_imp1
this.em_dcto=create em_dcto
this.em_vb=create em_vb
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.pb_1=create pb_1
this.rb_ot=create rb_ot
this.rb_programa=create rb_programa
this.gb_1=create gb_1
this.dw_master=create dw_master
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_proformas
this.Control[iCurrent+2]=this.pb_masivo
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.em_imp2
this.Control[iCurrent+5]=this.sle_nro
this.Control[iCurrent+6]=this.rb_catalogo
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.st_nro
this.Control[iCurrent+9]=this.em_vn
this.Control[iCurrent+10]=this.em_imp1
this.Control[iCurrent+11]=this.em_dcto
this.Control[iCurrent+12]=this.em_vb
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.st_2
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.pb_1
this.Control[iCurrent+18]=this.rb_ot
this.Control[iCurrent+19]=this.rb_programa
this.Control[iCurrent+20]=this.gb_1
this.Control[iCurrent+21]=this.dw_master
this.Control[iCurrent+22]=this.dw_detail
end on

on w_cm311_orden_compra.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_proformas)
destroy(this.pb_masivo)
destroy(this.st_5)
destroy(this.em_imp2)
destroy(this.sle_nro)
destroy(this.rb_catalogo)
destroy(this.cb_1)
destroy(this.st_nro)
destroy(this.em_vn)
destroy(this.em_imp1)
destroy(this.em_dcto)
destroy(this.em_vb)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.rb_ot)
destroy(this.rb_programa)
destroy(this.gb_1)
destroy(this.dw_master)
destroy(this.dw_detail)
end on

event ue_insert;call super::ue_insert;Long  ll_row, ll_mov_atrazados
n_cst_diaz_retrazo lnvo_amp_retr

if of_comprador() = 0 then return

if idw_1 = dw_master then 		
	
	if is_action = 'new' then
		if MessageBox('Informacion', "Hay una cabecera de Orden de Compra que ha ingresado, " &
											+ "desea ingresar otra Orden de Compta, si lo hace, " &
											+ "perderá cualquier cambio que haya realizado hasta ahora. "&
											+ "¿Desea continuar insertando una nueva cabecera de " &
											+ "Orden de compra?", Information!, YesNo!, 2) = 2 then return
	end if

	// Verifica tipo de cambio
	id_fecha_proc = gnvo_app.of_fecha_actual()
	in_tipo_cambio = gnvo_app.of_get_tipo_cambio(Date(id_fecha_proc))
	
	if in_tipo_cambio = 0 THEN return
	dw_master.reset()
	dw_detail.reset()
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	is_action = 'new'

elseif idw_1 = dw_detail then 
	
	IF dw_master.getrow() = 0 then 
		MessageBox('Error', "No esta permitido ingresar detalle en documento si no tiene cabecera, por favor verificar!", StopSign!)
		return
	end if
	
	IF dw_master.object.flag_estado [1] = '2' then 
		MessageBox('Error', "No se puede ingresar mas articulos en la Orden de Compra, porque esta CERRADA, por favor verificar!", StopSign!)
		return
	end if

	IF dw_master.object.flag_estado [1] = '0' then 
		MessageBox('Error', "No se puede ingresar mas articulos en la Orden de Compra, porque esta ANULADA, por favor verificar!", StopSign!)
		return
	end if
	
	if is_flag_aut_oc = '1' then
		IF dw_master.object.flag_estado [1] = '1' then 
			MessageBox('Error', "No puede insertar mas articulos en la Orden de Compra, porque esta APROBADA, por favor verificar!", StopSign!)
			return
		end if
	end if
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

lstr_rep.string1 = dw_master.object.cod_origen	[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_oc		[dw_master.getrow()]
lstr_rep.b_envioEmail = false

lstr_rep.d_datos[1] = dec(em_vb.text)
lstr_rep.d_datos[2] = dec(em_dcto.text)
lstr_rep.d_datos[3] = dec(em_imp1.text)
lstr_rep.d_datos[4] = dec(em_imp2.text)
lstr_rep.d_datos[5] = dec(em_vn.text)

OpenSheetWithParm(lw_1, lstr_rep, w_main, 2, Layered!)
end event

event ue_update_pre;string 	ls_moneda
long		ll_i

of_set_total_oc()

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail ) <> true then	return

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

// Grabo el Log de Maestro
IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lb_ok = FALSE
		ls_mens1 = "Error en Cabecera de la Orden de Compra"
		ls_mens2 = "Se ha procedido al rollback"	
	END IF
END IF

IF dw_detail.ii_update = 1 AND lb_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lb_ok = FALSE
		ls_mens1 = "Error en Grabacion Detalle de la Orden de Compra"
		ls_mens2 = "Se ha procedido al rollback"		
	END IF
END IF

IF ib_log and lb_ok THEN
	lb_ok = dw_master.of_save_log()
	lb_ok = dw_detail.of_save_log()
	
END IF

IF lb_ok THEN
	
	if of_oc_importacion() = 0 then return
	if of_validar_oc(dw_master.object.nro_oc[dw_master.GetRow()]) = false then return
	
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.ib_edit = false
	dw_detail.ib_edit = false

	dw_master.ii_protect = 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	dw_detail.ResetUpdate()
	
	is_action = 'open'
	of_retrieve(dw_master.object.nro_oc[dw_master.GetRow()])
	
	of_set_status_doc( dw_master)
	
	f_mensaje('Cambios guardados satisfactoriamente','')
	
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

if is_flag_aut_oc = '1' then
	IF  ls_flag_estado = '1' then 
		MessageBox('Error', "No puede editar la Orden de Compra, porque esta APROBADA, por favor verificar!", StopSign!)
		return
	end if
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

event resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 140

//gb_1.width  = newwidth  - gb_1.x - 15

// Controles

em_vb.y    = newheight - 110
em_dcto.y  = newheight - 110
em_imp1.y  = newheight - 110
em_imp2.y  = newheight - 110
em_vn.y    = newheight - 110
st_1.y     = newheight - 100
st_2.y     = newheight - 100
st_3.y     = newheight - 100
st_4.y     = newheight - 100
st_5.y     = newheight - 100
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
Long  	ll_row, ll_item, ll_nro_amp, ll_count
String	ls_org_amp, ls_flag_estado

if of_comprador() = 0 then return

IF dw_master.rowcount() = 0 then return

if idw_1 = dw_master then 
	Messagebox( "Operacion no válida", "No esta permitido eliminar la cabecera de la Orden de Compra, solo esta permitido eliminar el detalle, si desea dejar sin efecto la Orden de Compra debe anularla")	
	return 
end if

if dw_detail.rowcount() = 1 then
	messagebox( "Operacion no válida", "No se permite dejar el documento vacio")
	return 
end if

ls_flag_estado = dw_master.object.flag_estado [1]

if is_flag_aut_oc = '1' then
	IF  ls_flag_estado = '1' then 
		MessageBox('Error', "No puede eliminar ningun item de la Orden de Compra, porque esta APROBADA, por favor verificar!", StopSign!)
		return
	end if
end if

//Valido si el item tiene amarre con alguna Orden de Servicio (Gastos Vinculados con la compra)
if dw_detail.GetRow() > 0 then
	ls_org_amp = dw_detail.object.cod_origen		[dw_detail.GetRow()]
	ll_nro_amp = Long(dw_detail.object.nro_mov	[dw_detail.GetRow()])
	
	select count(*)
		into :ll_count
	from oc_det_os_det 
	where org_amp = :ls_org_amp
	  and nro_amp = :ll_nro_amp;
	
	if ll_count > 0 then
		MessageBox('Aviso', 'No es posible eliminar el item seleccionado de la Orden de Compra, ya que tiene amarrados ' + string(ll_count) + ' Ordenes de Servicio, debe quitar primero dicho amarre para eliminar el item de este Documento')
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

of_Set_Status_doc(dw_detail)

end event

event ue_mail_send;call super::ue_mail_send;//Overridinf
IF dw_master.rowcount() = 0 then 
	MessageBox('Error', 'No hay Documento para enviar por correo, '&
			+ "por favor cargue una Orden de compra previamente")
	return
end if

IF dw_master.object.flag_estado[dw_master.getrow()] = '3' THEN 
	MessageBox('Aviso','Documento no aprobado, por favor verifique')
	Return
END IF 

if dw_master.ii_update = 1 or dw_detail.ii_update = 1 then
	MessageBox('Aviso','Existen cambios pendientes, por favor grabe primero')
	Return
end if

w_cm311_orden_compra_frm lw_1

str_parametros lstr_rep

lstr_rep.string1 = dw_master.object.cod_origen	[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_oc		[dw_master.getrow()]
lstr_rep.b_envioEmail = true

lstr_rep.d_datos[1] = dec(em_vb.text)
lstr_rep.d_datos[2] = dec(em_dcto.text)
lstr_rep.d_datos[3] = dec(em_imp1.text)
lstr_rep.d_datos[4] = dec(em_imp2.text)
lstr_rep.d_datos[5] = dec(em_vn.text)

OpenSheetWithParm(lw_1, lstr_rep, w_main, 2, Layered!)
end event

event ue_retrieve_list;// Abre ventana pop
this.event ue_update_request()

str_parametros sl_param

gnvo_app.logistica.of_act_monto_facturado( )

sl_param.dw1 = "d_sel_orden_compra_tbl"   //"d_dddw_orden_compra_tbl"  // //
sl_param.titulo = "Ordenes de compra"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	
	//se actualizan los montos y datos
	gnvo_app.logistica.of_act_monto_facturado( sl_param.field_ret[2] )
	gnvo_app.logistica.of_act_cant_procesada( sl_param.field_ret[2] )
	
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[2])
END IF
end event

type rb_proformas from radiobutton within w_cm311_orden_compra
integer x = 46
integer y = 1116
integer width = 512
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proformas de Venta"
end type

event clicked;// Activa input's

if is_action = 'new' or is_action = 'edit' then
	pb_1.enabled = true
end if

pb_masivo.enabled = false
of_set_status_doc( idw_1)
end event

type pb_masivo from picturebutton within w_cm311_orden_compra
integer x = 599
integer y = 1032
integer width = 128
integer height = 100
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "ArrangeTables5!"
string disabledname = "ArrangeTables5!"
boolean map3dcolors = true
string powertiptext = "Ingreso masivo de articulos"
end type

event clicked;// Asigna valores a structura
str_parametros	lstr_param, lstr_datos
Long				ll_row
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
lstr_param.dw_d = dw_detail
lstr_param.dw_m = dw_master

OpenWithParm( w_abc_ingreso_resumido, lstr_param )

if ISNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

lstr_param = Message.PowerObjectParm

if lstr_param.b_return then
	for ll_row = 1 to dw_detail.RowCount()
		//Impuesto 1
		of_update_imp1( ll_row )
		
		//Impuesto 2
		of_update_imp2( ll_row )
	
		of_precio_total( ll_row )
	next
	
	of_set_total_oc( )
	
	of_set_modify()
end if
	


end event

type st_5 from statictext within w_cm311_orden_compra
integer x = 2400
integer y = 2292
integer width = 302
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Impuesto2:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_imp2 from editmask within w_cm311_orden_compra
integer x = 2720
integer y = 2280
integer width = 453
integer height = 84
integer taborder = 80
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

type sle_nro from u_sle_codigo within w_cm311_orden_compra
integer x = 251
integer width = 471
integer height = 92
integer taborder = 20
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;cb_1.Triggerevent( clicked!)
end event

type rb_catalogo from radiobutton within w_cm311_orden_compra
integer x = 46
integer y = 1204
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
pb_masivo.enabled = true
of_set_status_doc( idw_1)
end event

type cb_1 from commandbutton within w_cm311_orden_compra
integer x = 754
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

event clicked;if trim(sle_nro.text) = '' then return

EVENT ue_update_request()

update orden_compra oc
   set oc.monto_facturado = (select round(sum(amp.cant_facturada * amp.precio_unit + NVL(amp.impuesto / amp.cant_proyect * amp.cant_facturada,0) + NVL(amp.impuesto2 / amp.cant_proyect * amp.cant_facturada,0)),2) from articulo_mov_proy amp where amp.nro_doc = oc.nro_oc and amp.tipo_doc = (select doc_oc from logparam where reckey = '1') and amp.flag_estado <> '0')
where oc.monto_facturado <> (select round(sum(amp.cant_facturada * amp.precio_unit + NVL(amp.impuesto / amp.cant_proyect * amp.cant_facturada,0) + NVL(amp.impuesto2 / amp.cant_proyect * amp.cant_facturada,0)),2) from articulo_mov_proy amp where amp.nro_doc = oc.nro_oc and amp.tipo_doc = (select doc_oc from logparam where reckey = '1') and amp.flag_estado <> '0')
  and oc.flag_estado <> '0';
 
 commit;
 
of_retrieve(sle_nro.text)
end event

type st_nro from statictext within w_cm311_orden_compra
integer y = 12
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
long backcolor = 67108864
string text = "Numero:"
boolean focusrectangle = false
end type

type em_vn from editmask within w_cm311_orden_compra
integer x = 3515
integer y = 2280
integer width = 453
integer height = 84
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

type em_imp1 from editmask within w_cm311_orden_compra
integer x = 1925
integer y = 2276
integer width = 453
integer height = 84
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
integer x = 1129
integer y = 2276
integer width = 453
integer height = 84
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
integer x = 334
integer y = 2276
integer width = 453
integer height = 84
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
integer x = 814
integer y = 2292
integer width = 306
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Descuento:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cm311_orden_compra
integer x = 3191
integer y = 2292
integer width = 306
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valor Neto:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm311_orden_compra
integer x = 1609
integer y = 2292
integer width = 302
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Impuesto:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cm311_orden_compra
integer x = 9
integer y = 2292
integer width = 315
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valor Bruto:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_cm311_orden_compra
integer x = 599
integer y = 928
integer width = 128
integer height = 100
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "C:\SIGRE\resources\BMP\file_open.bmp"
string disabledname = "C:\SIGRE\resources\Bmp\file_close.bmp"
boolean map3dcolors = true
string powertiptext = "Referencia de documentos"
end type

event clicked;// Asigna valores a structura
str_parametros	lstr_param, lstr_datos
string			ls_nro_doc = ''

if is_action = 'open' then   // Cuando adiciona
	// Verifica tipo de cambio
	in_tipo_cambio = f_get_tipo_cambio( DATE(dw_master.object.fec_registro[dw_master.getrow()]))
	if in_tipo_cambio = 0 THEN return
end if

if of_verifica_datos() = 0 then return // Verifica que datos se han ingresado en cabecera

// Verifica que ha indicado un tipo
if rb_programa.checked = false and rb_ot.checked = false and &
	rb_catalogo.checked = false and rb_proformas.checked = false then 
	Messagebox( "Atencion", "Seleccione de donde extraer los datos, por favor verifique!", StopSign!)
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
	lstr_param.string6		= gs_user
	lstr_param.flag_cntrl_fondos	= is_flag_cntrl_fondos
	lstr_param.tipo			= 'PROG_COMPRAS'
	lstr_param.w1				= parent
	
	if is_FLAG_RESTRIC_COMP_OC = '1' then
		lstr_param.opcion 		= 13	
	else
		lstr_param.opcion 		= 2	
	end if
	
	OpenWithParm( w_abc_seleccion_md, lstr_param)

	
elseIF rb_ot.checked = true then  	// Ordenes de Compras a Partir de OT's
	
	lstr_param.tipo = ''
	
	select min(fec_proyect), max(fec_proyect)
		into :lstr_param.fecha1, :lstr_param.fecha2
	from articulo_mov_proy amp
	where amp.tipo_doc = :gnvo_app.is_doc_ot
	  and amp.flag_estado = '1';
	
	//SetNull(lstr_param.fecha1)
	//SetNull(lstr_param.fecha2)
	
	OpenWithParm( w_abc_datos_ot, lstr_param )
	
	if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return
	
	lstr_param = Message.PowerObjectParm
	if lstr_param.titulo = 'n' then return
	
	lstr_param.dw_master 				= "d_list_orden_trabajo_grd"
	lstr_param.dw1       				= "d_list_articulo_mov_proy_x_ot_grd"	
	lstr_param.titulo 					= "Ordenes de Trabajo pendientes"
	lstr_param.dw_m 						= dw_master
	lstr_param.dw_d 						= dw_detail
	lstr_param.tipo_doc					= is_doc_ot
	lstr_param.w1							= parent
	lstr_param.opcion 					= 12
	lstr_param.tipo						= 'NRO_DOC'
	lstr_param.oper_cons_interno 		= is_oper_cons_int
	lstr_param.flag_cntrl_fondos 		= is_flag_cntrl_fondos
	lstr_param.FLAG_CARGA_OC_PRESUP 	= is_FLAG_CARGA_OC_PRESUP

	OpenWithParm( w_abc_seleccion_md, lstr_param)

elseIF rb_proformas.checked = true then  	// Ordenes de Compras a Partir de OT's
	
	lstr_param.dw_master 				= "d_list_proforma_diario_tbl"
	lstr_param.dw1       				= "d_list_proforma_diario_det_tbl"	
	lstr_param.titulo 					= "Proformas de Venta pendientes"
	lstr_param.dw_m 						= dw_master
	lstr_param.dw_d 						= dw_detail
	lstr_param.w1							= parent
	lstr_param.opcion 					= 21
	lstr_param.tipo						= ''

	OpenWithParm( w_abc_seleccion_md, lstr_param)	
	
end if

of_set_modify()
end event

type rb_ot from radiobutton within w_cm311_orden_compra
integer x = 46
integer y = 1028
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

pb_masivo.enabled = false
of_set_status_doc( idw_1)
end event

type rb_programa from radiobutton within w_cm311_orden_compra
integer x = 46
integer y = 940
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

pb_masivo.enabled = false

of_set_status_doc( idw_1)
end event

type gb_1 from groupbox within w_cm311_orden_compra
integer x = 18
integer y = 884
integer width = 727
integer height = 408
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
integer y = 112
integer width = 3968
integer height = 1188
integer taborder = 50
string dataobject = "d_abc_o_compra_cab_211"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cat_art, &
			ls_cod_art, ls_proveedor, ls_moneda, ls_banco, ls_direccion, ls_nom_rep
Long		ll_count, ll_item		
str_parametros sl_param

choose case lower(as_columna)
		
	case "proveedor"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor, " &
				  + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) AS ruc_proveedor " &
				  + "FROM proveedor p " &
				  + "where p.flag_Estado = '1' " &
				  + "  and p.flag_clie_prov in ('1', '2') " &
				  + "  and p.tipo_doc_ident in ('6', '0') "&
				  + "  and decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) is not null "
				  
				 
	
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			
			//Por defecto tomo el ultimo lugar de compra
			select lugar_entrega
			  into :ls_direccion
			  from orden_compra
			 where proveedor = :ls_proveedor
			 order by fec_registro desc;
			
			this.object.lugar_entrega	[al_row] = ls_direccion
			
			//Obtengo el primer representante
			select nom_rep
				into :ls_nom_rep
			from representante 
			where proveedor = :ls_proveedor;
			
			this.object.nom_vendedor [al_row] = ls_nom_rep
			
			//Obtengo la direccion por defecto
			SELECt count(*)
				into :ll_count
			FROM DIRECCIONES D 
			WHERE D.CODIGO = :ls_codigo
			  AND D.FLAG_USO in ('1', '3');
			
			if ll_count = 1 then
				SELECT D.ITEM, pkg_logistica.of_get_direccion(d.codigo, d.item)
					into :ll_item, :ls_direccion
				FROM DIRECCIONES D 
				WHERE D.CODIGO = :ls_codigo
				  AND D.FLAG_USO in ('1', '3');
				
				this.object.item		[al_row] = ll_item
				this.object.direccion[al_row] = ls_direccion
				
			elseif ll_count > 1 then
				
				MessageBox('Aviso', 'El proveedor ' + ls_codigo + ' tiene mas de una direccion para facturacion, por favor elija la direccion para la OC', Information!)
			
			else
				
				MessageBox('Aviso', 'El proveedor ' + ls_codigo + ' no tiene ninguna direccion para facturacion, por favor Verifique!', Information!)
			
			end if
				 
			

			
			this.ii_update = 1
		end if
		
	case "lugar_entrega"
		select count(*)
			into :ll_count
		FROM USER_TABLES T
		WHERE T.TABLE_NAME = 'OC_LUGAR_ENTREGA';
		
		if ll_count > 0 then
			select count(*)
				into :ll_count
			FROM OC_LUGAR_ENTREGA T;
		end if;
		
		if ll_count = 0 then
			ls_sql = "SELECT distinct lugar_entrega AS lugar_entrega " &
					  + "FROM orden_Compra oc " &
					  + "where oc.flag_Estado <> '0' " 
		else
			ls_sql = "SELECT lugar_entrega AS lugar_entrega " &
					  + "FROM OC_LUGAR_ENTREGA oc " 
		end if		
				  
				 
		lb_ret = f_lista_1ret(ls_sql, ls_codigo, '1')
		
		if ls_codigo <> '' then
			this.object.lugar_entrega		[al_row] = ls_codigo
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
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.uo_dst_pago	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "ot_gastos"
		sl_param.dw1     = "d_abc_lista_orden_trabajo_x_usr_tbl"
		sl_param.titulo  = "Orden de Trabajo"
		sl_param.tipo    = "1SQL"
		sl_param.string1 =  " WHERE (USUARIO = '" + gs_user + "') " &
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
		ls_sql = "SELECT D.ITEM AS ITEM," &    
				 + "pkg_logistica.of_get_direccion(d.codigo, d.item) as direccion "  &
				 + "FROM DIRECCIONES D "&
				 + "WHERE D.CODIGO = '" + ls_proveedor +"' " &
				 + "AND D.FLAG_USO in ('1', '3')"
												
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

this.ib_edit = false

if is_flag_mod_fec_oc = '1' then
	this.object.fec_registro.protect = '0'
	this.object.fec_registro.Background.Color = RGB(255,255,255)
else
	this.object.fec_registro.protect = '1'
	this.object.fec_registro.background.color = is_backColor
end if

this.object.fec_registro		[al_row] = gnvo_app.of_fecha_actual()
this.object.cod_origen			[al_row] = gs_origen
this.object.uo_dst_pago			[al_row] = gs_origen

if is_flag_aut_oc = '1' then
	this.object.flag_estado			[al_row] = '3' // Estado pendiente
else
	this.object.flag_estado			[al_row] = '1' // Aprobado
end if

this.object.cod_usr				[al_row] = gs_user
this.object.flag_cotizacion	[al_row] = '0'   // Sin cotizacion
this.object.flag_importacion	[al_row] = '0'

this.object.imp_freight			[al_row] = 0.00
this.object.imp_insurance		[al_row] = 0.00
this.object.imp_other			[al_row] = 0.00

// Busco la bolsa de compras
of_fondo_oc(gs_origen)

// Limpia totales
em_vb.text 	 = ''
em_dcto.text = ''
em_imp1.text = ''
em_imp2.text = ''
em_vn.text   = ''

rb_programa.enabled 	= true
rb_ot.enabled 			= true
rb_catalogo.enabled 	= true

rb_ot.event clicked()

is_action = 'new'		// flag cuando es nuevo documento
of_set_status_doc(this)

if is_flag_mod_fec_oc = '1' then
	this.SetColumn('fec_registro')
else
	this.SetColumn('flag_cotizacion')
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
String 	ls_provee, ls_estado, ls_nro_doc, ls_origen, ls_msj
long 		ll_row, ll_count, ll_opcion 
date		ld_fecha

this.AcceptText()

if dwo.name = 'b_reprogramar' then
	
	if MessageBox('Aviso', 'Desea reprogramar todos los items de la OC?', Question!, YesNo!, 2) = 2 then return
	
	ld_fecha = gnvo_app.utilitario.of_get_fecha()
	
	if Not IsNull(ld_Fecha) then
		for ll_row = 1 to dw_detail.RowCount( )
			if dw_detail.object.flag_estado [ll_row] = '1' and &
				dw_detail.object.cant_procesada[ll_row] = 0 then
				
				dw_detail.object.fec_proyect [ll_row] = ld_fecha
				dw_detail.ii_update = 1
				
			end if;
		next
	end if
	
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
	WHERE cod_usr = :gs_user ;
	
	IF ll_count=0 THEN 
		MessageBox('Aviso','Usuario no es aprobador de doc. de compra')
		Return
	END IF
	
	DECLARE usp_cmp_vobo_doc_compra PROCEDURE FOR 
		usp_cmp_vobo_doc_compra ( :is_doc_oc, 
									 	  :ls_origen, 
										  :ls_nro_doc, 	
									 	  :gs_user ) ;
								 
	EXECUTE usp_cmp_vobo_doc_compra ;

	IF sqlca.sqlcode = -1 THEN
		ls_msj = sqlca.sqlerrtext
		ROLLBACK ;
		MessageBox( 'Error usp_cmp_vobo_doc_compra', ls_msj, StopSign! )
		return
	END IF
	
	CLOSE usp_cmp_vobo_doc_compra;
	
	of_retrieve(ls_nro_doc)	
	
elseif dwo.name = 'b_desaprueba' then
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
	WHERE cod_usr = :gs_user ;
	
	IF ll_count=0 THEN 
		MessageBox('Aviso','Usuario no es aprobador de doc. de compra')
		Return
	END IF
	
	DECLARE USP_CMP_DESAPROBAR_DOC_COMPRA PROCEDURE FOR 
		USP_CMP_DESAPROBAR_DOC_COMPRA ( :is_doc_oc, 
									 	  		  :ls_origen, 
										  		  :ls_nro_doc, 	
									 	  		  :gs_user ) ;
								 
	EXECUTE USP_CMP_DESAPROBAR_DOC_COMPRA ;

	IF sqlca.sqlcode = -1 THEN
		ls_msj = sqlca.sqlerrtext
		ROLLBACK ;
		MessageBox( 'Error usp_cmp_desaprobar_doc_compra', ls_msj, StopSign! )
		return
	END IF
	
	CLOSE USP_CMP_DESAPROBAR_DOC_COMPRA ;
	
	of_retrieve(ls_nro_doc)
	
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
	
	if Message.PowerObjectparm.Classname() <> 'sg_parametros' then return
	
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
String 	ls_proveedor, ls_desc, ls_moneda, ls_banco, ls_nom_rep
Integer 	li_item

this.AcceptText()
this.ib_edit = true

if dwo.name = 'proveedor' then	
	
	Select nom_proveedor 
		into :ls_proveedor
	from proveedor 
	where proveedor = :data
	  and flag_estado = '1'
	  and tipo_doc_ident = '6'
	  and ruc is not null;
	  
	if sqlca.sqlcode = 100 then
		Messagebox( "Error", "Proveedor no existe, no esta activo o no tiene RUC asignado")
		this.object.proveedor		[row] = gnvo_app.is_null
		this.object.nom_proveedor 	[row] = gnvo_app.is_null
		Return 1
	end if
	
	this.object.nom_proveedor[row] = ls_proveedor
	
	//Obtengo el primer representante
	select nom_rep
		into :ls_nom_rep
	from representante 
	where proveedor = :ls_proveedor;
	
	this.object.nom_vendedor [row] = ls_nom_rep
	
elseif dwo.name = "flag_cotizacion" then
	
	if data = '2' then
		this.object.nro_Cotizacion.protect = '0'
		this.object.nro_Cotizacion.Background.Color = RGB(255,255,255)
		this.SetColumn('nro_cotizacion')
	else
		this.object.nro_Cotizacion.protect = '1'
		this.object.nro_Cotizacion.background.color = is_backColor
	end if

elseif dwo.name = 'cod_moneda' then
	
	for ll_j = 1 to dw_detail.RowCount()
		dw_detail.object.cod_moneda[ll_j] = data
		dw_detail.ii_update = 1
	Next

	this.object.cod_banco 	[row] = gnvo_app.is_null
	this.object.nom_banco 	[row] = gnvo_app.is_null
	this.object.nro_cuenta 	[row] = gnvo_app.is_null

	of_banco_prov()
	
elseif dwo.name = 'job' then
	
	select descripcion
		into :ls_desc
	from job
	where job = :data;
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Codigo de Job no existe')
		this.object.job 		[row] = gnvo_app.is_null
		this.object.desc_job [row] = gnvo_app.is_null
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
		this.object.cod_banco [row] = gnvo_app.is_null
		this.object.nom_banco [row] = gnvo_app.is_null
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
		this.object.nro_cuenta [row] = gnvo_app.is_null
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
		this.object.uo_dst_pago [row] = gnvo_app.is_null
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
	ls_desc = gnvo_app.logistica.of_direccion_proveedor(ls_proveedor, li_item)
											
	if ISNull(ls_desc) then
		MessageBox('Aviso', 'Item de Direccion no existe o no es de facturacion' + string(li_item))
		SetNull(li_item)
		this.object.item 		[row] = gnvo_app.ii_null
		this.object.direccion[row] = gnvo_app.is_null
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

type dw_detail from u_dw_abc within w_cm311_orden_compra
integer y = 1316
integer width = 3973
integer height = 808
integer taborder = 70
string dataobject = "d_abc_o_compra_det_211"
boolean vscrollbar = false
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

event doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
String 	ls_name, ls_codigo, ls_data, ls_sql, ls_cod_art, &
			ls_mensaje, ls_referencia, ls_almacen, ls_proveedor, &
			ls_moneda, ls_string, ls_evaluate, ls_tasa, ls_cencos
Date 		ld_fecdig, ld_fec_reg
Integer 	li_mes, li_year
boolean 	lb_ret
Long		ll_count
Decimal	ldc_precio, ldc_descuento, ldc_impuesto, &
			ldc_porc_dscto, ldc_porc_imp, ldc_cant_proyect, &
			ldc_tasa, ldc_monto

STR_CNS_POP lstr_1
str_parametros sl_param
str_articulo	lstr_articulo
Datawindow ldw

//if this.Describe( lower(dwo.name) + ".Protect") = '1' then return

if dwo.name = 'cant_procesada' then

		lstr_1.DataObject = 'd_art_mov_amp_tbl'
		lstr_1.Width = 3000
		lstr_1.Height= 800
		lstr_1.Arg[1] = this.object.cod_origen[row]
		lstr_1.Arg[2] = String(this.object.nro_mov[row])
		lstr_1.Title = 'Retiros de Almacen asociados a este requerimiento'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
		return
		
elseif dwo.name = 'cant_trans_ingr' then

		lstr_1.DataObject = 'd_art_mov_transito_tbl'
		lstr_1.Width = 4000
		lstr_1.Height= 800
		lstr_1.Arg[1] = this.object.cod_origen[row]
		lstr_1.Arg[2] = String(this.object.nro_mov[row])
		lstr_1.Arg[3] = 'I%'
		lstr_1.Title = 'Ingresos por Transito'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
		
		return

elseif dwo.name = 'cant_trans_egre' then

		lstr_1.DataObject = 'd_art_mov_transito_tbl'
		lstr_1.Width = 4000
		lstr_1.Height= 800
		lstr_1.Arg[1] = this.object.cod_origen[row]
		lstr_1.Arg[2] = String(this.object.nro_mov[row])
		lstr_1.Arg[3] = 'S%'
		lstr_1.Title = 'Salidas por Transito'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
		
		return

elseif dwo.name = 'cant_facturada' then

		lstr_1.DataObject = 'd_cns_factura_prov_tbl'
		lstr_1.Width = 4000
		lstr_1.Height= 700
		lstr_1.Arg[1] = this.object.cod_origen[row]
		lstr_1.Arg[2] = String(this.object.nro_mov[row])
		lstr_1.Title = 'Provision asociado a este requerimiento'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
		
		return
		
end if


	
ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
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
	
	lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )
	
	if lstr_articulo.b_Return then
		if of_set_articulo( lstr_articulo.cod_art ) then
			this.object.cod_art				[row] = lstr_articulo.cod_art
			this.object.desc_art				[row] = lstr_articulo.desc_art
			this.object.und					[row] = lstr_articulo.und
			this.object.cod_sku				[row] = lstr_articulo.cod_sku
			this.ii_update = 1
			
			return 2
		end if
	end if

	
elseif ls_name = 'cnta_prsp' then
	
	li_year 		= YEAR( DATE( this.object.fec_proyect[row]))
	ls_cencos	= this.object.cencos [row]
	
	ls_sql = "select distinct pc.CNTA_PRSP as codigo_cuenta, " &
			 + "pc.descripcion as descripcion_cuenta " &
			 + "from presupuesto_cuenta pc, " & 
			 + "presupuesto_partida pp " &
			 + "where pc.cnta_prsp = pp.cnta_prsp " &
			 + "and pc.flag_estado = '1' " &
			 + "and pp.ano = " + string(li_year) &
			 + "and NVL(pp.flag_cmp_directa,'') <> '1' " &
			 + "and pp.flag_estado <> '0' " &
			 + "and pp.cencos = '" + ls_cencos + "' " &
			 + "order by pc.descripcion"
				 
	f_lista(ls_sql, ls_codigo, ls_data, '2')
	
	if isnull(ls_codigo) or trim(ls_codigo) = '' then return
	
	this.object.cnta_prsp[row] = ls_codigo
	is_cnta_prsp = ls_codigo		
	this.ii_update = 1		// activa flag de modificado
	

elseif ls_name = 'cencos' then	
	
	li_year = YEAR( DATE( this.object.fec_proyect[row]))
	
	ls_sql = "select distinct cc.cencos as codi_cencos, " &
			 + "cc.desc_cencos as descripcion_cencos " &
			 + "from centros_costo cc, " & 
			 + "presupuesto_partida pp " &
			 + "where pp.cencos = cc.cencos " &
			 + "and cc.flag_estado = '1' " &
			 + "and pp.ano = " + string(li_year) &
			 + "and NVL(pp.flag_cmp_directa,'') <> '1' " &
			 + "and pp.flag_estado <> '0' " &
			 + "order by cc.desc_cencos"
				 
	f_lista(ls_sql, ls_codigo, ls_data, '2')
	
	if isnull(ls_codigo) or trim(ls_codigo) = '' then return
	
	this.object.cencos			[row] = ls_codigo
	is_Cencos 		= ls_codigo
	this.ii_update = 1
			
elseif ls_name = 'almacen' then

	select count(*)
		into :ll_count
	from almacen_user
	where cod_usr = :gs_user;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error('Error al consultar la tabla ALMACEN_USER. Mensaje: ' + ls_mensaje)
		return
	end if
	
	if ll_count = 0 then
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "desc_almacen AS descripcion_almacen, " &
				  + "flag_tipo_almacen as flag_tipo_almacen " &
				  + "FROM almacen " &
				  + "where flag_estado = '1' " &
				  + "order by almacen " 
	else
		ls_sql = "SELECT al.almacen AS CODIGO_almacen, " &
				  + "al.desc_almacen AS descripcion_almacen, " &
				  + "al.flag_tipo_almacen as flag_tipo_almacen " &
				  + "FROM almacen al, " &
				  + "     almacen_user au " &
				  + "where al.almacen = au.almacen " &
				  + "  and au.cod_usr = '" + gs_user + "'" &
				  + "  and al.cod_origen = '" + gs_origen + "' " &
				  + "  and al.flag_estado = '1' " &
				  + "order by al.almacen " 
	end if			
				 
	lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
	if ls_codigo <> '' then
		this.object.almacen			[row] = ls_codigo
		this.ii_update = 1
	end if

elseif ls_name = 'marca' then
	ls_cod_Art = this.object.cod_art [row]
	
	if IsNull(ls_cod_art) or ls_cod_art = '' then
		MessageBox('Error', 'Debe especificar primero un código de articulo antes de ingresar la marca, por favor verifique!')
		this.setcolumn('cod_art')
		return
	end if
	
	ls_sql = "select distinct marca as marca " &
			 + "from articulo_mov_proy " &
			 + "where cod_art = '" + ls_Cod_art + "' " &
			 + "and marca is not null "
				 
	lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
	if ls_codigo <> '' then
		this.object.marca			[row] = ls_codigo
		this.ii_update = 1
	end if

elseif ls_name = 'tipo_impuesto1' then
	
	ls_sql = "SELECT tipo_impuesto as tipo_impuesto, " &
			 + "desc_impuesto as descripcion_impuesto, " &
			 + "tasa_impuesto as tasa_impuesto " &
			 + "FROM impuestos_tipo t"
				 
	lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_tasa, '1')
		
	if ls_codigo <> '' then
		this.object.tipo_impuesto1		[row] = ls_codigo
		this.object.tasa_impuesto1		[row] = Dec(ls_tasa)	
		
		of_update_imp1( row )
		of_update_imp2( row )
		of_set_total_oc( )
		
		this.ii_update = 1
	end if

elseif ls_name = 'tipo_impuesto2' then
	
	ls_sql = "SELECT tipo_impuesto as tipo_impuesto, " &
			 + "desc_impuesto as descripcion_impuesto, " &
			 + "tasa_impuesto as tasa_impuesto " &
			 + "FROM impuestos_tipo t"
				 
	lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_tasa, '1')
		
	if ls_codigo <> '' then
		this.object.tipo_impuesto2		[row] = ls_codigo
		this.object.tasa_impuesto2		[row] = Dec(ls_tasa)	
		
		of_update_imp2( row )
		of_set_total_oc( )
		
		this.ii_update = 1
	end if

elseif dwo.name = 'centro_benef' then
	
	ls_sql = "SELECT a.centro_benef AS CODIGO_CenBef, " &
		  + "a.desc_centro AS DESCRIPCION_centro_benef " &
		  + "FROM centro_beneficio a, " &
		  + "centro_benef_usuario b " &
		  + "where a.centro_benef = b.centro_benef " & 
		  + "and a.flag_estado = '1' " &
		  + "and b.cod_usr = '" + gs_user +"' " &
		  + "and flag_estructura = '0'"
			 
	f_lista(ls_sql, ls_codigo, ls_data, '1')
	
	if ls_codigo <> '' then
		this.object.centro_benef[row] = ls_codigo
		this.ii_update = 1
	end if

end if

//Obtengo el ultimo precio de Compra por Proveedor y Almacen
if (ls_name = "cod_art" or ls_name = "almacen")  then
	if this.object.modif_precio_unit	[row] = '0' then
		
		// Obtengo los datos necesarios
		ls_almacen 			= this.object.almacen	[row]
		ls_moneda 			= this.object.cod_moneda[row]
		ls_cod_art 			= this.object.cod_art	[row]
		ldc_cant_proyect 	= Dec(this.object.cant_proyect[row])
		ls_proveedor		= dw_master.object.proveedor[dw_master.GetRow()] 
		ld_fec_reg			= Date(dw_master.object.fec_registro[dw_master.GetRow()])
	
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
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje= SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al obtener el ultimo precio de compra del artículo. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		If IsNull(ldc_precio) then ldc_precio = 0
		
		this.object.precio_unit [row] = ldc_precio
		
		of_update_precio_unit( row )
		of_precio_total( row )
		of_set_total_oc( )
		
	end if

end if

//elseif ls_name = 'fec_proyect' then
//	
//	ldw = this
//	if row < 1 then return 1
//	if dwo.type <> 'column' then return 1
//
//	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
//	this.ii_update = 1
//	
end event

event ue_insert_pre;call super::ue_insert_pre;// Si se adiciona con referencia, desactiva el ingreso de codigo articulo
Decimal 	ldc_tasa
string 	ls_importacion

this.ib_edit = false

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
this.object.fec_proyect			[al_row] = Date(gnvo_app.of_fecha_actual())
this.object.tipo_doc				[al_row] = is_doc_oc
this.object.cod_origen			[al_row] = dw_master.object.cod_origen[dw_master.GetRow()]
this.object.cod_moneda			[al_row] = dw_master.object.cod_moneda[dw_master.getrow()]

if is_flag_aut_oc = '1' then
	this.object.flag_estado			[al_row] = '3'  // Pendiente de Aprobación
else
	this.object.flag_estado			[al_row] = '1'  // Aprobado
end if

this.object.fec_registro		[al_row] = gnvo_app.of_fecha_actual()
this.object.cencos				[al_row] = is_cencos_mat
this.object.cnta_prsp			[al_row] = is_cnta_prsp_mat
this.object.centro_benef		[al_row] = is_centro_benef
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
this.object.cod_usr				[al_row] = gs_user
this.object.flag_almacen		[al_row] = '1'

if dw_master.GetRow() = 0 then return
// Segun el flag de Importacion coloco o no el IGV
if ls_importacion = '0' then
	// Segun tipo busca tasa
	Select tasa_impuesto 
		into :ldc_tasa 
	from impuestos_tipo 
	where tipo_impuesto = :is_cod_igv;	
	
	this.object.tipo_impuesto1 [al_row] = is_cod_igv
	this.object.tasa_impuesto1 [al_row] = ldc_tasa
else
	this.object.tipo_impuesto1 [al_row] = gnvo_app.is_null
	this.object.tasa_impuesto1 [al_row] = 0	
end if

this.object.impuesto1 		[al_row] = 0

// Inicializo el impuesto 2
this.object.tipo_impuesto2 [al_row] = gnvo_app.is_null
this.object.impuesto2 		[al_row] = 0
this.object.tasa_impuesto2 [al_row] = 0
	
in_precio = 0.00
in_cantidad = 0.00

this.SetColumn( 'cod_art')
of_set_modify()


end event

event itemchanged;call super::itemchanged;Long   		ll_count, ln_mes, ll_nro_mov
String 		ls_desc_art, ls_und, ls_date, ls_cod_origen, ls_almacen, &
				ls_moneda, ls_referencia, ls_cod_art,ls_proveedor, &
				ls_impuesto1, ls_impuesto2, ls_data, ls_cod_sku
				
date   		ld_fecdig, ld_null,ld_fec_proyect_db, ld_fecha, ld_fec_reg
Decimal	 	ldc_cant_proyect, ldc_cant_pendiente, &
				ldc_cant_procesada, ldc_precio_unit, ldc_descuento, &
				ldc_tasa_impuesto1, ldc_tasa_impuesto2, ldc_impuesto2, &
				ldc_impuesto1, ldc_porc_dscto, ldc_precio_con_igv
				 
Integer 		li_dias_rep, li_dias_rep_imp

this.AcceptText()
this.ib_edit = true

ld_fecdig = date(this.object.fec_proyect[row])	// Fecha digitada

IF dwo.name = "cod_art" then
	// Busca codigo
//	if gnvo_app.almacen.of_articulo_inventariable( data ) <> 1 then 
//		this.object.cod_art	[row] = gnvo_app.is_null
//		this.object.desc_art	[row] = gnvo_app.is_null
//		this.object.und		[row] = gnvo_app.is_null
//		return 1
//	end if

	Select 	cod_art, desc_art, und, NVL(dias_reposicion, 0), NVL(dias_rep_import, 0), 
				cod_sku
		into 	:ls_cod_art, :ls_desc_art, :ls_und, :li_dias_rep, :li_dias_rep_imp, 
				:ls_cod_sku
	from articulo 
	Where trim(cod_Art) = trim(:data)
	   or trim(cod_sku) = trim(:data);
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Error', 'El codigo ingresado ' + data + ' no existe como código de artículo ni como codigo SKU. Por favor verifique!', StopSign!)
		this.object.cod_art			[row] = gnvo_app.is_null
		this.object.desc_Art			[row] = gnvo_app.is_null
		this.object.und				[row] = gnvo_app.is_null
		this.object.cod_sku			[row] = gnvo_app.is_null
		this.object.dias_reposicion[row] = gnvo_app.ii_null
		this.object.dias_rep_import[row] = gnvo_app.ii_null
		return 1
	end if
	
	this.object.cod_art			[row] = ls_cod_art
	this.object.desc_Art			[row] = ls_desc_art
	this.object.und				[row] = ls_und		
	this.object.cod_sku			[row] = ls_cod_sku
	this.object.dias_reposicion[row] = li_dias_rep
	this.object.dias_rep_import[row] = li_dias_rep_imp
	
	of_set_articulo(ls_cod_art)
	return 2

elseif dwo.name = 'cencos' then
	
	if IsNull(ld_fecdig) THEN
		Messagebox( "Atencion", 'Ingrese fecha proyectada de desapacho')
		this.Setcolumn( 'fec_proyect')
		this.object.cencos[row] = gnvo_app.is_null
		return 1
	End if
	
	Select Count(cencos) 
		into :ll_count 
	from centros_costo 
	where cencos = :data
	  and flag_estado = '1';
	
	if ll_count = 0 then
		Messagebox( "Error", "Centro de costo no existe o no esta activo, por favor verifique!")
		this.object.cencos[row] = gnvo_app.is_null
		This.SetColumn("cencos")
		this.Setfocus()
		Return 1
	end if
	
	is_cencos = data

elseif dwo.name = 'cnta_prsp' then
	
	Select Count(cnta_prsp) 
		into :ll_count 
	from presupuesto_cuenta 
	where cnta_prsp = :data
	  and flag_estado = '1';
	
	if ll_count = 0 then
		Messagebox( "Error", "Cuenta presupuestal no existe o no esta activo, por favor verifique!")
		this.object.cnta_prsp[row] = gnvo_app.is_null
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
		Messagebox( "Error", "Almacen no existe o no esta activo, por favor verifique")
		this.object.almacen[row] = gnvo_app.is_null
		this.SetColumn('almacen')
		this.SetFocus()
		Return 1
	end if

elseif dwo.name = 'cant_proyect' then
	
	ldc_cant_proyect  = Dec(data)
	
	if ldc_cant_proyect <= 0 or IsNull(ldc_cant_proyect) then
		this.object.cant_proyect[row] = gnvo_app.idc_null
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
		this.object.decuento		[row] = 0
		this.object.impuesto1	[row] = 0
		this.object.impuesto2	[row] = 0
		this.SetColumn('precio_unit')
		return 1
	end if
	
	ldc_descuento 	= this.object.decuento [row]
	if ldc_descuento > ldc_precio_unit then
		MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
		this.object.porc_dscto	[row] = 0
		this.object.decuento		[row] = 0
		return 1
	end if
	
	//Impuesto 1
	of_update_imp1( row )
	
	//Impuesto 2
	of_update_imp2( row )

	of_precio_total( row )
	
	of_set_total_oc( )
	
elseif dwo.name = 'precio_con_igv' then
	
	if IsNull(data) or Dec(Data) <= 0 then
		MessageBox('Aviso', 'El precio total no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = 0
		this.object.impuesto1	[row] = 0
		this.object.impuesto2	[row] = 0
		this.object.precio_unit	[row] = 0
		this.SetColumn('precio_con_igv')
		return 1
	end if

	of_precio_con_igv( row )
	
	of_set_total_oc()
	
	this.object.modif_precio_unit [row] = '1'

		
elseif dwo.name = 'precio_unit' then
	
	ldc_precio_unit  = Dec(data)

	if IsNull(ldc_precio_unit) or ldc_precio_unit < 0 then
		MessageBox('Aviso', 'El precio unitario no puede ser negativo o estar en blanco')
		this.object.decuento		[row] = 0
		this.object.impuesto1	[row] = 0
		this.object.impuesto2	[row] = 0
		this.SetColumn('precio_unit')
		return 1
	end if
	
	ldc_cant_proyect  = Dec(this.object.cant_proyect[row])
	
	if ldc_cant_proyect <= 0 or IsNull(ldc_cant_proyect) then
		this.object.cant_proyect[row] = gnvo_app.idc_null
		Messagebox( "Atencion", "Cantidad no permitida")
		return 1
	end if
	
	ldc_porc_dscto = Dec(this.object.porc_dscto[row])
	if IsNull(ldc_porc_dscto) then
		ldc_porc_dscto = 0
		this.object.porc_dscto[row] = 0
	end if
	
	ldc_descuento 	= ldc_precio_unit * ldc_porc_dscto/100
	
	if ldc_descuento > ldc_precio_unit then
		MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
		this.object.porc_dscto	[row] = gnvo_app.idc_null
		this.object.decuento		[row] = gnvo_app.idc_null
		return 1
	end if
	
	// Impuesto1
	of_update_imp1( row )

	//Impuesto2
	of_update_imp2( row )
	
	of_precio_total( row )
	
	of_set_total_oc()
	
	this.object.modif_precio_unit [row] = '1'

elseif dwo.name = 'porc_dscto' then
	ldc_precio_unit  = Dec(this.object.precio_unit[row])

	if IsNull(ldc_precio_unit) or ldc_precio_unit <= 0 then
		MessageBox('Aviso', 'El precio unitario no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = 0
		this.object.impuesto1	[row] = 0
		this.object.impuesto2	[row] = 0
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
		this.object.porc_dscto	[row] = gnvo_app.idc_null
		this.object.decuento		[row] = gnvo_app.idc_null
		this.SetColumn('porc_dscto')
		return 1
	end if
	
	this.object.decuento		[row] = ldc_descuento
	
	of_update_imp1( row )
	of_update_imp2( row )

	of_precio_total( row )
	
	of_set_total_oc()
	
	this.object.modif_precio_unit [row] = '1'

	
elseif dwo.name = 'decuento' then
	ldc_precio_unit = Dec(this.object.precio_unit[row])

	if IsNull(ldc_precio_unit) or Dec(ldc_precio_unit) <= 0 then
		MessageBox('Aviso', 'El precio unit no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = 0
		this.object.impuesto1	[row] = 0
		this.object.impuesto2	[row] = 0
		this.SetColumn('precio_unit')
		return 1
	end if
	
	ldc_descuento = Dec(data)
	if ldc_descuento > Dec(this.object.precio_unit[row]) then
		MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
		this.object.porc_dscto	[row] = 0
		this.object.decuento		[row] = gnvo_app.idc_null
		this.SetColumn('decuento')
		return 1
	end if
	this.object.porc_dscto[row] = round(ldc_descuento/ldc_precio_unit * 100,2)
	
	of_update_imp1( row )
	of_update_imp2( row )

	of_precio_total( row )
	
	of_set_total_oc()
	
	this.object.modif_precio_unit [row] = '1'

elseif dwo.name = 'impuesto1' then
	ldc_precio_unit  = Dec(this.object.precio_unit[row])
	ldc_cant_proyect = Dec(this.object.cant_proyect[row])
	ldc_descuento	  = Dec(this.object.decuento	  [row])
	ldc_impuesto1	  = Dec(data)
	
	if IsNull(ldc_precio_unit) or Dec(ldc_precio_unit) <= 0 then
		MessageBox('Aviso', 'El precio unit no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = 0
		this.object.impuesto1	[row] = 0
		this.object.impuesto2	[row] = 0
		this.SetColumn('precio_unit')
		return 1
	end if
	
	of_update_imp2( row )
	
	of_precio_total( row )
	
	of_set_total_oc()
	
elseif dwo.name = 'impuesto2' then
	ldc_precio_unit  = Dec(this.object.precio_unit[row])

	
	if IsNull(ldc_precio_unit) or Dec(ldc_precio_unit) <= 0 then
		MessageBox('Aviso', 'El precio unit no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = 0
		this.object.impuesto1	[row] = 0
		this.object.impuesto2	[row] = 0
		this.SetColumn('precio_unit')
		return 1
	end if
	
	of_precio_total( row )
	
	of_set_total_oc()

elseif dwo.name = 'tipo_impuesto1' then
	ldc_precio_unit  = Dec(this.object.precio_unit[row])

	
	if IsNull(ldc_precio_unit) or Dec(ldc_precio_unit) <= 0 then
		MessageBox('Aviso', 'El precio unit no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = 0
		this.object.impuesto1	[row] = 0
		this.object.impuesto2	[row] = 0
		this.SetColumn('precio_unit')
		return 1
	end if

	select tasa_impuesto
		into :ldc_tasa_impuesto1
	from impuestos_tipo
	where tipo_impuesto = :data;

	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'El Tipo de Impuesto no existe, por favor verifique')
		this.object.tipo_impuesto1	[row] = gnvo_app.is_null
		this.object.impuesto1		[row] = 0
		this.object.tasa_impuesto1	[row] = 0
		this.SetColumn('tipo_impuesto1')
		return 1
	end if
	
	this.object.tasa_impuesto1[row] = ldc_tasa_impuesto1
	
	of_update_imp1( row )
	of_update_imp2( row )
	
	of_precio_total( row )
	
	of_set_total_oc()

elseif dwo.name = 'tipo_impuesto2' then
	ldc_precio_unit  = Dec(this.object.precio_unit[row])

	
	if IsNull(ldc_precio_unit) or Dec(ldc_precio_unit) <= 0 then
		MessageBox('Aviso', 'El precio unit no puede ser cero, negativo o estar en blanco')
		this.object.decuento		[row] = 0
		this.object.impuesto1	[row] = 0
		this.object.impuesto2	[row] = 0
		this.SetColumn('precio_unit')
		return 1
	end if

	select tasa_impuesto
		into :ldc_tasa_impuesto2
	from impuestos_tipo
	where tipo_impuesto = :data;

	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'El Tipo de Impuesto no existe, por favor verifique')
		this.object.tipo_impuesto2	[row] = gnvo_app.is_null
		this.object.impuesto2		[row] = 0
		this.object.tasa_impuesto2	[row] = 0
		this.SetColumn('tipo_impuesto2')
		return 1
	end if
	
	this.object.tasa_impuesto2[row] = ldc_tasa_impuesto2
	
	of_update_imp2( row )
	
	of_precio_total( row )
	
	of_set_total_oc()

elseif dwo.name = 'centro_benef' then
	select a.desc_centro
		into :ls_data
	from centro_beneficio a,
		  centro_benef_usuario b
	where a.centro_benef = b.centro_benef
	  and a.centro_benef = :data
	  and a.flag_estado 	= '1'
	  and b.cod_usr 		= :gs_user;
	
	if SQLCA.SQLCode = 100 then
		Messagebox('Aviso', "Código de Centro de Beneficio no existe, no está activo o no esta asignado a usted, por favor verifique", StopSign!)
		this.object.centro_benef	[row] = gnvo_app.is_null
		return 1
	end if
	
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

	of_update_precio_unit( row )

	of_precio_total( row )
	
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

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda
String 	ls_name, ls_prot, ls_cod_art, ls_docname, ls_named, ls_desc
Integer 	li_ano, li_value
str_parametros sl_param

this.AcceptText()
ls_name = dwo.name
ls_prot = dw_master.Describe(  "cod_art.Protect" )

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name 
		
	CASE "b_marca"
		// Para la descripcion de la Factura
		ls_desc 		= This.object.marca 	[row]
		
		sl_param.string1   = 'Observaciones'
		sl_param.string2	 = ls_desc
	
		OpenWithParm( w_descripcion_fac, sl_param)
		
		IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
		IF sl_param.titulo = 's' THEN
			This.object.marca 		[row] = sl_param.string3
			this.ii_update = 1
		END IF
		
END CHOOSE
end event

