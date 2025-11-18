$PBExportHeader$w_cm314_orden_servicios.srw
forward
global type w_cm314_orden_servicios from w_abc_mastdet
end type
type st_1 from statictext within w_cm314_orden_servicios
end type
type st_2 from statictext within w_cm314_orden_servicios
end type
type st_3 from statictext within w_cm314_orden_servicios
end type
type st_4 from statictext within w_cm314_orden_servicios
end type
type em_tb from editmask within w_cm314_orden_servicios
end type
type em_dcto from editmask within w_cm314_orden_servicios
end type
type em_imp from editmask within w_cm314_orden_servicios
end type
type em_tn from editmask within w_cm314_orden_servicios
end type
type cb_1 from commandbutton within w_cm314_orden_servicios
end type
type rb_ref_ss from radiobutton within w_cm314_orden_servicios
end type
type rb_sin_ref from radiobutton within w_cm314_orden_servicios
end type
type st_ori from statictext within w_cm314_orden_servicios
end type
type sle_ori from singlelineedit within w_cm314_orden_servicios
end type
type st_nro from statictext within w_cm314_orden_servicios
end type
type cb_buscar from commandbutton within w_cm314_orden_servicios
end type
type rb_ref_ot from radiobutton within w_cm314_orden_servicios
end type
type cb_aprobar from commandbutton within w_cm314_orden_servicios
end type
type cb_desaprobar from commandbutton within w_cm314_orden_servicios
end type
type sle_nro from u_sle_codigo within w_cm314_orden_servicios
end type
type gb_2 from groupbox within w_cm314_orden_servicios
end type
end forward

global type w_cm314_orden_servicios from w_abc_mastdet
integer width = 4466
integer height = 3656
string title = "Orden de Servicios (CM314)"
string menuname = "m_mtto_imp_mail"
event ue_anular ( )
event ue_cancelar ( )
event ue_cerrar ( )
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
em_tb em_tb
em_dcto em_dcto
em_imp em_imp
em_tn em_tn
cb_1 cb_1
rb_ref_ss rb_ref_ss
rb_sin_ref rb_sin_ref
st_ori st_ori
sle_ori sle_ori
st_nro st_nro
cb_buscar cb_buscar
rb_ref_ot rb_ref_ot
cb_aprobar cb_aprobar
cb_desaprobar cb_desaprobar
sle_nro sle_nro
gb_2 gb_2
end type
global w_cm314_orden_servicios w_cm314_orden_servicios

type variables
String 		is_cencos = '', is_cnta_prsp = '', &
				is_soles, is_dolares, is_flag_restr_cencos_usr, is_flag_req_serv, &
				is_flag_tipo_serv, is_flag_aut_os, is_salir, is_doc_os, &
				is_flag_cenbef, is_flag_cnta_prsp, is_FLAG_VALIDA_LIMITE_OS
Decimal 		in_new_importe, in_old_importe
Decimal 		in_tipo_cambio
Long			il_dias_retrazo_os
n_cst_utilitario	invo_util
end variables

forward prototypes
public function integer wf_verifica_datos ()
public subroutine of_retrieve (string as_origen, string as_nro)
public function integer of_set_numera ()
public function integer of_bloquea_detalle ()
public function integer of_set_total_os ()
public function integer of_set_status_doc (datawindow idw)
public function integer of_verificar_fecha ()
public function integer of_get_param ()
public function integer of_modify ()
public function integer of_nro_cnta_banco (string as_banco)
public function integer of_banco_prov ()
end prototypes

event ue_anular;Integer 	li_j, li_count, li_row
string	ls_nro_os

IF dw_master.GetRow() = 0 then return

li_row = dw_master.GetRow()

if dw_master.object.FLAG_REQ_SERV[li_row] = '2' then
	MessageBox('Aviso', 'no puede anular esta Orden de Servicio ya que generada x el sistema')
	return
end if

ls_nro_os = dw_master.object.nro_os[li_row]

//Valido si la OS ha sido generada desde APROVISIONAMIENTO
select count(*)
	into :li_count
from ap_pd_descarga_det
where nro_os = :ls_nro_os;

if li_count > 0 then
	MessageBox('Aviso', 'No puede anular esta Orden de Servicio ya que generada desde APROVISIONAMIENTO')
	dw_master.ii_protect = 0 
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0 
	dw_detail.of_protect()
	
	return
end if


// Valido si la OS ha sido generada a partir del Módulo de Flota
select count(*)
  into :li_count
  from fl_gtos_drcts_bahia_det a,
  		 orden_servicio_det b
where a.oper_sec = b.oper_sec
  and b.nro_os   = :ls_nro_os;

if li_count > 0 then
	MessageBox('Aviso', 'no puede anular esta Orden de Servicio fue generada por el MODULO DE FLOTA')
	return	
end if

// Ahora valido si la OS ha sido generada a partir del Módulo de Aprovisionamiento
select count(*)
  into :li_count
  from ap_pd_descarga_det a
where a.nro_os = :ls_nro_os;

if li_count > 0 then
	MessageBox('Aviso', 'no puede anular esta Orden de Servicio fue generada por el MODULO DE APROVISIONAMIENTO')
	return	
end if

if MessageBox('Aviso', 'Deseas anular la Orden de Servicio', Information!, YesNo!, 2) = 2 then return

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN RETURN


// Anulando Cabecera
dw_master.object.flag_estado[li_row] = '0'
dw_master.object.monto_total[li_row] = 0
dw_master.ii_update = 1

// Anulando Detalle
for li_j = 1 to dw_detail.rowCount()
	dw_detail.object.flag_estado	[li_j] = '0'
	dw_detail.object.importe		[li_j] = 0
	dw_detail.object.impuesto		[li_j] = 0
	dw_detail.object.impuesto2		[li_j] = 0
	dw_detail.object.decuento		[li_j] = 0
next
dw_detail.ii_update = 1
is_action = 'anu'

of_set_status_doc( idw_1)
end event

event ue_cancelar();// Cancela operacion, limpia todo
EVENT ue_update_request()   // Verifica actualizaciones pendientes

dw_master.reset()
dw_detail.reset()
sle_ori.text = ''
sle_nro.text = ''
sle_ori.SetFocus()
idw_1 = dw_master
dw_master.il_row = 0

is_Action = ''
of_set_status_doc(dw_master)
end event

event ue_cerrar();Long ll_row

if MessageBox('Aviso', 'Deseas cerrar el detalle de la Orden de Servicio', Information!, YesNo!, 2) = 2 then return

for ll_row = 1 to dw_detail.RowCOunt()
	dw_detail.object.flag_estado[ll_row] = '2'
	dw_detail.ii_update = 1
next
end event

public function integer wf_verifica_datos ();// Verifica datos si han sido ingresados
Long ll_row

ll_row = dw_master.getrow()
IF ll_row = 0 then return 1

//Proveedor
if ISNULL(dw_master.object.proveedor[ll_row] ) &
	OR TRIM( dw_master.object.proveedor[ll_row]) = '' THEN
	
	Messagebox( "Error", "Ingrese proveedor")
	dw_master.setcolumn( "proveedor")
	dw_master.Setfocus()
	Return 0
END IF

//Forma de Pago
if ISNULL(dw_master.object.forma_pago[ll_row] ) &
	OR TRIM( dw_master.object.forma_pago[ll_row]) = '' THEN
	
	Messagebox( "Error", "Forma pago")
	dw_master.setcolumn( "forma_pago")
	dw_master.Setfocus()
	Return 0
END IF


//Codigo de Moneda
if ISNULL(dw_master.object.cod_moneda[ll_row] ) &
	OR TRIM( dw_master.object.cod_moneda[ll_row]) = '' THEN
	
	Messagebox( "Error", "Ingrese moneda")
	dw_master.setcolumn( "cod_moneda")
	dw_master.Setfocus()
	Return 0
END IF

return 1
end function

public subroutine of_retrieve (string as_origen, string as_nro);Long  ll_i

dw_master.Reset()
dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

dw_detail.Reset()
dw_detail.ii_update = 0
dw_detail.ii_protect = 0
dw_detail.of_protect()

dw_master.retrieve(as_origen, as_nro)

idw_1 = dw_master
idw_1.SetFocus()

if dw_master.RowCount() > 0 then	
	dw_master.il_row = 1
	
	dw_detail.retrieve(as_origen, as_nro)	

	// Busca tipo de cambio de la fecha de transaccion
	// Verifica tipo de cambio
	in_tipo_cambio = f_get_tipo_cambio( DATE(dw_master.object.fec_registro[dw_master.GetRow()]))
	if in_tipo_cambio = 0 THEN 
		Messagebox( "Error", "No existe tipo de cambio definido")
		return
	end if
	
	for ll_i = 1 to dw_detail.RowCount() 
		if Dec(dw_detail.object.importe[ll_i]) <> 0 then
			dw_detail.object.descto[ll_i] = Round(Dec(dw_detail.object.decuento[ll_i])/Dec(dw_detail.object.importe[ll_i])*100,2)
		end if
	next
	
 	rb_ref_ss.enabled = false
	rb_ref_ot.enabled = false
	rb_sin_ref.enabled = false
	
	of_set_status_doc( idw_1 )
	of_set_total_os()
	
	is_action = 'open'
end if

end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_long, ll_ult_nro, ll_j, ll_count
string	ls_mensaje, ls_nro_os
Date		ld_fec_compra

try 
	if dw_master.getRow() = 0 then return 1
	
	ls_nro_os = dw_master.object.nro_os[1]
	
	if is_action = 'new' or IsNull(ls_nro_os) or Trim(ls_nro_os) = ''   then
		
		if gnvo_app.of_get_parametro( "COMPRA_NUM_OS_DIARIO", "0") = "0" then
			Select ult_nro 
				into :ll_ult_nro 
			from num_ord_srv 
			where origen = :gs_origen for update;
			
			IF SQLCA.SQLCode = 100 then
				Insert into num_ord_srv (origen, ult_nro)
					values( :gs_origen, 1);
				
				IF SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Aviso', "Error al INSERTAR en tabla num_ord_srv. Mensaje: " + ls_mensaje, StopSign!)
					return 0
				end if
				
				ll_ult_nro = 1
			end if
			
		
			ls_nro_os = TRIM(gs_origen) + invo_util.lpad(String(ll_ult_nro), 8, '0')
			
			select count(*)
			  into :ll_count
			  from orden_servicio os
			 where os.nro_os = :ls_nro_os;
			 
			
			DO WHILE ll_count > 0
				ll_ult_nro ++
				ls_nro_os = TRIM(gs_origen) + invo_util.lpad(String(ll_ult_nro), 8, '0')
				
				select count(*)
				  into :ll_count
				  from orden_servicio os
				 where os.nro_os = :ls_nro_os;
				 
			LOOP
		
		
			dw_master.object.nro_os[1] = ls_nro_os
			
			// Incrementa contador
			Update num_ord_srv 
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
			from num_ord_srv 
			where origen = :gs_origen for update;
			
			IF SQLCA.SQLCode = 100 then
				Insert into num_ord_srv (origen, ult_nro)
					values( :gs_origen, 1);
				
				IF SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Aviso', "Error al INSERTAR en tabla num_ord_comp. Mensaje: " + ls_mensaje, StopSign!)
					return 0
				end if
				
				ll_ult_nro = 1
			end if
			
		
			ls_nro_os = TRIM(gs_origen) + invo_util.lpad(String(ll_ult_nro), 8, '0')
			
			select count(*)
			  into :ll_count
			  from orden_servicio os
			 where os.nro_os = :ls_nro_os;
			 
			
			DO WHILE ll_count > 0
				ll_ult_nro ++
				ls_nro_os = TRIM(gs_origen) + invo_util.lpad(String(ll_ult_nro), 8, '0')
				
				select count(*)
				  into :ll_count
				  from orden_servicio os
				 where os.nro_os = :ls_nro_os;
				 
			LOOP
		
		
			dw_master.object.nro_os[1] = ls_nro_os
			
			// Incrementa contador
			Update num_ord_srv 
				set ult_nro = :ll_ult_nro + 1 
			 where origen = :gs_origen;
			
			IF SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', "Error al ACTUALIZAR en tabla num_ord_srv. Mensaje: " + ls_mensaje, StopSign!)
				return 0
			end if
		
		end if
		
		
			
	end if
	
	// Asigna numero a detalle
	for ll_j = 1 to dw_detail.RowCount()	
		dw_detail.object.nro_os[ll_j] = ls_nro_os	
	next
	
	return 1

catch ( Exception ex )
	gnvo_app.of_Catch_exception( ex, "Exception al generar el numerador de la Orden de Compra")
	return 0
	
finally
	/*statementBlock*/
end try


//if dw_master.getrow() = 0 then return 1
//
//if is_action = 'new' then
//	
//	SELECT count(*) 
//		into :ll_count
//	FROM num_ord_srv WHERE trim(origen) = '" + gs_origen + "' FOR UPDATE
//	
//	SELECT ult_nro FROM " + ls_table + " WHERE trim(origen) = '" + gs_origen + "' FOR UPDATE
//	
//	ls_next_nro = f_numera_documento('num_ord_srv',10)
//	dw_master.object.nro_os[dw_master.getrow()] = ls_next_nro
//else
//	ls_next_nro = dw_master.object.nro_os[1] 
//end if
//
//// Asigna numero a detalle
//for j = 1 to dw_detail.RowCount()
//	dw_detail.object.nro_os[j] = ls_next_nro
//next
//
//return 1
end function

public function integer of_bloquea_detalle ();// Funcion que bloquea detalle
dw_detail.object.fec_proyect.background.color = RGB(192,192,192)
dw_detail.object.cencos.background.color = RGB(192,192,192)
dw_detail.object.cnta_prsp.background.color = RGB(192,192,192)
dw_detail.object.descripcion.background.color = RGB(192,192,192)
dw_detail.object.fec_proyect.protect = 1
//dw_detail.object.cencos.protect = 1
//dw_detail.object.cnta_prsp.protect = 1
//dw_detail.object.descripcion.protect = 1
return 1
end function

public function integer of_set_total_os ();// Halla sub total
Decimal{2} ln_sub_total,  ln_tot_dct, ln_tot_igv  
Int j

ln_sub_total = 0
ln_tot_dct = 0
ln_tot_igv = 0
dw_detail.AcceptText()

For j = 1 to dw_detail.Rowcount()			

	ln_sub_total = ln_sub_total + dw_detail.object.importe[j]
	
	// Calcula descuento
	if dw_detail.object.decuento[j] > 0 then
		ln_tot_dct = ln_tot_dct + dw_detail.object.decuento[j] 
	end if
	// Calcula impuesto 1
	if dw_detail.object.impuesto[j] <> 0 then		
		ln_tot_igv = ln_tot_igv + dw_detail.object.impuesto[j] 
	end if
	// Calcula impuesto 2
	if dw_detail.object.impuesto2[j] <> 0 then		
		ln_tot_igv = ln_tot_igv + dw_detail.object.impuesto2[j]
	end if
Next
em_tb.text   = String(ln_sub_total)
em_dcto.text = String(ln_tot_dct)
em_imp.text  = String(ln_tot_igv)
em_tn.text   = String(ln_sub_total - ln_tot_dct + ln_tot_igv) 

return 1
end function

public function integer of_set_status_doc (datawindow idw);////this.changemenu(m_mtto_impresion)	// Activa menu
///*
//  Funcion que verifica el status del documento
//*/
//this.changemenu( m_mtto_imp_mail)
//
//Int li_estado
//
//// Activa todas las opciones
//m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles( is_niveles, 'I')  // true
//m_master.m_file.m_basedatos.m_eliminar.enabled = f_niveles( is_niveles, 'E')  //true
//m_master.m_file.m_basedatos.m_modificar.enabled = f_niveles( is_niveles, 'M') //true
//m_master.m_file.m_basedatos.m_anular.enabled = true
//m_master.m_file.m_basedatos.m_abrirlista.enabled = true
//m_master.m_file.m_printer.m_print1.enabled = true
//
//if dw_master.getrow() = 0 then return 0
//if is_Action = 'new' then
//	// Activa desactiva opcion de modificacion, eliminacion	
//	m_master.m_file.m_basedatos.m_eliminar.enabled = false
//	m_master.m_file.m_basedatos.m_modificar.enabled = false
//	m_master.m_file.m_basedatos.m_anular.enabled = false
//	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
//
//	m_master.m_file.m_printer.m_print1.enabled = false			
//	m_master.m_file.m_basedatos.m_insertar.enabled = false
//	m_master.m_file.m_basedatos.m_email.enabled = false
//	if idw = dw_detail then			
//		if rb_2.checked = true then
//			IF f_niveles( is_niveles, 'I') = FALSE THEN
//		   	m_master.m_file.m_basedatos.m_insertar.enabled = false
//			ELSE
//				m_master.m_file.m_basedatos.m_insertar.enabled = true
//			END IF			   
//		end if
//		if rb_3.checked = true then
//	   	m_master.m_file.m_basedatos.m_insertar.enabled =  f_niveles( is_niveles, 'I')
//		end if
//	end if
//	// Activa desactiva opcion de modificacion, eliminacion	
//	if idw = dw_master then		// Si es master, tiene que estar activo para adicionar otro documento
//		m_master.m_file.m_basedatos.m_insertar.enabled = false
//	else
//		IF f_niveles( is_niveles, 'E') = FALSE THEN	   	
//			m_master.m_file.m_basedatos.m_eliminar.enabled = false
//		ELSE			
//			m_master.m_file.m_basedatos.m_eliminar.enabled = true
//		END IF		   
//	end if
//elseif is_Action = 'open' then
//	
//	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])	
//	Choose case li_estado
//		case 0		// Anulado			
//			m_master.m_file.m_basedatos.m_eliminar.enabled = false
//			m_master.m_file.m_basedatos.m_modificar.enabled 	= false
//			m_master.m_file.m_basedatos.m_anular.enabled 		= false
//			m_master.m_file.m_basedatos.m_email.enabled 	= false
//			m_master.m_file.m_basedatos.m_grabar.enabled 		= false
//		case 1		// Activo
//			if is_flag_aut_os = '1' then
//				m_master.m_file.m_basedatos.m_eliminar.enabled = false
//				m_master.m_file.m_basedatos.m_modificar.enabled 	= false
//				m_master.m_file.m_basedatos.m_email.enabled 	= false
//				m_master.m_file.m_basedatos.m_grabar.enabled 		= false
//			end if
//		case 2		// Cerrado
//			m_master.m_file.m_basedatos.m_eliminar.enabled = false
//			m_master.m_file.m_basedatos.m_modificar.enabled 	= false
//			m_master.m_file.m_basedatos.m_anular.enabled 		= false
//			m_master.m_file.m_basedatos.m_email.enabled 	= false
//			m_master.m_file.m_basedatos.m_grabar.enabled 		= false
//		case 3		// Pendiente VoBo
//			m_master.m_file.m_basedatos.m_anular.enabled 		= false
//			m_master.m_file.m_basedatos.m_email.enabled 	= false
//	end CHOOSE
//	
//	if idw = dw_master then		// Si es master, tiene que estar activo para adicionar otro documento
//	   IF f_niveles( is_niveles, 'I') = FALSE THEN
//	   	m_master.m_file.m_basedatos.m_insertar.enabled = false
//		ELSE
//			m_master.m_file.m_basedatos.m_insertar.enabled = true
//		END IF		      
//	else
//		if rb_1.checked = true then
//			m_master.m_file.m_basedatos.m_insertar.enabled = false
//		else
//			IF f_niveles( is_niveles, 'I') = FALSE THEN
//		   	m_master.m_file.m_basedatos.m_insertar.enabled = false
//			ELSE
//				m_master.m_file.m_basedatos.m_insertar.enabled = true
//			END IF			   
//		end if
//	end if
//end if
//
//if is_Action = 'anu' then	
//	m_master.m_file.m_basedatos.m_eliminar.enabled = false
//	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
//	m_master.m_file.m_basedatos.m_anular.enabled 		= false
//	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
//	m_master.m_file.m_basedatos.m_insertar.enabled = false	
//	m_master.m_file.m_basedatos.m_email.enabled 	= false
//	m_master.m_file.m_printer.m_print1.enabled 			= false
//end if
//
//if is_Action = 'edit' then	
//	m_master.m_file.m_basedatos.m_eliminar.enabled = false
//	m_master.m_file.m_basedatos.m_modificar.enabled = false
//	m_master.m_file.m_basedatos.m_anular.enabled = false
//	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
//	m_master.m_file.m_basedatos.m_insertar.enabled = false	
//	m_master.m_file.m_basedatos.m_email.enabled = false
//	m_master.m_file.m_printer.m_print1.enabled = false
//	m_master.m_file.m_basedatos.m_grabar.enabled = true
//end if
//
//if is_Action = 'del' then	
//	m_master.m_file.m_basedatos.m_eliminar.enabled = true
//	m_master.m_file.m_basedatos.m_modificar.enabled = false
//	m_master.m_file.m_basedatos.m_anular.enabled = false
//	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
//	m_master.m_file.m_basedatos.m_insertar.enabled = true	
//	m_master.m_file.m_printer.m_print1.enabled = false
//	m_master.m_file.m_basedatos.m_email.enabled = false
//end if
//
//if is_Action = 'adic' then
//	// Activa desactiva opcion de modificacion, eliminacion	
//	m_master.m_file.m_basedatos.m_eliminar.enabled = true
//	m_master.m_file.m_basedatos.m_modificar.enabled = false
//	m_master.m_file.m_basedatos.m_anular.enabled = false
//	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
//	m_master.m_file.m_printer.m_print1.enabled = false			
//	m_master.m_file.m_basedatos.m_insertar.enabled = false
//	m_master.m_file.m_basedatos.m_email.enabled = false	
//	m_master.m_file.m_basedatos.m_insertar.enabled = true
//end if
//
return 1
end function

public function integer of_verificar_fecha ();Long ll_i
Date ld_fec_cab, ld_fec_det

if dw_master.GetROw() = 0  then 
	MessageBox('Error', 'La Orden de Servicio no tiene cabecera')
	return 0
end if

ld_fec_cab = Date(dw_master.object.fec_registro[dw_master.GetRow()])

for ll_i = 1 to dw_detail.RowCount()
	ld_fec_det = DAte(dw_detail.object.fec_proyect[ll_i])
	
	if ld_fec_det < RelativeDate(ld_fec_cab, il_dias_retrazo_os * -1) then
		MessageBox('Error', 'La Fecha proyectada no puede ser ' &
			+ 'menor que la fecha de Registro la Orden de ' &
			+ 'Servicio en ' + string(il_dias_retrazo_os) + ' dias')
			
		dw_detail.SetRow( ll_i )
		dw_detail.selectrow( 0, False )
		dw_detail.selectrow( ll_i, true )
		dw_detail.scrolltorow( ll_i )
		return 0
	end if
next

return 1


end function

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

try 

	is_flag_aut_os = gnvo_app.of_get_parametro('COMPRA_APROBACION_OS', '0')

catch ( Exception ex)

	gnvo_app.of_catch_exception(ex, 'Error al cargar parametros para compras')

end try

select cod_soles, NVL(dias_retrazo_os, 0), doc_os,
		 NVL(flag_centro_benef, '0'), NVL(FLAG_VALIDA_LIMITE_OS, '0')
	into :is_soles, :il_dias_retrazo_os, :is_doc_os,
		  :is_flag_cenbef, :is_FLAG_VALIDA_LIMITE_OS
from logparam
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en logparam, por favor verifique!', StopSign!)
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", "Error al consultar LOGPARAM. Mensaje: " + ls_mensaje, StopSign!)
	return 0
end if

if is_soles = '' or IsNull(is_soles) then
	MessageBox('Aviso', 'No ha definido moneda soles en logparam, por favor verifique!', StopSign!)
	return 0
end if

if is_doc_os = '' or IsNull(is_doc_os) then
	MessageBox('Aviso', 'No ha definido Documento OS en logparam, por favor verifique!', StopSign!)
	return 0
end if

select NVL(flag_restr_cencos_usr,'0'), NVL(flag_mod_asg_cnt_os, '0'),
		 NVL(flag_mod_cnta_prsp, '0')
	into :is_flag_restr_cencos_usr, :is_flag_tipo_serv,
		  :is_flag_cnta_prsp
from presup_param
where llave = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en PRESUP_PARAM', StopSign!)
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", "Error al consultar PRESUP_PARAM. Mensaje: " + ls_mensaje, StopSign!)
	return 0
end if

//Actualizo la cantidad provisionada de las cntas por pagar
update orden_servicio_det osd
   set osd.imp_provisionado = (select nvl(sum(cpd.cantidad * cpd.precio_unit),0)
                                 from cntas_pagar_det cpd,
                                      cntas_pagar     cp
                                where cp.cod_relacion = cpd.cod_relacion
                                  and cp.tipo_doc     = cpd.tipo_doc
                                  and cp.nro_doc      = cpd.nro_doc
                                  and cpd.nro_os = osd.nro_os
                                  and cpd.item_os = osd.nro_item
                                  and cp.flag_estado <> '0')
                      
where osd.imp_provisionado <> (select nvl(sum(cpd.cantidad * cpd.precio_unit),0)
                                 from cntas_pagar_det cpd,
                                      cntas_pagar     cp
                                where cp.cod_relacion = cpd.cod_relacion
                                  and cp.tipo_doc     = cpd.tipo_doc
                                  and cp.nro_doc      = cpd.nro_doc
                                  and cpd.nro_os = osd.nro_os
                                  and cpd.item_os = osd.nro_item
                                  and cp.flag_estado <> '0');
if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", "Error al actualizar cantidad provisionada en ORDEN_SERVICIO_DET. Mensaje: " + ls_mensaje, StopSign!)
	return 0
end if

commit;

return 1

end function

public function integer of_modify ();// ahora tengo que verificar si puede modificar el centro de benef
// Solo si tiene OT y además si la Cenbef_ot no es nulo

dw_detail.Modify("centro_benef.Protect ='1~tIf(Not IsNull(cenbef_ot),1,0)'")
dw_detail.Modify("centro_benef.Background.color ='1~tIf(Not IsNull(cenbef_ot), RGB(192,192,192),RGB(255,255,255))'")

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

event ue_open_pre;call super::ue_open_pre;try 
	ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
	// ii_help = 101
	ib_log = TRUE
	
	if of_get_param() = 0 then 
		is_salir = 'S'
		post event closequery()   
		return
	end if
	
	if upper(gs_empresa) = 'SEAFROST' or gnvo_app.of_get_parametro("COMPRAS_OS_SIN_REFERENCIA", "1") = "0" then
		rb_sin_ref.visible = false
		rb_ref_ot.checked  = true
	else
		rb_sin_ref.visible 	= true
		rb_sin_ref.checked 	= true
		rb_ref_ot.checked 	= false
		rb_ref_ss.checked 	= false
		
	end if
	
	if is_flag_aut_os = '0' then
		cb_aprobar.visible = false
		cb_desaprobar.visible = false
	end if

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error en el evento ue_open_pre")
end try
	

end event

event ue_update_pre;Long ln_count, ll_row
// Verifica que campos son requeridos y tengan valores

ib_update_check = False

if is_action = 'open' then
	if f_row_Processing( dw_master, "form") <> true then 	return

end if
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle")
	return
end if

for ll_row = 1 to dw_detail.RowCount() 
	if dec(dw_Detail.object.impuesto [ll_row] ) > 0 and &
		(IsNull(dw_Detail.object.tipo_impuesto [ll_row]) or trim(dw_Detail.object.tipo_impuesto [ll_row]) = "") then
		
		f_mensaje("Error!, ha ingresado un monto de impuesto pero no ha indicado el tipo de impuesto", "CM_0001")
		dw_detail.SetColumn("tipo_impuesto")
		return 
	end if
	
	if dec(dw_Detail.object.impuesto2 [ll_row] ) > 0 and &
		(IsNull(dw_Detail.object.tipo_impuesto2 [ll_row]) or trim(dw_Detail.object.tipo_impuesto2 [ll_row]) = "") then
		
		f_mensaje("Error!, ha ingresado un monto de impuesto2 pero no ha indicado el tipo de impuesto2", "CM_0001")
		dw_detail.SetColumn("tipo_impuesto2")
		return 
	end if
next

// Verificacion de Fec Proyect en documento
//if of_verificar_fecha() = 0 then return

// Numeracion de documento
if of_set_numera() = 0 then return

of_set_total_os()

IF is_flag_req_serv = '1' then

	SELECT count(*) 
	  INTO :ln_count 
	  FROM comprador 
	 WHERE comprador = :gs_user AND flag_estado='1' ;
	
	IF ln_count = 0 THEN
		MESSAGEBOX('Aviso','Usted no esta autorizado a modificar OS de compra')
		RETURN
	END IF

END IF 

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

end event

on w_cm314_orden_servicios.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_imp_mail" then this.MenuID = create m_mtto_imp_mail
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.em_tb=create em_tb
this.em_dcto=create em_dcto
this.em_imp=create em_imp
this.em_tn=create em_tn
this.cb_1=create cb_1
this.rb_ref_ss=create rb_ref_ss
this.rb_sin_ref=create rb_sin_ref
this.st_ori=create st_ori
this.sle_ori=create sle_ori
this.st_nro=create st_nro
this.cb_buscar=create cb_buscar
this.rb_ref_ot=create rb_ref_ot
this.cb_aprobar=create cb_aprobar
this.cb_desaprobar=create cb_desaprobar
this.sle_nro=create sle_nro
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.em_tb
this.Control[iCurrent+6]=this.em_dcto
this.Control[iCurrent+7]=this.em_imp
this.Control[iCurrent+8]=this.em_tn
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.rb_ref_ss
this.Control[iCurrent+11]=this.rb_sin_ref
this.Control[iCurrent+12]=this.st_ori
this.Control[iCurrent+13]=this.sle_ori
this.Control[iCurrent+14]=this.st_nro
this.Control[iCurrent+15]=this.cb_buscar
this.Control[iCurrent+16]=this.rb_ref_ot
this.Control[iCurrent+17]=this.cb_aprobar
this.Control[iCurrent+18]=this.cb_desaprobar
this.Control[iCurrent+19]=this.sle_nro
this.Control[iCurrent+20]=this.gb_2
end on

on w_cm314_orden_servicios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.em_tb)
destroy(this.em_dcto)
destroy(this.em_imp)
destroy(this.em_tn)
destroy(this.cb_1)
destroy(this.rb_ref_ss)
destroy(this.rb_sin_ref)
destroy(this.st_ori)
destroy(this.sle_ori)
destroy(this.st_nro)
destroy(this.cb_buscar)
destroy(this.rb_ref_ot)
destroy(this.cb_aprobar)
destroy(this.cb_desaprobar)
destroy(this.sle_nro)
destroy(this.gb_2)
end on

event ue_print;call super::ue_print;str_parametros lstr_rep

IF dw_master.rowcount() = 0 then return

// Si esta anulado o sin VoBo no imprime
IF (dw_master.object.flag_estado[dw_master.getrow()])='0' OR &
   (dw_master.object.flag_estado[dw_master.getrow()])='3' THEN 
	RETURN
END IF

lstr_rep.string1 = dw_master.object.cod_origen	[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_os		[dw_master.getrow()]
OpenSheetWithParm(w_cm314_orden_servicio_frm, lstr_rep, This, 2, layered!)


end event

event ue_update;// Override

Boolean lbo_ok = TRUE
String  ls_crlf, ls_msg1, ls_msg2

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

IF ib_log THEN
	dw_master.of_Create_log()
	dw_detail.of_Create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg2 = "Se ha procedido al rollback"
		ls_msg1 = "Error en Grabacion Master"		
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
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	end if
END IF

IF lbo_ok THEN		
//	ROLLBACK USING SQLCA;
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	is_action = 'open'   
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	
	of_set_status_doc(idw_1)
	
	if dw_master.RowCount() > 0 then
		of_retrieve(dw_master.object.cod_origen [1], dw_master.object.nro_os [1])
	end if
	
	f_mensaje('Cambios guardados satisfactoriamente','')
ELSE
	ROLLBACK USING SQLCA;
	messagebox(ls_msg1, ls_msg2, StopSign!)	
END IF
end event

event ue_delete;// Override
Int li_count, li_row
String ls_nro_os
IF dw_master.rowcount() = 0 then return

if dw_master.object.FLAG_REQ_SERV[dw_master.getrow()] = '2' then
	MessageBox('Aviso', 'no puede Eliminar esta Orden de Servicio ya que generada x el sistema')
	return
end if

li_row = dw_master.GetRow()
ls_nro_os = dw_master.object.nro_os[li_row]

select count(*)
  into :li_count
  from fl_gtos_drcts_bahia_det a,
  		 orden_servicio_det b
where a.oper_sec = b.oper_sec
  and b.nro_os   = :ls_nro_os;

if li_count > 0 then
	MessageBox('Aviso', 'no puede anular esta Orden de Servicio fue generada por el MODULO DE FLOTA')
	return	
end if

if idw_1 = dw_master then 
	Messagebox( "Operacion no válida", "No se permite Eliminar este documento")	
	return 
end if

if dw_detail.rowcount() = 1 then
	messagebox( "Operacion no válida", "No se permite dejar el documento vacio")
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

IF is_action <> 'new' then	
	is_action = 'del'
	of_Set_Status_doc(dw_detail)
end if
end event

event ue_insert;// Override
Long  ll_row

if idw_1 = dw_master then 		
	// Verifica tipo de cambio
	in_tipo_cambio = gnvo_app.of_get_tipo_cambio( today() )
	
	if in_tipo_cambio = 0 THEN return
	dw_master.reset()
	dw_detail.Reset()
else
	IF dw_master.getrow() = 0 then return
	if dw_master.object.FLAG_REQ_SERV[dw_master.getrow()] = '2' then
		MessageBox('Aviso', 'no puede modificar esta Orden de Servicio ya que generada x el sistema')
		dw_master.ii_protect = 0 
		dw_master.of_protect()
	
		dw_detail.ii_protect = 0 
		dw_detail.of_protect()
	
		return
	end if
	
	if rb_ref_ss.checked = true or rb_ref_ot.checked = true then
		MessageBox('Aviso', 'No puede ingresar un item sin referencia cuando indica el tipo de referencia de SS o de OT, por favor verifique!', StopSign!)
		return
	end if
end if

ll_row = idw_1.Event ue_insert()
IF ll_row <> -1 THEN 
 	rb_sin_ref.enabled = true
	rb_ref_ot.enabled = true
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_modify;int 		li_protect, li_protect_sol, li_count, li_row
String	ls_nro_os

IF dw_master.rowcount() = 0 then return
li_row = dw_master.GetRow()

ls_nro_os = dw_master.object.nro_os[li_row]

//Verifico si existe datos en AP_PD_DESCARGA_DET
select count(*)
	into :li_count
from ap_pd_descarga_det
where nro_os = :ls_nro_os;

if li_count > 0 then
	MessageBox('Aviso', 'no puede modificar esta Orden de Servicio ya que generada desde APROVISIONAMIENTO')
	dw_master.ii_protect = 0 
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0 
	dw_detail.of_protect()
	
	return
end if


if dw_master.object.FLAG_REQ_SERV[li_row] = '2' then
	MessageBox('Aviso', 'no puede modificar esta Orden de Servicio ya que generada x el sistema')
	dw_master.ii_protect = 0 
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0 
	dw_detail.of_protect()
	
	return
end if

select count(*)
  into :li_count
  from fl_gtos_drcts_bahia_det a,
  		 orden_servicio_det b
where a.oper_sec = b.oper_sec
  and b.nro_os   = :ls_nro_os;

if li_count > 0 then
	MessageBox('Aviso', 'no puede anular esta Orden de Servicio fue generada por el MODULO DE FLOTA')
	return	
end if

// Hago Modificable los datawindow
dw_master.of_protect()
dw_detail.of_protect()

li_protect = integer(dw_master.Object.cod_origen.Protect)
IF li_protect = 0 THEN
   //dw_master.Object.cod_origen.Protect = 1
END IF

li_protect_sol = integer(dw_master.Object.nro_os.Protect)
IF li_protect = 0 THEN
   dw_master.Object.nro_os.Protect = 1
END IF

is_action = 'edit'

if rb_ref_ot.checked = true then   // Con referencia		
	of_bloquea_detalle()
end if

of_set_status_doc( idw_1)

// Si esta activo el flag de Presupuesto para que no eliga
// la cuenta presupuestal
if is_flag_cnta_prsp = '1' then
	dw_detail.object.cnta_prsp.protect = 1
	dw_detail.object.cnta_prsp.background.color = RGB(192,192,192)
end if

if dw_master.RowCount() > 0 then
	if dw_master.object.flag_estado[dw_master.GetRow()] = '1' and dw_master.ii_protect = 0 then
		rb_sin_ref.enabled = true
		rb_ref_ot.enabled = true
	else
		rb_sin_ref.enabled = false
		rb_ref_ot.enabled = false
	end if
end if


of_modify()
end event

event resize;// Override
 

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - em_tb.height - 20 //920 

em_tb.y 		= newheight - em_tb.height - 10
st_1.y 		= em_tb.y + 5

em_dcto.y 	= newheight - em_dcto.height - 10
st_2.y 		= em_dcto.y + 5

em_imp.y 	= newheight - em_imp.height - 10
st_3.y 		= em_imp.y + 5

em_tn.y 		= newheight - em_tn.height - 10
st_4.y 		= em_tn.y + 5
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_retrieve_list;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_sel_orden_servicio"
sl_param.titulo = "Ordenes de Servicio"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
END IF
end event

type dw_master from w_abc_mastdet`dw_master within w_cm314_orden_servicios
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 128
integer width = 3456
integer height = 1124
integer taborder = 50
string dataobject = "d_abc_orden_servicios_cm209"
boolean vscrollbar = false
end type

event dw_master::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cat_art, &
			ls_cod_art, ls_proveedor, ls_moneda, ls_banco, ls_ruc, ls_nom_rep

choose case lower(as_columna)
		
	case "proveedor"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor, " &
				  + "ruc AS ruc_proveedor " &
				  + "FROM proveedor " &
				  + "where flag_Estado = '1' " &
				  + "  and ((tipo_doc_ident = '6' " &
				  + "  and ruc is not null) " &
				  + "  or flag_personeria = 'E') "
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.object.ruc				[al_row] = ls_ruc
			
			//Obtengo el primer representante
			select nom_rep
				into :ls_nom_rep
			from representante 
			where proveedor = :ls_proveedor;
			
			this.object.nom_vendedor [al_row] = ls_nom_rep

			this.ii_update = 1
		end if

	case "job"
		ls_sql = "SELECT job AS CODIGO_job, " &
				  + "DESCripcion AS DESCRIPCION_job " &
				  + "FROM job " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
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

	CASE "direccion_item"					
			
		ls_proveedor = dw_master.object.proveedor [al_row]		
		IF Isnull(ls_proveedor) OR Trim(ls_proveedor)  = "" THEN
			Messagebox("Aviso","Debe Ingresar Codigo de Proveedor , Verifique!", StopSign!)
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
			this.object.direccion_item	[al_row] = Integer(ls_codigo)
			this.object.direccion		[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'md'
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_det = dw_detail
ii_ss = 1
end event

event dw_master::itemerror;call super::itemerror;return (1)   // Fuerza a salir sin mostrar mensaje de error
end event

event dw_master::ue_insert_pre;Long ln_count

this.object.fec_registro				[al_row] = gnvo_app.of_fecha_Actual()
this.object.cod_origen					[al_row] = gs_origen
this.object.uo_dst_pago					[al_row] = gs_origen
this.object.flag_solicita_acta		[al_row] = '0'
this.object.flag_proveedor_compra	[al_row] = '1'


if is_flag_aut_os = '1' then
	this.object.flag_estado		[al_row] = '3'		//Pendiente de aprobacion
else
	this.object.flag_estado		[al_row] = '1'		//Aprobado
end if
this.object.cod_usr			[al_row] = gs_user

// Coloca flag_req_serv, dependiendo si es comprador
SELECT count(*) 
	INTO :ln_count &
FROM comprador 
WHERE comprador = :gs_user 
  AND flag_estado='1' ;

IF ln_count > 0 THEN
	this.object.flag_req_serv	[al_row] = '1'
ELSE
	this.object.flag_req_serv	[al_row] = '0'
END IF 

// Logo
this.object.p_logo.filename = gs_logo

is_action = 'new'  // Nuevo documento

end event

event dw_master::clicked;call super::clicked;Long ln_count
String ls_flag_req_serv
// Bloquea el flag_req_serv, dependiendo del usuario

SELECT count(*) 
  INTO :ln_count 
  FROM comprador 
 WHERE comprador = :gs_user AND flag_estado='1' ;

IF ln_count > 0 THEN
	this.Modify("flag_req_serv.Protect=0")
ELSE
	this.Modify("flag_req_serv.Protect=1")
END IF 

IF row > 0 THEN
	// Verifica si usuario puede modificar algun dato
	is_flag_req_serv = this.object.flag_req_serv[row]
END IF

end event

event dw_master::buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 
String ls_prot, ls_provee
str_parametros sl_param

ls_prot = this.Describe( "proveedor.Protect")
if ls_prot = '1' then return

if dwo.name = 'b_vendedor' then
	// Verificar que codigo de proveedor se halla ingresado
	ls_provee = dw_master.object.proveedor[dw_master.getrow()]
	if isnull( ls_provee) or TRIM( ls_provee) = '' then
		Messagebox( "Atencion", "Ingresar proveedor", Exclamation!)
		dw_master.Setcolumn( 1)
		return
	end if
	
	sl_param.dw1 = "d_abc_representante_tbl"
	sl_param.titulo = "Representantes"
	sl_param.field_ret_i[1] = 3		
	sl_param.tipo = '1S'
	sl_param.string1 = ls_provee

	OpenWithParm( w_lista, sl_param)
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then
		this.object.nom_vendedor[this.getrow()] = LEFT(sl_param.field_ret[1],40)
		ii_update = 1		// activa flag de modificado
	END IF
end if
end event

event dw_master::itemchanged;call super::itemchanged;Long ln_count
String 	ls_desc, ls_null, ls_proveedor, ls_moneda, ls_banco, ls_ruc, ls_nom_rep
Integer	li_item

SetNull(ls_null)

if dwo.name = 'proveedor' then
	Select nom_proveedor, ruc
		into :ls_desc, :ls_ruc
	from proveedor 
	where proveedor = :data
	  and flag_estado = '1'
	  and tipo_doc_ident = '6'
	  and ruc is not null;
	
	if sqlca.sqlcode = 100 then
		Messagebox( "Error", "Proveedor no existe, no esta activo o no tiene RUC asignado")
		this.object.proveedor		[row] = ls_null
		this.object.nom_proveedor	[row] = ls_null
		this.object.ruc				[row] = ls_ruc
		Return 1
	end if
	this.object.nom_proveedor	[row] = ls_desc
	this.object.ruc				[row] = ls_ruc
	
	//Obtengo el primer representante
	select nom_rep
		into :ls_nom_rep
	from representante 
	where proveedor = :ls_proveedor;
	
	this.object.nom_vendedor [row] = ls_nom_rep


elseif dwo.name = 'cod_moneda' then
	this.object.cod_banco 	[row] = ls_null
	this.object.nom_banco 	[row] = ls_null
	this.object.nro_cuenta 	[row] = ls_null
	of_banco_prov( )

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

elseif dwo.name = 'direccion_item' then
	
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
		this.object.direccion_item [row] = gnvo_app.ii_null
		this.object.direccion		[row] = gnvo_app.is_null
		return 1
	end if
	
	this.object.direccion [row] = ls_desc
	
end if

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

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_detail from w_abc_mastdet`dw_detail within w_cm314_orden_servicios
integer x = 0
integer y = 1272
integer width = 3762
integer height = 556
integer taborder = 70
string dataobject = "d_abc_orden_servicio_det1_cm209"
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'	

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que se pasan al detalle
ii_rk[2] = 2

is_dwform = 'tabular'	
idw_mst  = 	dw_master
idw_det  =  dw_detail
end event

event dw_detail::itemerror;call super::itemerror;return (1)
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro	[al_row] = f_fecha_actual()
this.object.fec_proyect		[al_row] = gd_fecha
this.object.cod_origen		[al_row] = gs_origen

if is_flag_aut_os = '1' then
	this.object.flag_estado		[al_row] = '3'		//Pendiente de aprobacion
else
	this.object.flag_estado		[al_row] = '1'		//Aprobado
end if

this.object.importe				[al_row] = 0
this.object.decuento				[al_row] = 0
this.object.impuesto				[al_row] = 0
this.object.impuesto2			[al_row] = 0
this.object.imp_provisionado	[al_row] = 0
this.object.cod_origen			[al_row] = dw_master.object.cod_origen	[dw_master.GetRow()]
this.object.nro_os				[al_row] = dw_master.object.nro_os		[dw_master.GetRow()]

this.object.nro_item[al_row] = f_numera_item(dw_detail)

if is_action = 'new' then
	if rb_ref_ot.checked = true then   // Con referencia
		rb_sin_ref.enabled = false
		of_bloquea_detalle()
	else
		rb_sin_ref.enabled = true
	end if
end if

if is_action = 'open' then
   is_action = 'adic'
	of_set_status_doc( dw_detail)
end if

// Si esta activo el flag de Presupuesto para que no eliga
// la cuenta presupuestal
if is_flag_cnta_prsp = '1' then
	this.object.cnta_prsp.protect = 1
	this.object.cnta_prsp.background.color = RGB(192,192,192)
end if

// Si el flag de Centro de Beneficio esta activo entonces
// Debo pedir obligatoriamente un centro de beneficio
if is_flag_cenbef = '1' then
	this.object.centro_benef.edit.required = 'Yes'
end if

of_modify()

end event

event dw_detail::clicked;call super::clicked;of_set_status_doc(this)		// Verifica status de documento

// Abre ventana de ayuda 
//str_seleccionar lstr_seleccionar
String ls_name, ls_prot

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_name = 'fec_requerida' and ls_prot = '0' then
	Datawindow ldw

	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
end if

end event

event dw_detail::getfocus;call super::getfocus;IF is_Action <> 'open' then
	wf_verifica_datos()
END IF
end event

event dw_detail::itemchanged;call super::itemchanged;Long 		ll_count, ln_mes, ll_null
String 	ls_null, ls_servicio, ls_estado, ls_cencos, ls_moneda, &
			ls_signo, ls_impuesto, ls_cnta_prsp, ls_data, ls_oper_sec
Date 		ld_fecdig, ld_fecproy, ld_fecreg
decimal	ldc_tasa_impuesto, ldc_importe, ldc_descuento, ldc_impuesto, &
			ldc_importe_aprobado
Long 		ll_row_mas, ll_ano

ll_row_mas = dw_master.GetRow()
if ll_row_mas = 0 then return

setnull( ls_null)
SetNull( ll_null)
This.AcceptText()

ld_fecreg = DATE( dw_master.object.fec_registro[ll_row_mas])
ls_moneda = dw_master.object.cod_moneda[ll_row_mas]

if ls_moneda = '' or IsNull(ls_moneda) then 
	MessageBox('Aviso', 'Defina el tipo de moneda')
	return
end if


if dwo.name = 'fec_proyect' then
	// evalua que fecha proyectada no sea menor a la fec. de registro en 10 dias		
	ld_fecdig = date(this.object.fec_proyect[row])	// Fecha digitada
	ld_fecproy = DATE( dw_master.object.fec_registro[ll_row_mas])

	if ld_fecdig < RelativeDate(ld_fecproy, il_dias_retrazo_os * -1) then
		messagebox( "Error", 'Operacion no permitida' &
			+ '~rFecha proyectada no debe ser menor a fecha registro ' &
			+ 'en ' + string(il_dias_retrazo_os) + ' dias')
			
		this.object.fec_proyect[row] = RelativeDate(ld_fecproy, il_dias_retrazo_os * -1)
		this.SetItemStatus(row, "fec_proyect", Primary!, DataModified!)
		return 1
	end if
	
elseif dwo.name = 'cencos' then
	
	ll_ano = YEAR(Date(this.object.fec_proyect[row]))
	
	if is_flag_restr_cencos_usr = '0' then
	
		Select distinct cc.flag_estado 
			into :ls_estado 
		from 	centros_costo 			cc,
				presupuesto_partida 	pp
		where cc.cencos = pp.cencos
		  and pp.flag_estado <> '0'
		  and NVL(pp.flag_cmp_directa, '') <> '0'
		  and pp.ano 		= :ll_ano
		  and cc.cencos 	= :data;		
	else
		Select distinct cc.flag_estado 
			into :ls_estado 
		from 	centros_costo 			cc,
				presupuesto_partida 	pp,
				presup_usr_autorizdos  pua
		where cc.cencos = pp.cencos
		  and pua.cencos = cc.cencos
		  and pp.flag_estado <> '0'
		  and NVL(pp.flag_cmp_directa, '') <> '0'
		  and pp.ano 		= :ll_ano
		  and pua.cod_usr = :gs_user
		  and cc.cencos 	= :data;		
	end if
	
	if SQLCA.SQLCode = 100 then
		if is_flag_cnta_prsp = '0' then
			Messagebox( "Error", "Centro de costo no existe, " &
				+ "no tiene una partida presupuestal activa, o " &
				+ "la partida presupuestal no es de compra directa" &
				+ "~r~n Año: " + string(ll_ano))
		else
			Messagebox( "Error", "Centro de costo no existe, " &
				+ "no tiene una partida presupuestal activa, o " &
				+ "la partida presupuestal no es de compra directa o " &
				+ "no tiene acceso a este centro de costo" &
				+ "~r~n Año: " + string(ll_ano))
		end if
		this.object.cencos[row] = ls_null
		Return 1
	end if
	
   if ls_estado <> '1' then
		Messagebox( "Error", "Centro de costo esta desactivado", Exclamation!)		
		this.object.cencos[row] = ls_null
		Return 1
	end if
	
	is_cencos = data
	
elseif dwo.name = "cnta_prsp" then

	ll_ano = YEAR(DAte(this.object.fec_proyect[row]))
	ls_cencos = this.object.cencos [row]
	
	if IsNull(ls_cencos) or ls_cencos = '' then return 
	
	//Verifica que exista dato ingresado	
	Select count( pc.cnta_prsp ) 
		into :ll_count 
	from 	presupuesto_cuenta 	pc,
			presupuesto_partida	pp
	where pp.cnta_prsp = pc.cnta_prsp
	  and pp.flag_estado <> '0'
	  and NVL(pp.flag_cmp_directa, '') <> '0'
	  and pp.ano 		 = :ll_ano
	  and pp.cencos 	 = :ls_cencos
	  and pp.cnta_prsp = :data;
	
	if ll_count = 0 then
		Messagebox( "Error", "Cuenta presupuestal no existe, " &
			+ "no tiene partida presupuestal activa, " &
			+ "o la partida presupuestal no es de compra directa")
		this.object.cnta_prsp[row] = ls_null		
		Return 1		
	end if
	is_cnta_prsp = data	

elseif dwo.name = "cod_maquina" then
	// Verifica que codigo exista
	Select count(cod_maquina) 
		into :ll_count 
	from maquina
	Where cod_maquina = :data
	  and flag_estado = '1'
	  and nivel 		= 4;
	  
	if ll_count = 0 then			
		Messagebox( "Atencion", "Código de maquina no existe, no esta activo o no pertenece al nivel 4, por favor coordinar con Mantenimiento / Taller", Exclamation!)
		this.object.cod_maquina[row] = gnvo_app.is_null
		return 1
	end if	
	
elseif dwo.name = "servicio" then
	
	//Verifica que exista dato ingresado	
	SELECT a.descripcion, b.cnta_prsp_egreso
		into :ls_servicio, :ls_cnta_prsp
	FROM 	servicios a, 
			articulo_sub_categ b 
	WHERE a.cod_sub_cat = b.cod_sub_cat (+) 
	  and a.flag_estado = '1'
	  and a.servicio = :data;
	
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Codigo de Servicio no existe o no esta activo", Exclamation!)
		this.object.servicio		 [row] = ls_null		
		this.object.desc_servicio[row] = ls_null		
		Return 1		
	end if
	
	if is_flag_cnta_prsp = '1' or is_flag_tipo_serv = '1' then
		if ls_cnta_prsp = '' or IsNull(ls_cnta_prsp) then
			MessageBox('Aviso','El tipo de servicio no esta relacionado a ninguna Cuenta Presupuestal')
			return 1
		end if
	end if
	
	this.object.desc_servicio	[row] = ls_servicio
	
	if is_flag_tipo_serv = '1' or is_flag_cnta_prsp = '1' then
		this.object.cnta_prsp		[row] = ls_cnta_prsp
	end if
	
elseif dwo.name = 'importe' then
	
	in_new_importe = REAL( data )
	
	if is_FLAG_VALIDA_LIMITE_OS = '1' then
		// Primero veo si viene de un oper_sec
		
		ls_oper_sec = this.object.oper_sec[row]
		if Not IsNull(ls_oper_sec) and ls_oper_sec <> '' then
		
			// Valido que el importe no supere el monto proyectado
			ldc_importe_aprobado = Dec(this.object.importe_aprobado[row])
			if IsNull(ldc_importe_aprobado) then ldc_importe_aprobado = 0
			
			if ldc_importe_aprobado > 0 then
				//Valido siempre y cuando el importe aprobado sea mayor que cero
				if in_new_importe > ldc_importe_aprobado then
					MessageBox('Aviso', 'El importe no puede superar al importe aprobado de ' &
							+ string(ldc_importe_aprobado))
					in_new_importe = 0
					this.object.importe		[row] = 0
					this.object.decuento		[row] = 0
					this.object.impuesto		[row] = 0
					this.object.impuesto2	[row] = 0
					return 1
				end if
			end if
		end if
	end if

	// Recalculando el Descuento
	if not isnull(this.object.descto[row]) then
		ldc_descuento = Dec(this.object.descto[row])
		this.object.decuento[row] = Dec(this.object.importe[row] * ( Dec(ldc_descuento) /100))
	end if
	
	// Recalculando el primer impuesto
	ls_impuesto = this.object.tipo_impuesto[row]
	if Not IsNull(ls_impuesto) and ls_impuesto <> '' then
		
		select tasa_impuesto, signo
			into :ldc_tasa_impuesto, :ls_signo
		from impuestos_tipo
		where tipo_impuesto = :ls_impuesto;
		
		if SQLCA.SQLCode = 100 then 
			MessageBox('Aviso', 'Debe ingresar un tipo de impuesto valido')
			return 1
		end if
		
		if IsNull(ldc_tasa_impuesto) then ldc_tasa_impuesto = 0
		
		ldc_impuesto = (this.object.importe[row] - this.object.decuento[row]) * ( ldc_tasa_impuesto /100)
		
		if ls_signo = '+' then
			this.object.impuesto[row] = ldc_impuesto
		else
			this.object.impuesto[row] = ldc_impuesto * -1
		end if
	end if
	
	//Recalculando el segundo impuesto
	ls_impuesto = this.object.tipo_impuesto2[row]
	
	if Not IsNull(ls_impuesto) and ls_impuesto <> '' then
		if IsNull(this.object.tipo_impuesto[row]) or trim(this.object.tipo_impuesto[row]) = '' then
			MessageBox('Aviso', 'Debe ingresar un tipo de impuesto 1')
			return 1
		end if
		
		select tasa_impuesto, signo
			into :ldc_tasa_impuesto, :ls_signo
		from impuestos_tipo
		where tipo_impuesto = :ls_impuesto;
		
		if SQLCA.SQLCode = 100 then 
			MessageBox('AViso', 'Debe ingresar un tipo de impuesto valido')
			return 1
		end if
		
		if IsNull(ldc_tasa_impuesto) then ldc_tasa_impuesto = 0
		
		ldc_impuesto = (this.object.importe[row] - this.object.decuento[row]) * ( ldc_tasa_impuesto /100)
		
		if ls_signo = '+' then
			this.object.impuesto2[row] = ldc_impuesto
		else
			this.object.impuesto2[row] = ldc_impuesto * -1
		end if
	end if
	
	of_set_total_os()
	
elseif dwo.name = 'descto' then
	
	if not isnull(data) then
		ldc_descuento = Dec(this.object.importe[row] * ( Dec(data) /100))
		if ldc_descuento > Dec(this.object.importe[row]) then
			MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
			this.object.descto	[row] = 0
			this.object.decuento	[row] = 0
			return 1
		end if
		this.object.decuento[row] = ldc_descuento
	end if

	// Recalculando el primer impuesto
	ls_impuesto = this.object.tipo_impuesto[row]
	if Not IsNull(ls_impuesto) and ls_impuesto <> '' then
		
		select tasa_impuesto, signo
			into :ldc_tasa_impuesto, :ls_signo
		from impuestos_tipo
		where tipo_impuesto = :ls_impuesto;
		
		if SQLCA.SQLCode = 100 then 
			MessageBox('AViso', 'Debe ingresar un tipo de impuesto valido')
			return 1
		end if
		
		if IsNull(ldc_tasa_impuesto) then ldc_tasa_impuesto = 0
		
		ldc_impuesto = (this.object.importe[row] - this.object.decuento[row]) * ( ldc_tasa_impuesto /100)
		
		if ls_signo = '+' then
			this.object.impuesto[row] = ldc_impuesto
		else
			this.object.impuesto[row] = ldc_impuesto * -1
		end if
	end if
	
	//Recalculando el segundo impuesto
	ls_impuesto = this.object.tipo_impuesto2[row]
	
	if Not IsNull(ls_impuesto) and ls_impuesto <> '' then
		if IsNull(this.object.tipo_impuesto[row]) or trim(this.object.tipo_impuesto[row]) = '' then
			MessageBox('Aviso', 'Debe ingresar un tipo de impuesto 1')
			return 1
		end if
		
		select tasa_impuesto, signo
			into :ldc_tasa_impuesto, :ls_signo
		from impuestos_tipo
		where tipo_impuesto = :ls_impuesto;
		
		if SQLCA.SQLCode = 100 then 
			MessageBox('AViso', 'Debe ingresar un tipo de impuesto valido')
			return 1
		end if
		
		if IsNull(ldc_tasa_impuesto) then ldc_tasa_impuesto = 0
		
		ldc_impuesto = (this.object.importe[row] - this.object.decuento[row]) * ( ldc_tasa_impuesto /100)
		
		if ls_signo = '+' then
			this.object.impuesto2[row] = ldc_impuesto
		else
			this.object.impuesto2[row] = ldc_impuesto * -1
		end if
	end if
	
	
	of_set_total_os()
	
elseif dwo.name = 'decuento' then
	
	if not isnull(data) then
		ldc_descuento = Dec(data)
		if ldc_descuento > Dec(this.object.importe[row]) then
			MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
			this.object.descto	[row] = 0
			this.object.decuento	[row] = 0
			return 1
		end if
		this.object.descto[row] = round(Dec(data)/Dec(this.object.importe[row]) * 100,2)
	end if

	// Recalculando el primer impuesto
	ls_impuesto = this.object.tipo_impuesto[row]
	if Not IsNull(ls_impuesto) and ls_impuesto <> '' then
		
		select tasa_impuesto, signo
			into :ldc_tasa_impuesto, :ls_signo
		from impuestos_tipo
		where tipo_impuesto = :ls_impuesto;
		
		if SQLCA.SQLCode = 100 then 
			MessageBox('AViso', 'Debe ingresar un tipo de impuesto valido')
			return 1
		end if
		
		if IsNull(ldc_tasa_impuesto) then ldc_tasa_impuesto = 0
		
		ldc_impuesto = (this.object.importe[row] - this.object.decuento[row]) * ( ldc_tasa_impuesto /100)
		
		if ls_signo = '+' then
			this.object.impuesto[row] = ldc_impuesto
		else
			this.object.impuesto[row] = ldc_impuesto * -1
		end if
	end if
	
	//Recalculando el segundo impuesto
	ls_impuesto = this.object.tipo_impuesto2[row]
	
	if Not IsNull(ls_impuesto) and ls_impuesto <> '' then
		if IsNull(this.object.tipo_impuesto[row]) or trim(this.object.tipo_impuesto[row]) = '' then
			MessageBox('Aviso', 'Debe ingresar un tipo de impuesto 1')
			return 1
		end if
		
		select tasa_impuesto, signo
			into :ldc_tasa_impuesto, :ls_signo
		from impuestos_tipo
		where tipo_impuesto = :ls_impuesto;
		
		if SQLCA.SQLCode = 100 then 
			MessageBox('AViso', 'Debe ingresar un tipo de impuesto valido')
			return 1
		end if
		
		if IsNull(ldc_tasa_impuesto) then ldc_tasa_impuesto = 0
		
		ldc_impuesto = (this.object.importe[row] - this.object.decuento[row]) * ( ldc_tasa_impuesto /100)
		
		if ls_signo = '+' then
			this.object.impuesto2[row] = ldc_impuesto
		else
			this.object.impuesto2[row] = ldc_impuesto * -1
		end if
	end if
	
	of_set_total_os()
	
elseif dwo.name = 'tipo_impuesto' then
	
	select tasa_impuesto, signo
		into :ldc_tasa_impuesto, :ls_signo
	from impuestos_tipo
	where tipo_impuesto = :data;
	
	if SQLCA.SQLCode = 100 then 
		MessageBox('AViso', 'Debe ingresar un tipo de impuesto valido')
		return 1
	end if
	
	if IsNull(ldc_tasa_impuesto) then ldc_tasa_impuesto = 0
	
	ldc_impuesto = (this.object.importe[row] - this.object.decuento[row]) * ( ldc_tasa_impuesto /100)
	
	if ls_signo = '+' then
		this.object.impuesto[row] = ldc_impuesto
	else
		this.object.impuesto[row] = ldc_impuesto * -1
	end if
	
	of_set_total_os()
	
elseif dwo.name = 'tipo_impuesto2' then
	
	if IsNull(this.object.tipo_impuesto[row]) or trim(this.object.tipo_impuesto[row]) = '' then
		MessageBox('Aviso', 'Debe ingresar un tipo de impuesto 1')
		return 1
	end if
	
	select tasa_impuesto, signo
		into :ldc_tasa_impuesto, :ls_signo
	from impuestos_tipo
	where tipo_impuesto = :data;
	
	if SQLCA.SQLCode = 100 then 
		MessageBox('AViso', 'Debe ingresar un tipo de impuesto valido')
		return 1
	end if
	
	if IsNull(ldc_tasa_impuesto) then ldc_tasa_impuesto = 0
	
	ldc_impuesto = (this.object.importe[row] - this.object.decuento[row]) * ( ldc_tasa_impuesto /100)
	
	if ls_signo = '+' then
		this.object.impuesto2[row] = ldc_impuesto
	else
		this.object.impuesto2[row] = ldc_impuesto * -1
	end if
	
	of_set_total_os()
	
elseif dwo.name = 'centro_benef' then
	select a.desc_centro
		into :ls_data
	from centro_beneficio a
	where a.centro_benef = :data
	  and a.flag_estado 	= '1';
	
	if SQLCA.SQLCode = 100 then
		Messagebox('Aviso', "Código de Centro de Beneficio no existe, no está activo, por favor verifique", StopSign!)
		this.object.centro_benef	[row] = ls_null
		this.object.desc_centro		[row] = ls_null
		return 1
	end if
	
	this.object.desc_centro [row] = ls_data
	
end if

// Evalua presupuesto.	
if dw_master.object.cod_moneda[dw_master.getrow()] = is_soles then	
	if in_tipo_cambio = 0 then return
	in_new_importe = in_new_importe / in_tipo_cambio
end if

ln_mes = Month( DAte( this.object.fec_proyect[row]) )
ll_ano = Year( Date(this.object.fec_proyect [row]) )

if is_cencos = '' or is_cnta_prsp = '' then return

// Verifico que la partida presupuestal sea de compra directa
if f_prsp_cmp_directa( is_cencos, is_cnta_prsp, ll_ano) = '0' then
	MessageBox('Aviso', 'La Partida Presupuestal no es de compra directa')
	dw_detail.object.cnta_prsp	[row] = ls_null
	dw_detail.object.importe	[row] = ll_null		
	in_new_importe = 0
	dw_detail.SetColumn( "cnta_prsp")
	RETURN 1
end if
	
of_set_total_os()
end event

event dw_detail::ue_display;call super::ue_display;// Abre ventana de ayuda 
String 	ls_provee, ls_sql, ls_codigo, ls_data, ls_cencos, &
			ls_cnta_prsp, ls_string, ls_nivel
Long 		ll_ano, ll_mes
decimal	ldc_tasa_impuesto
boolean 	lb_ret

str_parametros 	lstr_param
Str_seleccionar 	lstr_seleccionar
w_rpt_preview		lw_1
str_maquinas		lstr_maquina

if lower(as_columna) = 'cencos' then
	
	ll_ano = YEAR( DATE(this.object.fec_proyect[al_row] ))
	if is_flag_restr_cencos_usr = '0' then
		ls_sql = "SELECT distinct cc.cencos AS CODIGO_cencos, " &
				 + "cc.DESC_cencos AS DESCRIPCION_cencos " &
				 + "FROM centros_costo cc, " &
				 + "presupuesto_partida pp " &
				 + "WHERE pp.cencos = cc.cencos " &
				 + "AND pp.flag_estado <> '0' " &
				 + "AND cc.flag_estado <> '0' " &
				 + "AND NVL(pp.flag_cmp_directa,'') <> '0' " &
				 + "AND pp.ano = " + string(ll_ano) + " " &
				 + "ORDER BY DESC_CENCOS "
	else
		ls_sql = "SELECT distinct cc.cencos AS CODIGO_cencos, " &
				 + "cc.DESC_cencos AS DESCRIPCION_cencos " &
				 + "FROM centros_costo cc, " &
				 + "presupuesto_partida pp, " &
				 + "presup_usr_autorizados pua, " &
				 + "WHERE pp.cencos = cc.cencos " &
				 + "AND pua.cencos = cc.cencos " &
				 + "AND pua.cod_usr = '" + gs_user + "' " &
				 + "AND pp.flag_estado <> '0' " &
				 + "AND cc.flag_estado <> '0' " &
				 + "AND NVL(pp.flag_cmp_directa,'') <> '0' " &
				 + "AND pp.ano = " + string(ll_ano) + " " &
				 + "ORDER BY DESC_CENCOS "
	end if
				 
	lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
	if ls_codigo <> '' then
		this.object.cencos			[al_row] = ls_codigo
		is_cencos = ls_codigo
		this.ii_update = 1
	end if
	
elseif lower(as_columna) = 'cnta_prsp' then
	ls_cencos = this.object.cencos[al_row]
	ll_ano = YEAR( DATE(this.object.fec_proyect[al_row] ))
	
	ls_sql = "SELECT distinct pc.cnta_prsp AS CODIGO_cnta_prsp, " &
			 + "pc.DESCripcion AS DESCRIPCION_cnta_prsp " &
			 + "FROM presupuesto_cuenta pc, " &
			 + "presupuesto_partida pp " &
			 + "WHERE pp.cnta_prsp = pc.cnta_prsp " &
			 + "AND pp.flag_estado <> '0' " &
			 + "AND NVL(pp.flag_cmp_directa,'') <> '0' " &
			 + "AND pp.cencos = '" + ls_cencos + "' " &
			 + "AND pp.ano = " + string(ll_ano) + " " &
			 + "ORDER BY pc.cnta_prsp "
				 
	lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
	if ls_codigo <> '' then
		this.object.cnta_prsp			[al_row] = ls_codigo
		is_cnta_prsp = ''
		this.ii_update = 1
	end if

elseif lower(as_columna) = 'cod_maquina' then
	lstr_maquina = gnvo_app.of_get_maquina()
	
	if lstr_maquina.b_return then
		this.object.cod_maquina	[al_row] = lstr_maquina.cod_maquina
		this.ii_update = 1
	end if
	return
			
elseif lower(as_columna) = 'servicio' then
	ls_sql = "SELECT a.servicio AS CODIGO_sub_categ, " &
       	 + "a.descripcion AS DESC_servicio, " &
	       + "b.cnta_prsp_egreso as cnta_prsp " &
			 + "FROM servicios a, " &
			 + "articulo_sub_categ b " &
			 + "WHERE a.cod_sub_cat = b.cod_sub_cat (+) " &
			 + "and a.flag_estado = '1' " &
			 + "ORDER BY a.servicio "
				 
	lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_cnta_prsp, '2')
		
	if ls_codigo <> '' then
		if is_flag_cnta_prsp = '1' then
			if ls_cnta_prsp = '' or IsNull(ls_cnta_prsp) then
				MessageBox('Aviso', 'Debe definir cnta_prsp en Subcategoria de servicio')
				return
			end if
		end if
		
		this.object.servicio			[al_row] = ls_codigo
		this.object.desc_servicio	[al_row] = ls_data
		if is_flag_tipo_serv = '1' or is_flag_cnta_prsp = '1' then
			this.object.cnta_prsp		[al_row] = ls_cnta_prsp
		end if
		this.ii_update = 1
	end if	
	
elseif lower(as_columna) = 'tipo_impuesto' then
	
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_column 	  = '2'
	lstr_seleccionar.s_sql = "SELECT IMPUESTOS_TIPO.TIPO_IMPUESTO AS CODIGO_TIPO         , " &
			        + "IMPUESTOS_TIPO.DESC_IMPUESTO AS DESCRIPCION_IMPUESTO, " &
					  + "IMPUESTOS_TIPO.TASA_IMPUESTO AS PORCENTAJE          , " &					  
			        + "IMPUESTOS_TIPO.SIGNO			 AS FACTOR                " &
  		           + "FROM IMPUESTOS_TIPO " 
				
	OpenWithParm(w_seleccionar,lstr_seleccionar)
				
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		Setitem(al_row,'tipo_impuesto',lstr_seleccionar.param1[1])
		
		
		IF lstr_seleccionar.param4[1] = '+' THEN
			this.object.impuesto	[al_row] = ( this.object.importe[al_row] - this.object.decuento[al_row]) * ( lstr_seleccionar.paramdc3[1] /100)
		ELSE
			this.object.impuesto [al_row] = (( this.object.importe[al_row] - this.object.decuento[al_row]) * ( lstr_seleccionar.paramdc3[1] /100))	* - 1		
		END IF
		
		this.ii_update = 1
	END IF
	
	of_set_total_os()

elseif lower(as_columna) = 'tipo_impuesto2' then
	
	if IsNull(this.object.tipo_impuesto[al_row]) or trim(this.object.tipo_impuesto[al_row]) = '' then
		MEssageBox('Aviso', 'Debe indicar primero el tipo de impuesto 1')
		return
	end if
	
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_column 	  = '2'
	lstr_seleccionar.s_sql = "SELECT IMPUESTOS_TIPO.TIPO_IMPUESTO AS CODIGO_TIPO         , " &
			        + "IMPUESTOS_TIPO.DESC_IMPUESTO AS DESCRIPCION_IMPUESTO, " &
					  + "IMPUESTOS_TIPO.TASA_IMPUESTO AS PORCENTAJE          , " &					  
			        + "IMPUESTOS_TIPO.SIGNO			 AS FACTOR                " &
  		           + "FROM IMPUESTOS_TIPO " 
				
	OpenWithParm(w_seleccionar,lstr_seleccionar)
				
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		Setitem(al_row,'tipo_impuesto2',lstr_seleccionar.param1[1])
		
		IF lstr_seleccionar.param4[1] = '+' THEN
			this.object.impuesto2 [al_row] = ( this.object.importe[al_row] - this.object.decuento[al_row]) * ( lstr_seleccionar.paramdc3[1] /100)
		ELSE
			this.object.impuesto2 [al_row] = (( this.object.importe[al_row] - this.object.decuento[al_row]) * ( lstr_seleccionar.paramdc3[1] /100))	* - 1		
		END IF
		this.ii_update = 1
	END IF
	
	of_set_total_os()
	
elseif lower(as_columna) = 'confin' then
	lstr_param.tipo			= ''
	lstr_param.opcion		= 3
	lstr_param.titulo 		= 'Selección de Concepto Financiero'
	lstr_param.dw_master	= 'd_lista_grupo_financiero_grd' //Filtrado para cierto grupo
	lstr_param.dw1			= 'd_lista_concepto_financiero_grd'
	lstr_param.dw_m			=  This
	OpenWithParm( w_abc_seleccion_md, lstr_param)
	If IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return
	
	lstr_param = message.PowerObjectParm			
	
	IF lstr_param.titulo = 's' THEN
		This.ii_update = 1
	END IF
	
elseif lower(as_columna) = 'centro_benef' then
	ls_sql = "SELECT a.centro_benef AS CODIGO_CenBef, " &
		  + "a.desc_centro AS DESCRIPCION_centro_benef " &
		  + "FROM centro_beneficio a " &
		  + "where a.flag_estado = '1' " &
		  + "and a.flag_estructura = '0'"
			 
	f_lista(ls_sql, ls_codigo, ls_data, '1')
	
	if ls_codigo <> '' then
		this.object.centro_benef[al_row] = ls_codigo
		this.object.desc_centro	[al_row] = ls_data
		this.ii_update = 1
	end if

end if	

// Evalua presupuesto.	
if dw_master.object.cod_moneda[dw_master.getrow()] = is_soles then	
	if in_tipo_cambio = 0 then return
	in_new_importe = in_new_importe / in_tipo_cambio
end if

ll_mes = Month( DAte( this.object.fec_proyect[al_row]) )
ll_ano = Year( Date(this.object.fec_proyect [al_row]) )

if is_cencos = '' or is_cnta_prsp = '' then return

// Verifico que la partida presupuestal sea de compra directa
if f_prsp_cmp_directa( is_cencos, is_cnta_prsp, ll_ano) = '0' then
	MessageBox('Aviso', 'La Partida Presupuestal no es de compra directa')
	this.object.cnta_prsp	[al_row] = gnvo_app.is_null
	this.object.importe		[al_row] = gnvo_app.il_null		
	in_new_importe = 0
	this.SetColumn( "cnta_prsp")
	RETURN 
end if
	
of_set_total_os()
end event

event dw_detail::doubleclicked;call super::doubleclicked;string 			ls_columna, ls_string, ls_evaluate
str_parametros lstr_param
w_rpt_preview 	lw_1

THIS.AcceptText()

if lower(dwo.name) = 'imp_provisionado' then

	lstr_param.dw1 		= 'd_art_factura_os_tbl'
	lstr_param.string1 	= this.object.nro_os		[row]
	lstr_param.long1 		= Long(this.object.nro_item	[row])
	lstr_param.titulo		= 'Facturas asociadas a la provision de la Orden de Servicio'
	lstr_param.tipo 		= '1S1L'

	OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )
	
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

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event dw_detail::buttonclicked;call super::buttonclicked;str_parametros	lstr_param

if row = 0 then return

try 
	
	if lower(dwo.name) = 'b_descripcion' then
		
		If this.is_protect("descripcion", row) then RETURN
		
		// Para la descripcion de la Factura
		lstr_param.string1   = 'Detalle del servicio '
		lstr_param.string2	 = this.object.descripcion [row]
	
		OpenWithParm( w_descripcion_fac, lstr_param)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
				This.object.descripcion [row] = left(lstr_param.string3, 2000)
				this.ii_update = 1
		END IF	
	end if

catch ( exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al hacer click en boton en el DAtaWindow Maestro")


end try

end event

type st_1 from statictext within w_cm314_orden_servicios
integer x = 55
integer y = 1956
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Total Bruto:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm314_orden_servicios
integer x = 928
integer y = 1956
integer width = 343
integer height = 56
boolean bringtotop = true
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

type st_3 from statictext within w_cm314_orden_servicios
integer x = 1737
integer y = 1956
integer width = 343
integer height = 56
boolean bringtotop = true
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

type st_4 from statictext within w_cm314_orden_servicios
integer x = 2546
integer y = 1956
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Total Neto:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_tb from editmask within w_cm314_orden_servicios
integer x = 407
integer y = 1944
integer width = 471
integer height = 84
integer taborder = 90
boolean bringtotop = true
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
end type

type em_dcto from editmask within w_cm314_orden_servicios
integer x = 1280
integer y = 1944
integer width = 471
integer height = 84
integer taborder = 100
boolean bringtotop = true
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
end type

type em_imp from editmask within w_cm314_orden_servicios
integer x = 2094
integer y = 1944
integer width = 471
integer height = 84
integer taborder = 110
boolean bringtotop = true
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
end type

type em_tn from editmask within w_cm314_orden_servicios
integer x = 2903
integer y = 1944
integer width = 471
integer height = 84
integer taborder = 120
boolean bringtotop = true
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
end type

type cb_1 from commandbutton within w_cm314_orden_servicios
integer x = 3666
integer y = 532
integer width = 457
integer height = 92
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Mostrar datos"
end type

event clicked;str_parametros   lstr_param


if wf_verifica_datos() = 0 then return

if rb_ref_ss.checked = true then

	lstr_param.dw_master = "d_sel_solicitud_servicios_aprobadas"
	lstr_param.dw1 = "d_sel_solicitud_servicios_aprobadas_det"
	lstr_param.titulo = "Solicitudes de servicio"
	lstr_param.dw_m = dw_master
	lstr_param.dw_d = dw_detail
	lstr_param.opcion = 6
	
	OpenWithParm( w_abc_seleccion_md, lstr_param)
	
elseif rb_ref_ot.checked = true then
	
	Open(w_get_rango_fecha)
	
	if Isnull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return
	
	IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm
	
	if not lstr_param.b_return then return
	
	//lleno el resto de datos necesarios
	lstr_param.dw_master = "d_lista_ot_para_os_grd"
	lstr_param.dw1 		= "d_lista_oper_x_orden_grd"
	lstr_param.titulo    = "Orden de Trabajo"
	lstr_param.dw_m      = dw_master
	lstr_param.dw_d      = dw_detail
	lstr_param.tipo		 = '1OT'
	lstr_param.opcion = 11 //Orden de Servicios a partir de una Orden de Servicios
		
	OpenWithParm( w_abc_seleccion_md, lstr_param)
	
end if
end event

type rb_ref_ss from radiobutton within w_cm314_orden_servicios
integer x = 3666
integer y = 280
integer width = 498
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Sol. Servicio"
borderstyle borderstyle = styleraised!
end type

event clicked;if dw_master.rowcount() = 0 then 
	Messagebox( "Atencion", "Inserte Nuevo registro")
	return
end if

cb_1.enabled = true

of_set_status_doc(idw_1)      // Setea opciones de menu
end event

type rb_sin_ref from radiobutton within w_cm314_orden_servicios
integer x = 3666
integer y = 420
integer width = 430
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sin Referencia"
boolean checked = true
borderstyle borderstyle = styleraised!
end type

event clicked;cb_1.enabled = false
of_set_status_doc(idw_1)   // Setea opciones de menu
end event

type st_ori from statictext within w_cm314_orden_servicios
integer x = 133
integer y = 24
integer width = 247
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

type sle_ori from singlelineedit within w_cm314_orden_servicios
integer x = 375
integer y = 12
integer width = 229
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

type st_nro from statictext within w_cm314_orden_servicios
integer x = 677
integer y = 24
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

type cb_buscar from commandbutton within w_cm314_orden_servicios
integer x = 1495
integer y = 8
integer width = 402
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
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

type rb_ref_ot from radiobutton within w_cm314_orden_servicios
integer x = 3666
integer y = 352
integer width = 498
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Trabajo"
borderstyle borderstyle = styleraised!
end type

event clicked;if dw_master.rowcount() = 0 then 
	Messagebox( "Atencion", "Inserte Nuevo registro")
	return
end if

cb_1.enabled = true

of_set_status_doc(idw_1)      // Setea opciones de menu
end event

type cb_aprobar from commandbutton within w_cm314_orden_servicios
integer x = 3589
integer y = 692
integer width = 334
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aprobar"
end type

event clicked;String 	ls_flag_estado, ls_aprobador, ls_origen, ls_nro_doc, ls_msg
Long 		ll_count 

// Verifica si documento previamente ha sido grabado
IF dw_master.GetRow()=0 THEN Return

ls_origen 	= dw_master.object.cod_origen	[dw_master.GetRow()] 
ls_nro_doc = dw_master.object.nro_os		[dw_master.GetRow()]

if IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
	MessageBox('Error', 'Grabe orden de servicio antes de aprobar')
	return
end if

// Verifica si usuario es aprobador
SELECT count(*) 
  INTO :ll_count 
  FROM logistica_aprobador l 
 WHERE cod_usr = :gs_user 
   AND l.imp_max_aprob_os > 0 ;

IF ll_count=0 THEN 
	MessageBox('Aviso','Usuario no es aprobador de doc. de compra')
	Return
END IF

DECLARE usp_cmp_vobo_doc_compra PROCEDURE FOR 
        usp_cmp_vobo_doc_compra ( :is_doc_os, 
								 	  		 :ls_origen, 
									  		 :ls_nro_doc, 	
								 	  		 :gs_user ) ;
								 
EXECUTE usp_cmp_vobo_doc_compra ;

IF sqlca.sqlcode = -1 THEN
	ls_msg = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error usp_cmp_vobo_doc_compra', ls_msg, StopSign! )
	return
END IF

CLOSE usp_cmp_vobo_doc_compra ;

of_retrieve(ls_origen, ls_nro_doc)

end event

type cb_desaprobar from commandbutton within w_cm314_orden_servicios
integer x = 3931
integer y = 692
integer width = 334
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Desaprobar"
end type

event clicked;String ls_origen, ls_nro_doc, ls_msj, ls_null
Date ld_null
Long ll_count 
// Verifica si documento previamente ha sido grabado
IF dw_master.GetRow()=0 THEN Return

ls_origen 	= dw_master.object.cod_origen	[dw_master.GetRow()] 
ls_nro_doc 	= dw_master.object.nro_os		[dw_master.GetRow()] 

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
 WHERE cod_usr = :gs_user ;

IF ll_count=0 THEN 
	MessageBox('Aviso','Usuario no es aprobador de doc. de compra')
	Return
END IF

DECLARE USP_CMP_DESAPROBAR_DOC_COMPRA PROCEDURE FOR 
	USP_CMP_DESAPROBAR_DOC_COMPRA ( :is_doc_os, 
											  :ls_origen, 
											  :ls_nro_doc, 	
											  :gs_user ) ;
							 
EXECUTE USP_CMP_DESAPROBAR_DOC_COMPRA ;

IF sqlca.sqlcode = -1 THEN
	ls_msj = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error USP_CMP_DESAPROBAR_DOC_COMPRA', ls_msj, StopSign! )
	return
END IF

CLOSE USP_CMP_DESAPROBAR_DOC_COMPRA;

of_retrieve(ls_origen, ls_nro_doc)

end event

type sle_nro from u_sle_codigo within w_cm314_orden_servicios
integer x = 946
integer y = 12
integer height = 92
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type gb_2 from groupbox within w_cm314_orden_servicios
integer x = 3625
integer y = 188
integer width = 553
integer height = 476
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Referencia"
borderstyle borderstyle = styleraised!
end type

