$PBExportHeader$w_ve300_orden_venta.srw
forward
global type w_ve300_orden_venta from w_abc_mastdet
end type
type st_nro from statictext within w_ve300_orden_venta
end type
type cb_buscar from commandbutton within w_ve300_orden_venta
end type
type sle_nro from u_sle_codigo within w_ve300_orden_venta
end type
type cb_duplicar from commandbutton within w_ve300_orden_venta
end type
type gb_1 from groupbox within w_ve300_orden_venta
end type
end forward

global type w_ve300_orden_venta from w_abc_mastdet
integer width = 4110
integer height = 2544
string title = "[VE300] Orden de Venta"
string menuname = "m_mtto_impresion"
windowstate windowstate = maximized!
event ue_anular ( )
event ue_cancelar ( )
event ue_preview ( )
event ue_cerrar ( )
st_nro st_nro
cb_buscar cb_buscar
sle_nro sle_nro
cb_duplicar cb_duplicar
gb_1 gb_1
end type
global w_ve300_orden_venta w_ve300_orden_venta

type variables
String 	is_tipo_doc = '', is_desc_error, &
			is_doc_ov, is_oper_vnta_terc, is_cod_igv, is_flag_Cnta_prsp, &
			is_salir, is_CENCOS_PRSP_ING, is_almacen = ''
			
DEcimal	idc_tasa_igv			
DateTime id_fecha_proc
Long 		in_tipo_cambio
Boolean 	ib_ok

dataStore 			ids_print
n_cst_wait			invo_wait
n_cst_utilitario 	invo_utility
end variables

forward prototypes
public function integer of_set_cliente (string as_cliente)
public function integer of_set_status_doc (datawindow idw)
public function integer of_valida_cabecera ()
public function integer of_set_numera ()
public function integer of_get_param ()
public subroutine of_set_modify ()
public function integer of_call_procedure_temp ()
public function boolean of_generar_ot ()
public subroutine of_modify_dws ()
public subroutine of_retrieve (string as_nro)
public subroutine of_duplicar ()
public function boolean of_set_articulo (string as_cod_art, long al_row)
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

event ue_cancelar;// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()
dw_detail.reset()

sle_nro.text = ''
sle_nro.SetFocus()

is_Action = ''
of_set_status_doc(dw_master)

end event

event ue_preview();this.event ue_print()
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

This.changemenu( m_mtto_impresion)

// Activa todas las opciones
if is_flag_insertar = '1' then
	m_master.m_file.m_basedatos.m_insertar.enabled 		= true	
else
	m_master.m_file.m_basedatos.m_insertar.enabled 		= false
end if

if is_flag_eliminar = '1' then
	m_master.m_file.m_basedatos.m_eliminar.enabled 		= true	
else
	m_master.m_file.m_basedatos.m_eliminar.enabled 		= false
end if

if is_flag_modificar = '1' then
	m_master.m_file.m_basedatos.m_modificar.enabled 		= true	
else
	m_master.m_file.m_basedatos.m_modificar.enabled 		= false
end if

if is_flag_anular = '1' then
	m_master.m_file.m_basedatos.m_anular.enabled 		= true	
else
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
end if

if is_flag_cancelar = '1' then
	m_master.m_file.m_basedatos.m_cancelar.enabled 		= true	
else
	m_master.m_file.m_basedatos.m_cancelar.enabled 		= false
end if

if is_flag_consultar = '1' then
	m_master.m_file.m_basedatos.m_abrirlista.enabled 		= true	
else
	m_master.m_file.m_basedatos.m_abrirlista.enabled 		= false
end if

if is_flag_cerrar = '1' then
	m_master.m_file.m_basedatos.m_cerrar.enabled 		= true	
else
	m_master.m_file.m_basedatos.m_cerrar.enabled 		= false
end if

m_master.m_file.m_printer.m_print1.enabled			= True

IF dw_master.getrow() = 0 THEN RETURN 0
IF dw_detail.getrow() = 0 THEN RETURN 0

IF is_Action = 'new' THEN
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled 		= False
	m_master.m_file.m_basedatos.m_modificar.enabled 	= False
	m_master.m_file.m_basedatos.m_anular.enabled 		= False
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= False
	m_master.m_file.m_printer.m_print1.enabled 			= False
	m_master.m_file.m_basedatos.m_cerrar.enabled 		= False
	IF idw = dw_master THEN		// Si es master, tiene que estar activo para adicionar otro documento
		m_master.m_file.m_basedatos.m_insertar.enabled = False
	ELSE
		
		if is_flag_insertar = '1' then
			m_master.m_file.m_basedatos.m_insertar.enabled 		= true	
		else
			m_master.m_file.m_basedatos.m_insertar.enabled 		= false
		end if
		
		if is_flag_eliminar = '1' then
			m_master.m_file.m_basedatos.m_eliminar.enabled 		= true	
		else
			m_master.m_file.m_basedatos.m_eliminar.enabled 		= false
		end if

	END IF	
END IF

IF is_Action = 'open' THEN
	li_estado = Long( dw_master.object.flag_estado[dw_master.getrow()])

	CHOOSE CASE li_estado
		CASE 0		// Anulado			
			m_master.m_file.m_basedatos.m_eliminar.enabled 	= False
			m_master.m_file.m_basedatos.m_modificar.enabled = False
			m_master.m_file.m_basedatos.m_anular.enabled 	= False
			
		
		CASE 2,3   // Atendido parcial, total
			m_master.m_file.m_basedatos.m_eliminar.enabled 	= False
			m_master.m_file.m_basedatos.m_modificar.enabled = False
			m_master.m_file.m_basedatos.m_anular.enabled 	= False
			IF idw = dw_master THEN		// Si es master, tiene que estar activo para adicionar otro documento			
				if is_flag_insertar = '1' then
					m_master.m_file.m_basedatos.m_insertar.enabled 		= true	
				else
					m_master.m_file.m_basedatos.m_insertar.enabled 		= false
				end if
			ELSE			
				m_master.m_file.m_basedatos.m_insertar.enabled = False
			END IF
	
			IF idw = dw_detail THEN
				ll_row = idw.getrow()
				
				if is_flag_modificar = '1' then
					m_master.m_file.m_basedatos.m_modificar.enabled 		= true	
				else
					m_master.m_file.m_basedatos.m_modificar.enabled 		= false
				end if
		
				
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
	m_master.m_file.m_basedatos.m_cerrar.enabled 		= False
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

public function integer of_set_numera ();// Numera documento
String 				ls_next_nro, ls_execute, ls_table, ls_nro_act, ls_mensaje, ls_nro_ov
Long 					ll_ult_nro, ll_j, ll_long, ll_count
n_cst_utilitario	lnvo_util
Exception			ex


try 
	ex 		 = create Exception
	
	if dw_master.getrow() = 0 then return 0
		
	ls_nro_ov = dw_master.object.nro_ov [dw_master.getRow()]
	
	if is_action = 'new' or isNull(ls_nro_ov) or trim(ls_nro_ov) = '' then
		// Busca el numero en la tabla de numeradores pasada en el argumento y bloquea ese registro
		// Si el numero no existe, bloquea la tabla y crea un nuevo registro
		// Recibe nombre de tabla de numeradores y longitud del campo de numero a generar
		// Devuelve un numero de documento con el formato origen + numero (XX9999...999)
		
		
		//Consulto la tabla numeradora
		SELECT count(*) 
			into :ll_count
		FROM num_orden_venta 
		WHERE origen = :gs_origen;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			ex.SetMessage('Error consultar tabla num_orden_venta, Mensaje: ' + ls_mensaje)
			throw ex
		end if
		
		if ll_count = 0 then
			insert into num_orden_venta(origen, ult_nro)
			values(:gs_origen, 1);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				ex.SetMessage('Error insertar en tabla num_orden_venta, Mensaje: ' + ls_mensaje)
				throw ex
			end if
		
		end if
		
		SELECT ult_nro
			into :ll_ult_nro
		FROM num_orden_venta 
		WHERE origen = :gs_origen for update;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			ex.SetMessage('Error consultar tabla num_orden_venta, Mensaje: ' + ls_mensaje)
			throw ex
		end if
		
		// Verifica que la longitud es de 9 cifras
		ll_long = 9 - len(trim(gs_origen))
		
		if ll_long < 0 then
			ROLLBACK;
			ex.SetMessage('Error en funcion of_Set_numera(). La longitud ' + string(ll_long) + ' no puede ser menor a a longitud del origen')
			throw ex
		end if
			
		do
			
			if gnvo_app.of_get_parametro("VTA_NRO_OV_HEXADECIMAL", "1") = "1" THEN
				ls_next_nro = trim(gs_origen) + trim(lnvo_util.lpad(lnvo_util.of_Long2Hex(ll_ult_nro), ll_long, '0'))
			ELSE
				ls_next_nro = trim(gs_origen) + trim(lnvo_util.lpad(string(ll_ult_nro), ll_long, '0'))
			END IF
			
			select count(*)
				into :ll_count
			from orden_venta
			where nro_ov = :ls_next_nro;
			
			if ll_count > 0  then ll_ult_nro ++
		
		loop while ll_count > 0 
			
		//Asigno el numero que se buscaba
		dw_master.object.nro_ov[dw_master.getrow()] = ls_next_nro
		
		//Actualizo el numerador
		update num_orden_venta
			set ult_nro = :ll_ult_nro
		where origen = :gs_origen;
		
		if SQLCA.SQLCode <> 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			ex.SetMessage('Error actualizar tabla num_orden_venta, Mensaje: ' + ls_mensaje)
			throw ex
		end if
		
	else
		ls_next_nro = dw_master.object.nro_ov[dw_master.getrow()] 
	end if
	
	// Asigna numero a detalle
	for ll_j = 1 to dw_detail.RowCount()
		dw_detail.object.nro_doc[ll_j] = ls_next_nro
	next
	
	return 1
			


catch ( Exception e )
	gnvo_app.of_catch_exception(e, "Exception al momento de ejecutar of_set_numera()")
	
finally
	/*statementBlock*/
	destroy ex
			
	delete tt_numerador;
end try

end function

public function integer of_get_param ();// busca datos
SELECT doc_ov, oper_vnta_terc, cod_igv, CENCOS_PRSP_ING
  INTO :is_doc_ov, :is_oper_vnta_terc, :is_cod_igv, 
 	 	 :is_CENCOS_PRSP_ING
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
dw_detail.Modify("descuento.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("descuento.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

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

public function boolean of_generar_ot ();String 	ls_estado, ls_cliente, ls_ot_gastos, ls_cod_origen, ls_nro_ov, ls_flag_estado
Long 		ll_row
str_parametros lstr_param

ll_row = dw_master.GetRow()

if ll_row = 0 then return false

ls_estado  	   = dw_master.object.flag_estado   [ll_row]
ls_cliente 	   = dw_master.object.cliente       [ll_row]
ls_ot_gastos   = dw_master.object.ot_gastos     [ll_row]
ls_cod_origen	= dw_master.object.cod_origen	 	[ll_row]
ls_nro_ov      = dw_master.object.nro_ov  		[ll_row]
ls_flag_estado = dw_master.object.flag_estado	[ll_row]
		
lstr_param.string1	 = ls_nro_ov
lstr_param.string2	 = dw_master.object.forma_embarque [ll_row]
lstr_param.string3	 = ls_flag_estado
		
if isnull(ls_nro_ov) or trim(ls_nro_ov) = '' then
	Messagebox('Aviso','Aviso debe Grabar Orden de VENTA')
	Return false
end if
		
IF LEN(ls_ot_gastos) > 0 THEN
	Return true
END IF
		
IF ls_flag_estado <> '1' AND ls_flag_estado <> '3' THEN
	RETURN true
END IF
		
IF IsNull(ls_cliente) or ls_cliente = '' THEN
	MessageBox('Aviso', 'Debe ingresar un codigo de Cliente')
	RETURN false
END IF
		
//Llama al Procedimiento para llenar la tabla temporal
IF of_call_procedure_temp() = 0 THEN
	RETURN false
END IF
		
OpenWithParm(w_ve301_generar_ot, lstr_param)
		
if Not IsValid(Message.Powerobjectparm) or isnull(Message.powerobjectparm) then return false
lstr_param = Message.powerobjectparm
if lstr_param.titulo = 'n' then return false

return true
end function

public subroutine of_modify_dws ();dw_master.Modify("monto_flete.Protect ='1 ~t If(flag_mercado = ~~'L~~',1,0)'")
dw_master.Modify("monto_flete.Background.color ='1 ~t If(flag_mercado = ~~'L~~',RGB(192,192,192),RGB(255,255,255))'")

dw_master.Modify("monto_seguro.Protect ='1 ~t If(flag_mercado = ~~'L~~',1,0)'")
dw_master.Modify("monto_seguro.Background.color ='1 ~t If(flag_mercado = ~~'L~~',RGB(192,192,192),RGB(255,255,255))'")

dw_master.Modify("pais_destino.Protect ='1 ~t If(flag_mercado = ~~'L~~',1,0)'")
dw_master.Modify("pais_destino.Background.color ='1 ~t If(flag_mercado = ~~'L~~',RGB(192,192,192),RGB(255,255,255))'")

end subroutine

public subroutine of_retrieve (string as_nro);Long ll_row
String	ls_mensaje

//Actualizo la cantidad facturada de la OV para todos los que no sean iguales
update articulo_mov_proy amp
   set amp.cant_facturada = (select abs(nvl(sum(ccd.cantidad * decode(dt.flag_signo, '+', 1, -1)),0))
                               from cntas_cobrar_det ccd,
                                    cntas_cobrar     cc,
                                    doc_tipo         dt
                              where cc.tipo_doc = ccd.tipo_doc
                                and cc.nro_doc  = ccd.nro_doc
                                and cc.tipo_doc = dt.tipo_doc
                                and ccd.org_amp_ref = amp.cod_origen
                                and ccd.nro_amp_ref = amp.nro_mov
                                and cc.flag_estado <> '0')
  where amp.cant_facturada <> (select abs(nvl(sum(ccd.cantidad * decode(dt.flag_signo, '+', 1, -1)),0))
                               from cntas_cobrar_det ccd,
                                    cntas_cobrar     cc,
                                    doc_tipo         dt
                              where cc.tipo_doc = ccd.tipo_doc
                                and cc.nro_doc  = ccd.nro_doc
                                and cc.tipo_doc = dt.tipo_doc
                                and ccd.org_amp_ref = amp.cod_origen
                                and ccd.nro_amp_ref = amp.nro_mov
                                and cc.flag_estado <> '0')      
    and amp.tipo_doc = (select doc_ov from logparam where reckey = '1')
	 and amp.nro_doc	= :as_nro;                          
commit;

dw_master.Reset()
dw_detail.Reset()

dw_master.ii_update = 0
dw_detail.ii_update = 0
	
	
dw_master.ResetUpdate()
dw_detail.ResetUpdate()
										  
ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then		
	if Not IsNull(dw_master.object.ot_gastos [ll_row]) and trim(dw_master.object.ot_gastos [ll_row]) <> '' then
		dw_master.object.b_genera_ot.visible = "no"
		of_modify_dws()
	end if

	dw_detail.retrieve( is_doc_ov, as_nro)
	of_set_status_doc( dw_master )
	
else
	MessageBox('Aviso', 'No existe la Orden de Venta ' + as_nro + ' o no puede ser accedido o no contiene registros, por favor verifique', StopSign!)
end if

dw_master.il_row = ll_row
of_modify_dws()

dw_master.ii_protect = 0
dw_master.of_protect()
dw_master.ii_update = 0

dw_detail.ii_protect = 0
dw_detail.of_protect()
dw_detail.ii_update = 0

return 


end subroutine

public subroutine of_duplicar ();String			ls_nro_OV, ls_flag_estado
Long				ll_row, ll_i
decimal			ldc_cant_despacho, ldc_cant_despacho_und2
str_parametros	lstr_param
u_ds_base		lds_master, lds_detail

try 
	
	if dw_master.ii_update = 1 then
		MessageBox('Error', 'La CABECERA del documento tiene grabaciones pendientes, por favor verifique!', StopSign!)
		return
	end if
	
	if dw_detail.ii_update = 1 then
		MessageBox('Error', 'El DETALLE del documento tiene grabaciones pendientes, por favor verifique!', StopSign!)
		return
	end if
	
	lds_master = create u_ds_base
	lds_detail = create u_ds_base
	
	lds_master.DataObject = 'd_abc_orden_venta_ff'
	lds_detail.DataObject = 'd_abc_articulo_mov_proy_ov_tbl'
	
	lds_master.SetTransObject(SQLCA)
	lds_detail.SetTransObject(SQLCA)
	
	/*Obtengo el nro de la orden de venta*/
	open(w_get_nro_ov)
	
	if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return
	
	lstr_param = Message.PowerObjectParm
	
	ls_nro_ov = lstr_param.string1
	
	lds_master.Retrieve(ls_nro_ov)
	
	if lds_master.RowCount() = 0 then
		MessageBox('Error', 'La Orden de Venta ' + ls_nro_ov + ' no existe o no tiene cabecera, por favor verifique!', StopSign!)
		return
	end if
	
	ls_flag_estado = lds_master.object.flag_estado [1]
	
	if ls_flag_estado = '0' then
		MessageBox('Error', 'La Orden de Venta ' + ls_nro_ov + ' esta anulada, no es posible realizar una copia', StopSign!)
		return
	end if
	
	
	lds_detail.Retrieve(gnvo_app.is_doc_ov, ls_nro_ov)
	
	if lds_detail.RowCount() = 0 then
		MessageBox('Error', 'La Orden de Venta ' + ls_nro_ov + ' no tiene detalle, por favor verifique!', StopSign!)
		return
	end if
	
	dw_master.reset()
	dw_master.ResetUpdate()
	dw_master.ii_update = 0
	
	dw_detail.reset()
	dw_detail.ResetUpdate()
	dw_detail.ii_update = 0
	
	ll_row = dw_master.event ue_insert()
	
	if ll_row > 0 then
		dw_master.object.cliente				[ll_row] = lds_master.object.cliente 					[1]
		dw_master.object.nom_proveedor		[ll_row] = lds_master.object.nom_proveedor 			[1]
		dw_master.object.ruc						[ll_row] = lds_master.object.ruc 						[1]
		dw_master.object.vendedor				[ll_row] = lds_master.object.vendedor 					[1]
		dw_master.object.nom_vendedor			[ll_row] = lds_master.object.nom_vendedor 			[1]
		dw_master.object.forma_pago			[ll_row] = lds_master.object.forma_pago 				[1]
		dw_master.object.desc_forma_pago		[ll_row] = lds_master.object.desc_forma_pago 		[1]
		dw_master.object.cod_moneda			[ll_row] = lds_master.object.cod_moneda 				[1]
		dw_master.object.desc_moneda			[ll_row] = lds_master.object.desc_moneda 				[1]
		dw_master.object.payments				[ll_row] = lds_master.object.payments 					[1]
		dw_master.object.banco					[ll_row] = lds_master.object.banco 						[1]
		dw_master.object.punto_partida		[ll_row] = lds_master.object.punto_partida 			[1]
		dw_master.object.destino				[ll_row] = lds_master.object.destino 					[1]
		dw_master.object.comprador_final		[ll_row] = lds_master.object.comprador_final 		[1]
		dw_master.object.nom_comprador		[ll_row] = lds_master.object.nom_comprador 			[1]
		dw_master.object.forma_embarque		[ll_row] = lds_master.object.forma_embarque 			[1]
		dw_master.object.desc_forma_embarque[ll_row] = lds_master.object.desc_forma_embarque 	[1]
		dw_master.object.tipo_doc				[ll_row] = lds_master.object.tipo_doc 					[1]
		dw_master.object.nro_doc				[ll_row] = lds_master.object.nro_doc 					[1]
		dw_master.object.puerto_org			[ll_row] = lds_master.object.puerto_org 				[1]
		dw_master.object.desc_puerto_org		[ll_row] = lds_master.object.desc_puerto_org 		[1]
		dw_master.object.puerto_dst			[ll_row] = lds_master.object.puerto_dst 				[1]
		dw_master.object.desc_puerto_dst		[ll_row] = lds_master.object.desc_puerto_dst 		[1]
		dw_master.object.flag_mercado			[ll_row] = lds_master.object.flag_mercado 			[1]
		dw_master.object.monto_flete			[ll_row] = lds_master.object.monto_flete 				[1]
		dw_master.object.monto_seguro			[ll_row] = lds_master.object.monto_seguro 			[1]
		dw_master.object.pais_destino			[ll_row] = lds_master.object.pais_destino 			[1]
		dw_master.object.nom_pais				[ll_row] = lds_master.object.nom_pais 					[1]
		dw_master.object.obs						[ll_row] = lds_master.object.obs 						[1]
		//Inserto el detalle
		
		for ll_i = 1 to lds_detail.RowCount() 
			ll_row = dw_detail.event ue_insert()
			
			if ll_row > 0 then
				ldc_cant_despacho			= Dec(lds_detail.object.cant_despacho			[ll_i])
				ldc_cant_despacho_und2	= Dec(lds_detail.object.cant_despacho_und2	[ll_i])
				
				if IsNull(ldc_cant_despacho) then ldc_cant_despacho = 0
				if IsNull(ldc_cant_despacho_und2) then ldc_cant_despacho_und2 = 0
				
				dw_Detail.object.cod_art				[ll_row] = lds_detail.object.cod_art				[ll_i]
				dw_Detail.object.desc_art				[ll_row] = lds_detail.object.desc_art				[ll_i]
				dw_Detail.object.fec_proyect			[ll_row] = lds_detail.object.fec_proyect			[ll_i]
				dw_Detail.object.almacen				[ll_row] = lds_detail.object.almacen				[ll_i]
				dw_Detail.object.cant_proyect			[ll_row] = lds_detail.object.cant_proyect			[ll_i]
				dw_Detail.object.und						[ll_row] = lds_detail.object.und						[ll_i]
				dw_Detail.object.cant_despacho		[ll_row] = ldc_cant_despacho
				dw_Detail.object.und_almacen			[ll_row] = lds_detail.object.und_almacen			[ll_i]
				dw_Detail.object.factor_conv_und		[ll_row] = lds_detail.object.factor_conv_und		[ll_i]
				dw_Detail.object.cant_despacho_und2	[ll_row] = ldc_cant_despacho_und2
				dw_Detail.object.und2					[ll_row] = lds_detail.object.und2					[ll_i]
				dw_Detail.object.precio_unit			[ll_row] = lds_detail.object.precio_unit			[ll_i]
				dw_Detail.object.porc_dscto			[ll_row] = lds_detail.object.porc_dscto			[ll_i]
				dw_Detail.object.descuento				[ll_row] = lds_detail.object.descuento				[ll_i]
				dw_Detail.object.tipo_impuesto1		[ll_row] = lds_detail.object.tipo_impuesto1		[ll_i]
				dw_Detail.object.impuesto				[ll_row] = lds_detail.object.impuesto				[ll_i]
				dw_Detail.object.precio_venta			[ll_row] = lds_detail.object.precio_venta			[ll_i]
				dw_Detail.object.cencos					[ll_row] = lds_detail.object.cencos					[ll_i]
				dw_Detail.object.cnta_prsp				[ll_row] = lds_detail.object.cnta_prsp				[ll_i]
				dw_Detail.object.saldo_total			[ll_row] = lds_detail.object.saldo_total			[ll_i]
			end if
		next
	end if
	
	
	dw_master.object.monto_total[1] = dw_detail.object.co_total[1]
	

	
catch ( Exception ex)
	
	gnvo_app.of_catch_exception(ex, 'Error en funcion of_duplicar()')
	

finally
	
	destroy lds_master
	destroy lds_detail

end try
end subroutine

public function boolean of_set_articulo (string as_cod_art, long al_row);string 			ls_almacen, ls_cod_clase , ls_proveedor,  ls_tipo_precio, ls_moneda , ls_origen, &
					ls_cencos, 	ls_cnta_prsp, 	ls_descripcion, ls_desc_art, ls_und2, ls_mensaje, ls_und
date				ld_fec_reg, ld_fecha		 
decimal			ldc_precio_pactado, ldc_precio, ldc_cambio, ldc_factor_conv_und, ldc_precio_venta, &
					ldc_porc_igv, ldc_impuesto, ldc_precio_unit, ldc_precio_vta_unidad, &
					ldc_precio_vta_mayor, ldc_precio_vta_min

// Setea las variables x defecto de acuerdo al codigo de articulo
// x ejemplo el almacen tácito y el precio en articulo_precio_pactado

if dw_master.GetRow() = 0 then return false

ld_fec_reg = Date(dw_master.object.fec_registro[dw_master.GetRow()])
ls_origen  = dw_master.object.cod_origen [dw_master.getrow()]

// Almacen Tacito
select cod_clase, desc_art
	into :ls_cod_clase, :ls_desc_art
from articulo
where cod_art 		= :as_cod_art
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	ROLLBACK;
	MessageBox('Aviso', 'Codigo de Articulo ' + trim(as_cod_art) + ' no existe o no se encuentra activo, verifique!', StopSign!)
	return false
end if

if IsNull(ls_cod_clase) or ls_cod_clase = '' then
	ROLLBACK;
	MessageBox('Aviso', 'Articulo ' + as_cod_art + ' no esta enlazado a ninguna clase', StopSign!)
	return false
end if

select almacen
  into :ls_almacen
from almacen_tacito
where cod_origen = :gs_origen
  and cod_clase  = :ls_cod_clase;

if SQLCA.SQLCode = 100 then ls_almacen = is_almacen

dw_detail.object.almacen [dw_detail.GetRow()] = ls_almacen

// Precio del Articulo
ls_tipo_precio = dw_master.object.flag_tipo_precio[dw_master.getrow()]

//DAtos de conversion
select a.und2, nvl(a.factor_conv_und,0), a.und,
		 a.precio_vta_unidad,
		 a.precio_vta_mayor,
		 a.precio_vta_min
	into 	:ls_und2, :ldc_factor_conv_und, :ls_und,
			:ldc_precio_vta_unidad,
			:ldc_precio_vta_mayor,
			:ldc_precio_vta_min
from articulo a
where a.cod_art = :as_cod_art;

if sqlca.SQlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	rollback;
	MessageBox('Error', 'Error al hacer la consulta en tabla ARTICULO. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

if sqlca.SQlCode = 100 then
	rollback;
	MessageBox('Error', 'No existe código de articulo ' + as_cod_art + '. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

/*
	1 -> Mayorista
	2 -> Minorista
	3 -> Distribuidor
	4 -> Supermercado
*/

if ls_tipo_precio = '2' then
	ldc_precio_venta = ldc_precio_vta_unidad
elseif ls_tipo_precio = '1' then
	ldc_precio_venta = ldc_precio_vta_mayor
elseif ls_tipo_precio = '3' then
	ldc_precio_venta = ldc_precio_vta_min
end if


ldc_porc_igv = Dec(dw_detail.object.porc_impuesto [al_row])

ldc_precio_unit 	= ldc_precio_venta / (1 + ldc_porc_igv / 100)
ldc_impuesto		= ldc_precio_unit * ldc_porc_igv / 100

dw_detail.object.cant_proyect 		[al_row] = 1
dw_detail.object.cant_despacho 		[al_row] = 1
dw_detail.object.precio_unit 			[al_row] = ldc_precio_unit
dw_detail.object.impuesto		 		[al_row] = ldc_impuesto
dw_detail.object.precio_venta 		[al_row] = ldc_precio_venta



dw_detail.object.factor_conv_und		[al_row] = ldc_factor_conv_und
dw_detail.object.und2 					[al_row] = ls_und2
dw_detail.object.cant_despacho_und2	[al_row] = 1 * ldc_factor_conv_und
dw_detail.object.und_almacen			[al_row] = ls_und


//Busco el centro de costos y la cuenta presupuestal de gastos
select t.cencos_ingreso, t.cnta_prsp_ingreso
	into :ls_cencos, :ls_cnta_prsp 
from articulo_venta t
 where cod_art     = :as_cod_art;
 
if SQLCA.SQLCode < 0 then
	ROLLBACK;
	MessageBox('Aviso', 'Error en consultar tabla ARTICULO_VENTA. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

if SQLCA.SQLCode = 100 then
	ROLLBACK;
	MessageBox('Aviso', 'Codigo de Articulo ' + trim(as_cod_art) + ' no existe en ARTICULO_VENTA, por favor verifique!', StopSign!)
	return false
end if

dw_detail.object.cencos_gasto		[al_row] = ls_Cencos
dw_detail.object.cencos				[al_row] = ls_cencos
dw_detail.object.cnta_prsp			[al_row] = ls_cnta_prsp

return true
end function

on w_ve300_orden_venta.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_impresion" then this.MenuID = create m_mtto_impresion
this.st_nro=create st_nro
this.cb_buscar=create cb_buscar
this.sle_nro=create sle_nro
this.cb_duplicar=create cb_duplicar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nro
this.Control[iCurrent+2]=this.cb_buscar
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.cb_duplicar
this.Control[iCurrent+5]=this.gb_1
end on

on w_ve300_orden_venta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nro)
destroy(this.cb_buscar)
destroy(this.sle_nro)
destroy(this.cb_duplicar)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;String ls_mon, ls_cod_rel, ls_forpago, ls_dest, ls_part, ls_val
Double ln_tasa

ib_log = TRUE  // Activa el log_diario

invo_Wait = create n_cst_wait

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
	
//Verificamos si la empresa es SERVIMOTOR para asignar el datawindows personalizado
dw_master.dataObject = 'd_abc_orden_venta_ff'
dw_master.SetTransObject(SQLCA)

dw_master.object.p_logo.filename = gs_logo	

//Actualizo la cantidad procesada
try 
	
	if gnvo_app.of_get_parametro("ACTUALIZA_SALDOS_OV", "0") = "1" then
		gnvo_app.almacen.of_actualiza_saldos()
	end if

catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, 'Error al cargar datos de la tabla configuracion')
	
end try

end event

event ue_update_pre;String 	ls_moneda, ls_flag_mercado, ls_cencos_gasto, ls_cliente , ls_mensaje
integer 	li_i

if dw_master.GetRow() = 0 then return

dw_master.Accepttext()
dw_detail.Accepttext()

ls_flag_mercado = dw_master.object.flag_mercado [dw_master.getrow()]

ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master) <> true then return
if gnvo_app.of_row_Processing( dw_detail) <> true then return

if dw_detail.rowcount() = 0 then
	Messagebox( "Error", "No se permite grabar una Orden de Venta sin detalle, Ingrese detalle")
	return
end if

ls_moneda  = dw_master.object.cod_moneda	[dw_master.GetRow()]
ls_cliente = dw_master.object.cliente   	[dw_master.GetRow()]

for li_i= 1 to dw_detail.RowCount()
	 dw_detail.object.cod_moneda[li_i] = ls_moneda
	 dw_detail.ii_update = 1
next

/*Validar monto permitidos y fechas permitidas solo si orden de venta*/
declare USF_COM_MONTO_PER_X_CLIENTE procedure for 
	USF_COM_MONTO_PER_X_CLIENTE (:ls_cliente) ;
execute USF_COM_MONTO_PER_X_CLIENTE ;

IF gnvo_app.of_ExistsError(SQLCA, "PROCEDURE USF_COM_MONTO_PER_X_CLIENTE") then
	Rollback ;
	RETURN 
END IF

fetch USF_COM_MONTO_PER_X_CLIENTE  into :ls_mensaje ;

close USF_COM_MONTO_PER_X_CLIENTE;

if not isNull(ls_mensaje) and trim(ls_mensaje) <> '' then
	f_mensaje('Validando montos y fechas permitidas: ' + ls_mensaje, '')
	return
end if

/**/


/*Validar dias permitidos*/
declare USF_COM_DIAS_PER_X_CLIENTE procedure for 
	USF_COM_DIAS_PER_X_CLIENTE (:ls_cliente) ;
execute USF_COM_DIAS_PER_X_CLIENTE ;

IF gnvo_app.of_ExistsError(SQLCA, "PROCEDURE USF_COM_DIAS_PER_X_CLIENTE") then
	Rollback ;
	RETURN 
END IF

fetch USF_COM_DIAS_PER_X_CLIENTE  into :ls_mensaje ;

close USF_COM_DIAS_PER_X_CLIENTE;

if not isNull(ls_mensaje) and trim(ls_mensaje) <> '' then
	f_mensaje('Validando días permitidos: ' + ls_mensaje, '')
	return
end if


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
	id_fecha_proc = f_fecha_actual() 
	in_tipo_cambio = f_get_tipo_cambio(Date(id_fecha_proc))
	if in_tipo_cambio = 0 THEN return
	
	// Obtengo los movimientos proyectados atrazados 
	// Solo por el tipo de documento
	// Los dias de retrazo los toma de LogParam y el usuario de gs_user
	lnvo_amp_retr = CREATE n_cst_diaz_retrazo
	ll_mov_atrazados = lnvo_amp_retr.of_amp_retrazados( is_doc_ov )
	DESTROY lnvo_amp_retr
	
	/*
	if ll_mov_atrazados > 0 then
	
		MessageBox('Aviso', 'Usted tiene pendientes ' + string(ll_mov_atrazados) &
			+ ' movimientos Proyectados en Orden de Venta')
		
		return
		
	end if
	*/
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

of_set_status_doc(idw_1)
end event

event ue_update;// Override
Boolean lbo_ok = TRUE
String	ls_msg1, ls_crlf, ls_msg2, ls_flag_mercado, ls_ot_gastos, ls_nro_ov
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
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF
//

//mercado
ls_flag_mercado = dw_master.object.flag_mercado [dw_master.Getrow()]
ls_ot_gastos	 = dw_master.object.ot_gastos		[dw_master.Getrow()]

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg2 = SQLCA.SQLERRTEXT  //"Se ha procedido al rollback"
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

// Para el Log_diario
IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF
//

IF lbo_ok THEN	

	COMMIT using SQLCA;
	
				
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
	//Si es de flag de mercaro Exportación entonces debe generar OT de exportacion a excepción
	// de ARCOPA
	if gs_empresa <> 'ARCOPA' then
		if dw_master.getRow() > 0 and dw_master.object.flag_estado [dw_master.getRow()] = '1' then
			if ls_flag_mercado = 'E' and (Isnull(ls_ot_gastos) OR Trim(ls_ot_gastos) = '') then //orden de venta de exportacion
				if MessageBox('Aviso', 'La Orden de Venta no tiene OT de gastos, desea generar OT para gastos de exportación?', &
					Information!, Yesno!, 2) = 1 then of_generar_ot()
			end if
		end if
	end if
	
	is_action = 'open'
	of_set_status_doc( dw_master)		
	
	of_retrieve(dw_master.object.nro_ov[dw_master.GetRow()])

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

event ue_print;if dw_master.GetRow() = 0 then return


str_parametros 				lstr_rep
w_ve300_orden_venta_frm		lw_1

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 = 'd_rpt_orden_venta'
lstr_rep.titulo = 'Previo de Orden de Venta'
lstr_rep.string1 = dw_master.object.cod_origen	[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_ov		[dw_master.getrow()]
lstr_rep.string3 = dw_master.object.flag_mercado[dw_master.getrow()]

OpenSheetWithParm(lw_1, lstr_rep, w_main, 0, Layered!)
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_retrieve_list;// Abre ventana pop
str_parametros sl_param

sl_param.dw1    = 'd_lista_orden_venta_tbl'
sl_param.titulo = 'Ordenes de Venta'
sl_param.field_ret_i[1] = 2

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event close;call super::close;destroy invo_wait
end event

type dw_master from w_abc_mastdet`dw_master within w_ve300_orden_venta
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 168
integer width = 3826
integer height = 1336
integer taborder = 40
string dataobject = "d_abc_orden_venta_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
integer ii_sort = 1
end type

event dw_master::ue_display;string 	ls_codigo, ls_sql, ls_data, ls_ruc, ls_direccion, ls_cliente, &
			ls_distrito, ls_estado, ls_destino, ls_string, ls_evaluate, ls_tipo_precio
boolean 	lb_ret

str_seleccionar 	lstr_seleccionar
str_ubigeo			lstr_ubigeo

CHOOSE CASE upper(as_columna)
	case "ubigeo_dst"
		lstr_ubigeo = invo_utility.of_get_ubigeo()
		
		if lstr_ubigeo.b_return then
			
			this.object.ubigeo_dst	[al_row] = lstr_ubigeo.codigo
			this.object.desc_ubigeo	[al_row] = lstr_ubigeo.descripcion
			
			this.ii_update = 1
		end if

	CASE "CLIENTE"
		ls_sql = "SELECT p.proveedor AS codigo_cliente, " &
			 		+ "p.nom_proveedor AS nombre_cliente, "  &
				  	+ "decode(tipo_doc_ident, '6', RUC, nro_doc_ident) as ruc_cliente, " 	&
					+ "p.flag_tipo_precio as tipo_precio " 	&  
			  		+ "FROM proveedor p " 	&
			  		+ "where p.flag_estado = '1'" &
					+ "  and p.flag_clie_prov in ('0', '2')"
			 
		IF gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_ruc, ls_tipo_precio, '2') THEN
			
			select pkg_logistica.of_get_dir_comercial(:ls_codigo)
				into :ls_direccion
			from dual;
			
			This.object.cliente				[al_row] = ls_codigo
			This.object.nom_proveedor		[al_row] = ls_data
			This.object.ruc					[al_row] = ls_ruc
			This.object.flag_tipo_precio	[al_row] = ls_tipo_precio
			
			This.object.comprador_final	[al_row] = ls_codigo
			This.object.nom_comprador  	[al_row] = ls_data
			
			This.object.destino				[al_row] = ls_direccion
		END IF

		This.ii_update = 1

	CASE "PAYMENTS"
		ls_sql = "select distinct ov.payments as payments, " &
				 + "1 as nro " &
				 + "from orden_venta ov " &
				 + "where ov.flag_estado = '1'"
			 
		IF gnvo_app.of_lista(ls_sql, ls_codigo, '2') THEN
			This.object.PAYMENTS			[al_row] = ls_codigo
				
		END IF

		This.ii_update = 1

	CASE "BANCO"
		ls_sql = "select reckey as reckey, " &
				 + "b.desc_banco as descripcion_banco " &
				 + "from bancos_ov b"
			 
		IF gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') THEN
			This.object.banco			[al_row] = ls_data
				
		END IF

		This.ii_update = 1
		
	CASE "PUERTO_ORG"
		ls_sql = "select puerto as puerto, " &
				 + "descr_puerto as descripcion_puerto " &
				 + "from fl_puertos " &
				 + "where flag_estado = '1'"
			 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
		IF ls_codigo <> '' THEN
			This.object.puerto_org			[al_row] = ls_codigo
			This.object.desc_puerto_org	[al_row] = ls_data
		END IF

		This.ii_update = 1

	CASE "PUERTO_DST"
		ls_sql = "select puerto as puerto, " &
				 + "descr_puerto as descripcion_puerto " &
				 + "from fl_puertos " &
				 + "where flag_estado = '1'"
			 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
		IF ls_codigo <> '' THEN
			This.object.puerto_dst			[al_row] = ls_codigo
			This.object.desc_puerto_dst	[al_row] = ls_data
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
			is_almacen = ls_codigo
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
		
	CASE "PAIS_DESTINO"
		ls_sql = "select T.COD_PAIS AS CODIGO_PAIS, " &
				 + "T.NOM_PAIS AS NOMBRE_PAIS " &
				 + "from PAIS t " &
				 + "WHERE T.FLAG_ESTADO <> '0'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
					
		IF ls_codigo <> '' THEN
			This.object.pais_destino	[al_row] = ls_codigo
			This.object.nom_pais			[al_row] = ls_data
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
				 + "and b.cod_usr = '" + gs_user + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.ot_gastos[AL_row] = ls_codigo
		END IF
			
		This.ii_update= 1
	
	CASE "VENDEDOR"
		ls_sql = "SELECT V.VENDEDOR as codigo_vendedor, "&
				 + "v.nom_vendedor as nombre_vendedor " &
				 + "FROM VENDEDOR V " &
				 + "WHERE V.flag_estado = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		IF ls_codigo <> '' THEN
			This.object.vendedor	    [al_row] = ls_codigo
			this.object.nom_vendedor [al_row] = ls_data
		END IF
		
	
		This.ii_update= 1		

	CASE 'DESTINO'					
		ls_cliente = dw_master.object.cliente [al_row]		
		IF Isnull(ls_cliente) OR Trim(ls_cliente)  = '' THEN
			Messagebox('Aviso','Debe Ingresar Codigo de Cliente , Verifique!')
			Return
		END IF
		
		ls_sql = "SELECT D.ITEM AS ITEM," &    
				 + "pkg_logistica.of_get_direccion(d.codigo, d.item) as direccion "  &
				 + "FROM DIRECCIONES D "&
				 + "WHERE D.CODIGO = '" + ls_cliente +"' " &
				 + "AND D.FLAG_USO in ('1', '3')"		
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "1")
		
		if ls_codigo <> "" then
			
			ls_data = left(trim(ls_data), 100)
			
			This.Object.destino [al_row] = ls_data
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

event dw_master::ue_str_parametros_det_pos(any aa_id[]);call super::ue_str_parametros_det_pos;idw_det.retrieve(aa_id[1], is_tipo_doc, aa_id[2])
end event

event dw_master::itemerror;call super::itemerror;Return(1)
end event

event dw_master::ue_insert_pre;String ls_flag_estado

of_modify_dws()

is_action = 'new'

dw_master.object.p_logo.filename = gs_logo	

SELECT flag_aprobar_ov 
  INTO :ls_flag_estado 
FROM logparam 
WHERE reckey='1' ;

This.object.cod_origen  		[al_row]  = gs_origen
This.object.cod_usr     		[al_row]  = gs_user
This.object.fec_registro		[al_row]  = gnvo_app.of_fecha_actual()
This.object.fecha_doc			[al_row]  = date(gnvo_app.of_fecha_actual())
This.object.flag_estado 		[al_row]  = ls_flag_estado 
This.object.monto_flete 		[al_row]  = 0.00
This.object.monto_seguro 		[al_row]  = 0.00
This.object.monto_facturado 	[al_row]  = 0.00
This.object.flag_mercado 		[al_row]  = 'L'



This.setColumn("cliente")

end event

event dw_master::itemchanged;call super::itemchanged;string 		ls_flag, ls_data, ls_ruc, ls_data2, ls_direccion, ls_tipo_precio
long 			ll_j
str_ubigeo	lstr_ubigeo

THIS.AcceptText()

IF row = 0 then
	RETURN
END IF

CHOOSE CASE upper(dwo.name)
	case "ubigeo_org"
		
		select su.departamento || '-' || su.provincia || '-' || su.distrito
			into :lstr_ubigeo.descripcion
		  from sunat_ubigeo su
		 where su.ubigeo 			= :data
		   and su.flag_estado 	= '1';
		
		if SQLCA.SQLCode = 100 then
			this.object.desc_ubigeo	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de UBIGEO ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if
  
		this.object.desc_ubigeo	[row] = lstr_ubigeo.descripcion
		
	CASE "CLIENTE"
		SELECT nom_proveedor, ruc, pkg_logistica.of_get_dir_comercial(proveedor), NVL(flag_tipo_precio, '2')
			INTO :ls_data, :ls_ruc, :ls_direccion, :ls_tipo_precio
		FROM proveedor
		WHERE flag_estado = '1'
		  AND proveedor   = :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'EL CLIENTE ' + data + ' NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.cliente				[row] = gnvo_app.is_null
			THIS.object.nom_proveedor		[row] = gnvo_app.is_null
			THIS.object.ruc					[row] = gnvo_app.is_null
			this.object.Destino				[row] = gnvo_app.is_null
			this.object.flag_tipo_precio	[row] = gnvo_app.is_null
			RETURN 1
		END IF

		THIS.Object.nom_proveedor 		[row] = ls_data
		THIS.Object.ruc 					[row] = ls_ruc
		THIS.object.comprador_final	[row] = data
		THIS.object.nom_comprador		[row] = ls_data
		this.object.Destino				[row] = ls_direccion
		this.object.flag_tipo_precio	[row] = ls_tipo_precio
		
	CASE "FORMA_PAGO"
		SELECT desc_forma_pago
			INTO :ls_data
		FROM forma_pago
		WHERE flag_estado = '1'
		  AND forma_pago  = :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.forma_pago		[row] = gnvo_app.is_null
			THIS.object.desc_forma_pago[row] = gnvo_app.is_null
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
			THIS.object.cod_moneda 			[row] = gnvo_app.is_null
			THIS.object.desc_moneda[row] = gnvo_app.is_null
			RETURN 1
		END IF
		
		THIS.object.desc_moneda[row] = ls_data
		
		// si modifica la moneda, actualizar el detalle
		FOR ll_j = 1 TO dw_detail.RowCount()
			dw_detail.object.cod_moneda[ll_j] = data
		NEXT
		dw_detail.ii_update = 1
		

	CASE 'PAIS_DESTINO' 
		
		SELECT nom_pais
			INTO :ls_data
		FROM pais
		WHERE cod_pais  = :data
		  AND flag_estado = '1';
		 
		IF SQLCA.SQLCode = 100 THEN
			messageBox('Aviso', 'EL CODIGO DE PAIS O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.pais_destino[row] = gnvo_app.is_null
			THIS.object.nom_pais		[row] = gnvo_app.is_null
			RETURN 1
		END IF
		
		THIS.object.nom_pais[row] = ls_data
		
		
	CASE 'FORMA_EMBARQUE'
		SELECT descripcion
			INTO :ls_data
		FROM forma_embarque
		WHERE forma_embarque = :data
		  AND flag_estado = '1';
		  
		IF SQLCA.SQLCode = 100 THEN
			messageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.forma_embarque 		[row] = gnvo_app.is_null
			THIS.object.desc_forma_embarque	[row] = gnvo_app.is_null
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
			AND b.cod_usr 		 = :gs_user;
				  
		IF SQLCA.SQLCode = 100 THEN
			messageBox('Aviso', 'LA O.T NO EXISTE O NO ESTA ACTIVA, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.ot_gastos[row] = gnvo_app.is_null
			RETURN 1
		END IF
				 
		THIS.object.ot_gastos[row] = ls_data
	
	CASE "VENDEDOR"
		SELECT v.nom_vendedor
		  INTO :ls_data
		  FROM vendedor v
		WHERE v.flag_estado = '1'
		  AND v.vendedor = :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'EL VENDEDOR ' + data + ' NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.vendedor		[row] = gnvo_app.is_null
			THIS.object.nom_vendedor[row] = gnvo_app.is_null
			RETURN 1
		END IF

		this.object.nom_vendedor[row] = ls_data
	
END CHOOSE




end event

event dw_master::buttonclicked;string 	ls_cliente, ls_estado, ls_nro_ov, ls_ot_gastos, &
			ls_flag_estado, ls_cod_origen
str_parametros lstr_param
str_ubigeo		lstr_ubigeo

CHOOSE CASE lower(dwo.name)

	CASE "b_genera_ot"
		of_generar_ot()
		
	CASE 'b_estructura'
		
		str_parametros lstr_parametros
		
		ls_nro_ov = this.object.nro_ov[row]
		
		if ls_nro_ov = '' or isnull(ls_nro_ov) then
			return
		else
			lstr_parametros.string1 = this.object.cod_origen[row]
			lstr_parametros.string2 = ls_nro_ov
		end if
		
		opensheetwithparm(w_ve301_genera_estructura_costo,lstr_parametros, parent, 1, Original!)
		
	CASE 'b_obs'
		
		If this.is_protect("obs", row) then RETURN
		
		// Para la descripcion de la Factura
		lstr_param.string1   = 'Descripcion de Orden de Venta'
		lstr_param.string2	 = this.object.obs [row]
	
		OpenWithParm( w_descripcion_fac, lstr_param)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
				This.object.obs [row] = left(lstr_param.string3, 2000)
				this.ii_update = 1
		END IF	
		
	CASE 'b_banco'
		
		If this.is_protect("banco", row) then RETURN
		
		// Para la descripcion de la Factura
		lstr_param.string1   = 'Descripcion de Orden de Venta'
		lstr_param.string2	 = this.object.banco [row]
	
		OpenWithParm( w_descripcion_fac, lstr_param)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
				This.object.banco [row] = left(lstr_param.string3, 2000)
				this.ii_update = 1
		END IF			
END CHOOSE
end event

event dw_master::ue_str_parametros_det(long al_row);call super::ue_str_parametros_det;il_row = al_row
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF




end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 				= THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc(this)
end event

event dw_master::clicked;call super::clicked;// bloqua el flag de mercado si ya se ingreso un registro
// en el detalle de la Orden de venta

/*
IF dw_detail.rowcount( ) > 0 THEN
	this.object.flag_mercado.Protect = 1
ELSE
	this.object.flag_mercado.Protect = 0
END IF
*/
end event

type dw_detail from w_abc_mastdet`dw_detail within w_ve300_orden_venta
integer x = 0
integer y = 1516
integer width = 3822
integer height = 776
integer taborder = 50
string dataobject = "d_abc_articulo_mov_proy_ov_tbl"
borderstyle borderstyle = styleraised!
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
			ls_cnta_prsp , ls_origen ,ls_string   ,ls_evaluate	 , ls_columna
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
	
elseif lower(dwo.name) = 'cant_facturada' then
	
	if is_action = 'new' then return
	
	sl_param.number1 = this.object.nro_mov		[row]
	sl_param.string1 = this.object.cod_origen	[row]
	
	OpenSheetWithParm(w_ve765_facturas_x_ov, sl_param, w_main, 0, Layered!)
	return
end if


THIS.AcceptText()

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

event dw_detail::itemerror;call super::itemerror;return 1
end event

event dw_detail::ue_insert_pre;String 	ls_flag_estado
DateTime	ldt_now
Long 		ll_row

SELECT flag_aprobar_ov 
	INTO :ls_flag_estado 
FROM logparam 
WHERE reckey='1' ;

ldt_now = gnvo_app.of_fecha_Actual()

if dw_master.GetRow() = 0 then return
ll_row = dw_master.getrow()

this.object.cod_origen    			[al_row] = gs_origen
this.object.tipo_doc      			[al_row] = is_doc_ov
this.object.tipo_mov      			[al_row] = is_oper_vnta_terc
this.object.fec_registro  			[al_row] = ldt_now
this.object.fec_proyect   			[al_row] = Date(ldt_now)
this.object.cod_moneda    			[al_row] = dw_master.object.cod_moneda    [ll_row]
this.object.descuento 	  			[al_row] = 0
this.object.saldo_total	  			[al_row] = 0
this.object.cant_procesada			[al_row] = 0
this.object.cant_facturada			[al_row] = 0

IF dw_master.object.flag_mercado	[ll_row] = 'L' THEN
	this.object.tipo_impuesto1		[al_Row] = gnvo_app.finparam.is_igv
	this.object.porc_impuesto 	  	[al_row] = idc_tasa_igv
else
	this.object.tipo_impuesto1		[al_Row] = gnvo_app.is_null
	this.object.porc_impuesto 	  	[al_row] = 0
END IF

this.object.flag_estado	  			[al_row] = ls_flag_estado

if al_row > 1 then
	this.object.cnta_prsp 	  		[al_row] = this.object.cnta_prsp 	  	[al_row - 1]
end if

If IsNull(is_almacen) then is_almacen = ''

if is_almacen <> '' then
	this.object.almacen					[al_row] = is_almacen
else
	if al_row > 1 then
		this.object.almacen				[al_row] = this.object.almacen [al_row - 1]
	end if
end if
this.object.flag_replicacion 		[al_row] = '1'
this.object.flag_modificacion 	[al_row] = '1'
this.object.flag_fas					[al_row] = '1'
this.object.cod_usr					[al_row] = gs_user
this.object.cencos					[al_row] = is_CENCOS_PRSP_ING
this.object.flag_crg_inm_prsp		[al_row] = '1'  //La Orden de Venta ya va a afectar presupuesto


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

event dw_detail::itemchanged;call super::itemchanged;String 	ls_desc_art, ls_und, ls_cnta_prsp, ls_cencos ,ls_origen ,ls_cod_art,&
			ls_origen_alm, ls_flag_und2, ls_und_almacen, ls_mensaje
date 		ld_fecha
Long 		ll_count, ll_row
Decimal	ldc_precio_unit, ldc_precio_venta, ldc_cant_proyect, ldc_porc_dscto, ldc_porc_igv, &
			ldc_impuesto, ldc_descuento, ldc_tasa, ldc_cant_despacho, ldc_factor_conv_und, &
			ldc_cant_despacho_und2

try 
	this.Accepttext()
	
	ll_row = dw_master.getrow()
	
	CHOOSE CASE dwo.name
			
		CASE  'cant_proyect' 
			ldc_cant_proyect  	= Dec(This.object.cant_proyect		[row])
			ls_und 					= this.object.und				[row]
			ls_und_almacen			= this.object.und_almacen	[row]
			
			//Calculo la cant de despacho
			if gnvo_app.of_get_parametro('VENTAS_CONV_PROYECT_TO_DESPACHO', '1') = '1' THEN
				select usf_ap_conv_und(:ls_und, :ls_und_almacen, :ldc_cant_proyect)
					into :ldc_cant_despacho
				from dual;
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					This.object.cant_despacho				[row] = 0
					This.object.cant_despacho_und2		[row] = 0
					This.object.cant_proyect				[row] = 0
					MessageBox('Error', 'Ha ocurrido un error en la conversion de unidades. Funcion usf_ap_conv_und()' &
											+ '~r~nCodigo Articulo: ' + this.object.cod_art [row] &
											+ '~r~nUnd: ' + ls_und &
											+ '~r~nUnd Conv: ' + ls_und_almacen &
											+ '~r~nCantidad: ' + String(ldc_cant_proyect, '###,##0.0000'), StopSign!)
									
					return 1
				end if
				
				This.object.cant_despacho		[row]  	= ldc_cant_despacho
			end if
			
			//Calculo la segunda unidad
			if gnvo_app.of_get_parametro('VENTAS_CONV_UND1_TO_UND2', '1') = '1' THEN
				ldc_factor_conv_und 	= Dec(This.object.factor_conv_und	[row])
				ls_flag_und2			= This.object.flag_und2	[row]
				
				IF IsNull(ldc_cant_proyect) OR Dec(ldc_cant_proyect) <= 0 THEN
					gnvo_app.of_mensaje_error('Aviso', 'La Cantidad Proyectada no puede ser cero o negativa, revise')
					This.object.cant_despacho_und2	[row] = 0
					This.object.cant_proyect			[row] = 0
					This.object.cant_despacho			[row] = 0
					RETURN 1
				END IF
			
				if ls_flag_und2 = '1' and ldc_factor_conv_und <> 0 then
					ldc_cant_despacho_und2 = ldc_cant_despacho * ldc_factor_conv_und
				else
					ldc_cant_despacho_und2 = 0
				end if
				
				this.object.cant_despacho_und2 [row] = ldc_cant_despacho_und2
			
			end if
			
			//Calculamos el IGV
			ldc_precio_unit 	= Dec(This.object.precio_unit	[row])
			ldc_porc_dscto 	= Dec(This.object.porc_dscto 	[row])
			IF IsNull(ldc_porc_dscto) THEN
				ldc_porc_dscto = 0
				This.object.porc_dscto 	[row] = 0
				This.object.descuento 	[row] = 0
			END IF
			
			ldc_porc_igv 	= Dec(This.object.porc_impuesto  [row])
			
			IF IsNull(ldc_porc_igv) THEN
				ldc_porc_igv = 0
				This.object.porc_impuesto [row] = 0
			END IF
			
			ldc_descuento 	= ldc_precio_unit * ldc_porc_dscto / 100
			
			IF ldc_descuento > ldc_precio_unit THEN
				MessageBox('Aviso', 'El descuento no puede ser mayor que el importe', StopSign!)
				This.object.porc_dscto	[row] = 0
				This.object.descuento	[row] = 0
				RETURN 1
			END IF
			
			ldc_impuesto  = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_igv / 100
			
			This.object.descuento	[row] = ldc_descuento
			This.object.impuesto		[row] = ldc_impuesto
			
			
		CASE  'cant_despacho' 
			ldc_cant_despacho  	= Dec(This.object.cant_despacho		[row])
			ldc_factor_conv_und 	= Dec(This.object.factor_conv_und	[row])
			ls_flag_und2			= This.object.flag_und2	[row]
			
			IF IsNull(ldc_cant_despacho) OR Dec(ldc_cant_despacho) <= 0 THEN
				gnvo_app.of_mensaje_error('Aviso', 'La Cantidad de despacho no puede ser cero o negativa, revise')
				This.object.cant_despacho		[row] = 0
				RETURN 1
			END IF
			
			//Conversion a Cant Proyect
			if gnvo_app.of_get_parametro('VENTAS_CONV_DESPACHO_TO_PROYECT', '1') = '1' then
				ls_und 			= this.object.und				[row]
				ls_und_almacen	= this.object.und_almacen	[row]
				
				select usf_ap_conv_und(:ls_und_almacen, :ls_und, :ldc_cant_despacho)
					into :ldc_cant_proyect
				from dual;
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					This.object.cant_despacho				[row] = 0
					This.object.cant_despacho_und2		[row] = 0
					This.object.cant_proyect				[row] = 0
					MessageBox('Error', 'Ha ocurrido un error en la conversion de unidades. Funcion usf_ap_conv_und()' &
											+ '~r~nCodigo Articulo: ' + this.object.cod_art [row] &
											+ '~r~nUnd: ' + ls_und_almacen &
											+ '~r~nUnd Conv: ' + ls_und &
											+ '~r~nCantidad: ' + String(ldc_cant_despacho, '###,##0.0000'), StopSign!)
									
					return 1
				end if
				
				this.object.cant_proyect	[row] = ldc_cant_proyect
				
				//Calculamos el IGV
				ldc_precio_unit 	= Dec(This.object.precio_unit	[row])
				ldc_porc_dscto 	= Dec(This.object.porc_dscto 	[row])
				IF IsNull(ldc_porc_dscto) THEN
					ldc_porc_dscto = 0
					This.object.porc_dscto 	[row] = 0
					This.object.descuento 	[row] = 0
				END IF
				
				ldc_porc_igv 	= Dec(This.object.porc_impuesto  [row])
				
				IF IsNull(ldc_porc_igv) THEN
					ldc_porc_igv = 0
					This.object.porc_impuesto [row] = 0
				END IF
				
				ldc_descuento 	= ldc_precio_unit * ldc_porc_dscto / 100
				
				IF ldc_descuento > ldc_precio_unit THEN
					MessageBox('Aviso', 'El descuento no puede ser mayor que el importe', StopSign!)
					This.object.porc_dscto	[row] = 0
					This.object.descuento	[row] = 0
					RETURN 1
				END IF
				
				ldc_impuesto  = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_igv / 100
				
				This.object.descuento	[row] = ldc_descuento
				This.object.impuesto		[row] = ldc_impuesto
			
			end if
			
			//COnvertimos a und2
			if gnvo_app.of_get_parametro('VENTAS_CONV_UND1_TO_UND2', '1') = '1' THEN
				if ls_flag_und2 = '1' and ldc_factor_conv_und <> 0 then
					ldc_cant_despacho_und2 = ldc_cant_despacho * ldc_factor_conv_und
				else
					ldc_cant_despacho_und2 = 0
				end if
				
				this.object.cant_despacho_und2 [row] = ldc_cant_despacho_und2
			end if
			
	
		CASE  'cant_despacho_und2' 
				
			ldc_cant_despacho_und2  = Dec(This.object.cant_despacho_und2	[row])
			ldc_factor_conv_und 		= Dec(This.object.factor_conv_und		[row])
			ls_flag_und2				= This.object.flag_und2						[row]
			
			IF IsNull(ldc_cant_despacho_und2) OR Dec(ldc_cant_despacho_und2) <= 0 THEN
				gnvo_app.of_mensaje_error('Aviso', 'La Cantidad de despacho de Und2 no puede ser cero o negativa, revise')
				This.object.cant_despacho				[row] = 0
				This.object.cant_despacho_und2		[row] = 0
				This.object.cant_proyect				[row] = 0
				RETURN 1
			END IF
			
			//CAlculo la cantidad de despacho
			if ls_flag_und2 <> '1' then
				MessageBox('Error', 'El articulo ' + this.object.cod_art [row] + ' no tiene conversión de Segunda Unidad, por favor verifique!', StopSign!)
			end if
			
			if ldc_factor_conv_und = 0 then
				MessageBox('Error', 'El articulo ' + this.object.cod_art [row] + ' no tiene no ha indicado factor de conversión de Und1 a Und2, por favor verifique!', StopSign!)
			end if
			
			ldc_cant_despacho = ldc_cant_despacho_und2 / ldc_factor_conv_und
			
			//Si esta activo el FLAG hago el cambio
			if gnvo_app.of_get_parametro('VENTAS_CONV_UND2_TO_UND1', '1') = '1' THEN
				
				this.object.cant_despacho 	[row] = ldc_cant_despacho
			end if
			
			//Si esta activo el flag hago el cambio
			if gnvo_app.of_get_parametro('VENTAS_CONV_DESPACHO_TO_PROYECT', '1') = '1' then
				
				ls_und 			= this.object.und				[row]
				ls_und_almacen	= this.object.und_almacen	[row]
				
				select usf_ap_conv_und(:ls_und_almacen, :ls_und, :ldc_cant_despacho)
					into :ldc_cant_proyect
				from dual;
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					This.object.cant_despacho				[row] = 0
					This.object.cant_despacho_und2		[row] = 0
					This.object.cant_proyect				[row] = 0
					MessageBox('Error', 'Ha ocurrido un error en la conversion de unidades. Funcion usf_ap_conv_und()' &
											+ '~r~nCodigo Articulo: ' + this.object.cod_art [row] &
											+ '~r~nUnd: ' + ls_und_almacen &
											+ '~r~nUnd Conv: ' + ls_und &
											+ '~r~nCantidad: ' + String(ldc_cant_despacho, '###,##0.0000'), StopSign!)
									
					return 1
				end if
				
				this.object.cant_proyect	[row] = ldc_cant_proyect
				
				//Calculamos el IGV
				ldc_precio_unit 	= Dec(This.object.precio_unit	[row])
				ldc_porc_dscto 	= Dec(This.object.porc_dscto 	[row])
				IF IsNull(ldc_porc_dscto) THEN
					ldc_porc_dscto = 0
					This.object.porc_dscto 	[row] = 0
					This.object.descuento 	[row] = 0
				END IF
				
				ldc_porc_igv 	= Dec(This.object.porc_impuesto  [row])
				
				IF IsNull(ldc_porc_igv) THEN
					ldc_porc_igv = 0
					This.object.porc_impuesto [row] = 0
				END IF
				
				ldc_descuento 	= ldc_precio_unit * ldc_porc_dscto / 100
				
				IF ldc_descuento > ldc_precio_unit THEN
					MessageBox('Aviso', 'El descuento no puede ser mayor que el importe', StopSign!)
					This.object.porc_dscto	[row] = 0
					This.object.descuento	[row] = 0
					RETURN 1
				END IF
				
				ldc_impuesto  = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_igv / 100
				
				This.object.descuento	[row] = ldc_descuento
				This.object.impuesto		[row] = ldc_impuesto
			end if
	
			
		 CASE 'cod_art'
			// Verifica que codigo ingresado exista			
			SELECT a.desc_art, a.und, a2.CNTA_PRSP_INGRESO, nvl(a.flag_und2, '0'), nvl(a.factor_conv_und, 0.00)
				into :ls_desc_art, :ls_und, :ls_cnta_prsp, :ls_flag_und2, :ldc_factor_conv_und
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
				This.object.cod_art			[row] = gnvo_app.is_null
				This.object.desc_art			[row] = gnvo_app.is_null
				This.object.und				[row] = gnvo_app.is_null
				This.object.cnta_prsp		[row] = gnvo_app.is_null
				This.object.flag_und2		[row] = '0'
				This.object.factor_conv_und[row] = 0.00
				RETURN 1
			END IF
			
			This.object.desc_Art			[row] = ls_desc_art
			This.object.und				[row] = ls_und				
			This.object.cnta_prsp		[row] = ls_cnta_prsp
			This.object.flag_und2		[row] = ls_flag_und2
			This.object.factor_conv_und[row] = ldc_factor_conv_und
			
			of_set_articulo(data, row)
		
		CASE 'almacen' 
			SELECT cod_origen
				into :ls_origen_alm
			FROM almacen 
			WHERE almacen = :data
			 AND  flag_Estado = '1';
	
			
			IF SQLCA.SQLCode = 100 THEN
				MessageBox('Aviso', 'Codigo de Almacen no existe o no esta activo')
				This.object.almacen			[row] = gnvo_app.is_null
				This.object.cod_origen_alm [row] = gnvo_app.is_null
				RETURN 1
			END IF
			
			This.object.cod_origen_alm [row] = ls_origen_alm
		
		CASE 'precio_unit'
			ldc_precio_unit  = Dec(This.object.precio_unit[row])
			ldc_cant_proyect = Dec(This.object.cant_proyect[row])
			
			IF IsNull(ldc_precio_unit) OR ldc_precio_unit = 0 THEN
				gnvo_app.of_mensaje_error('El precio unit no puede ser cero o estar en blanco')
				This.object.descuento	[row] = 0
				This.object.impuesto		[row] = 0	
				RETURN 1
			END IF
			
			//Calculo el descuento
			ldc_porc_dscto 	= Dec(This.object.porc_dscto[row])
			
			IF IsNull(ldc_porc_dscto) THEN
				ldc_porc_dscto = 0
				this.object.porc_dscto[row] = 0
			END IF
			
			ldc_descuento = ldc_precio_unit * ldc_porc_dscto / 100;
			
			IF ldc_descuento > ldc_precio_unit THEN
				MessageBox('Aviso', 'El descuento no puede ser mayor que el importe', StopSign!)
				This.object.porc_dscto	[row] = 0
				This.object.descuento	[row] = 0
				RETURN 1
			END IF
	
			//Obtengo el porcentaje de Impuesto
			ldc_porc_igv 	= Dec(This.object.porc_impuesto[row])
			
			IF IsNull(ldc_porc_igv) THEN
				ldc_porc_igv = 0
				this.object.porc_impuesto[row] = 0
			END IF
			
			
			ldc_impuesto = round((ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_igv / 100,4)
			
			if ldc_cant_proyect <> 0 then
				ldc_precio_venta = ldc_precio_unit - ldc_descuento + ldc_impuesto / ldc_cant_proyect
			else
				ldc_precio_venta = ldc_precio_unit - ldc_descuento
			end if
	
			This.object.impuesto			[row] = ldc_impuesto	
			this.object.descuento		[row] = ldc_descuento
			this.object.precio_venta	[row] = ldc_precio_venta
	
		
		CASE 'precio_venta'
			ldc_precio_venta = Dec(data)
		
			IF ldc_precio_venta < 0 THEN
				This.object.precio_unit	[row] = 0
				This.object.descuento	[row] = 0
				This.object.impuesto		[row] = 0
				Messagebox( "Atencion", "Error en articulo " + this.object.cod_art [row] + ", Precio no puede ser negativo, por favor verifique!", StopSign!)
				RETURN 1
			END IF
	
			//Obtengo el porcentaje de descuento
			ldc_porc_dscto = Dec(This.object.porc_dscto[row])
			IF IsNull(ldc_porc_dscto) THEN
				ldc_porc_dscto = 0
				This.object.porc_dscto [row] = 0
			END IF
			
			//Obtengo el porcentaje de Impuesto
			ldc_porc_igv 	= Dec(This.object.porc_impuesto[row])
			
			IF IsNull(ldc_porc_igv) THEN
				ldc_porc_igv = 0
				this.object.porc_impuesto[row] = 0
			END IF
			
			IF dw_master.object.flag_mercado[ll_row] = 'L' THEN
				
				ldc_precio_unit  = ldc_precio_venta/( (1 + ldc_porc_igv/100) * (1 - ldc_porc_dscto/100))
				This.object.precio_unit[row] = ldc_precio_unit
				This.object.precio_fas [row] = ldc_precio_unit
				
			ELSE
				ldc_precio_unit = ldc_precio_venta
				ldc_porc_igv = 0
				This.object.precio_unit		[row] = ldc_precio_unit
				This.object.precio_fas 		[row] = ldc_precio_unit
				this.object.tipo_impuesto1	[row] = gnvo_app.is_null
				this.object.impuesto			[row] = 0.00
			END IF
			
			ldc_cant_proyect = Dec(This.object.cant_proyect[row])
			
			ldc_descuento = ldc_precio_unit * ldc_porc_dscto / 100
			ldc_impuesto = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_igv / 100
			
			
			This.object.descuento	[row] = ldc_descuento
			This.object.impuesto		[row] = ldc_impuesto
	
		CASE 'porc_dscto' 
			ldc_precio_unit  = Dec(This.object.precio_unit[row])
			ldc_cant_proyect = Dec(This.object.cant_proyect[row])
			
			IF IsNull(ldc_precio_unit) OR ldc_precio_unit = 0 THEN
				MessageBox('Aviso', 'El precio unitario no puede ser cero o estar en blanco', StopSign!)
				This.object.descuento	[row] = 0
				This.object.impuesto		[row] = 0		
				RETURN 1
			END IF
			
			ldc_porc_dscto = Dec(data)
			IF IsNull(ldc_porc_dscto) THEN
				ldc_porc_dscto = 0
				This.object.porc_dscto 	[row] = 0
				This.object.descuento 	[row] = 0
			END IF
			
			ldc_porc_igv 	= Dec(This.object.porc_impuesto  [row])
			
			IF IsNull(ldc_porc_igv) THEN
				ldc_porc_igv = 0
				This.object.porc_impuesto [row] = 0
			END IF
			
			ldc_descuento 	= ldc_precio_unit * ldc_porc_dscto / 100
			
			IF ldc_descuento > ldc_precio_unit THEN
				MessageBox('Aviso', 'El descuento no puede ser mayor que el importe', StopSign!)
				This.object.porc_dscto	[row] = 0
				This.object.descuento	[row] = 0
				RETURN 1
			END IF
			
			ldc_impuesto  = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_igv / 100
			
			This.object.descuento	[row] = ldc_descuento
			This.object.impuesto		[row] = ldc_impuesto
	
		CASE 'descuento' 
			
			ldc_precio_unit = Dec(This.object.precio_unit[row])
			ldc_cant_proyect= Dec(This.object.cant_proyect[row])
			
			IF IsNull(ldc_precio_unit) OR Dec(ldc_precio_unit) = 0 THEN
				MessageBox('Aviso', 'El precio unit no puede ser cero o estar en blanco')
				This.object.descuento		[row] = 0
				This.object.impuesto		[row] = 0	
				RETURN 1
			END IF
			
			ldc_descuento = Dec(data)
			
			IF ldc_descuento > Dec(this.object.precio_unit[row]) THEN
				MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
				This.object.porc_dscto	[row] = 0
				This.object.descuento	[row] = 0
				RETURN 1
			END IF
			
			ldc_porc_igv = Dec(This.object.porc_impuesto  [row])
			ldc_impuesto = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_igv / 100
			
			This.object.porc_dscto[row] = round(ldc_descuento/ldc_precio_unit * 100,2)
			This.object.impuesto	 [row] = ldc_impuesto
	
		CASE 'tipo_impuesto1'
			SELECT tasa_impuesto
				into :ldc_tasa
			FROM impuestos_tipo
			WHERE Tipo_impuesto = :data;
			
			IF SQLCA.SQLCode = 100 THEN
				MessageBox('Aviso', 'Tipo de Impuesto ' + trim(data) + ' no existe, por favor verifique', StopSign!)
				This.object.tipo_impuesto1	[row] = gnvo_app.is_null
				This.object.porc_impuesto	[row] = 0
				This.object.impuesto			[row] = 0
				RETURN 1
			END IF
			
			this.object.porc_impuesto	[row] = ldc_tasa
			
			//Calculo el impuesto
			ldc_precio_unit  = Dec(This.object.precio_unit[row])
			ldc_cant_proyect = Dec(This.object.cant_proyect[row])
			
			IF IsNull(ldc_precio_unit) OR Dec(ldc_precio_unit) = 0 THEN
				MessageBox('Aviso', 'El precio unit no puede ser cero o estar en blanco')
				This.object.descuento		[row] = 0
				This.object.impuesto		[row] = 0	
				RETURN 1
			END IF
			
			ldc_descuento = Dec(This.object.descuento[row])
			
			IF ldc_descuento > ldc_precio_unit THEN
				MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
				This.object.porc_dscto	[row] = 0
				This.object.descuento	[row] = 0
				RETURN 1
			END IF
				
			ldc_impuesto = round((ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_tasa / 100,4)
			This.object.impuesto		[row] = ldc_impuesto	
	
		CASE 'porc_impuesto'
			
			ldc_precio_unit  = Dec(This.object.precio_unit[row])
			ldc_cant_proyect = Dec(This.object.cant_proyect[row])
			
			IF IsNull(ldc_precio_unit) OR Dec(ldc_precio_unit) = 0 THEN
				MessageBox('Aviso', 'El precio unit no puede ser cero o estar en blanco')
				This.object.descuento		[row] = 0
				This.object.impuesto		[row] = 0	
				RETURN 1
			END IF
			
			ldc_descuento = Dec(This.object.descuento[row])
			
			IF ldc_descuento > ldc_precio_unit THEN
				MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
				This.object.porc_dscto	[row] = 0
				This.object.descuento		[row] = 0
				RETURN 1
			END IF
				
			ldc_porc_igv 	= Dec(data)
		
			ldc_impuesto = round((ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_igv / 100,4)
			This.object.impuesto		[row] = ldc_impuesto	
		
		CASE  'impuesto' 
			ldc_precio_unit  = Dec(This.object.precio_unit[row])
			ldc_cant_proyect = Dec(This.object.cant_proyect[row])
			
			IF IsNull(ldc_precio_unit) OR Dec(ldc_precio_unit) = 0 THEN
				MessageBox('Aviso', 'El precio unit no puede ser cero o estar en blanco')
				This.object.descuento		[row] = 0
				This.object.impuesto		[row] = 0	
				RETURN 1
			END IF
			
			ldc_descuento = Dec(This.object.descuento[row])
			
			IF ldc_descuento > ldc_precio_unit THEN
				MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
				This.object.porc_dscto	[row] = 0
				This.object.descuento		[row] = 0
				RETURN 1
			END IF
			
			ldc_impuesto = Dec(data)
			ldc_porc_igv = round(ldc_porc_igv / ( (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect) * 100,2)
			This.object.porc_impuesto	[row] = ldc_porc_igv
			
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
					and p.cod_usr = :gs_user
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
				
				this.object.cencos [row] = gnvo_app.is_null
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
				this.object.cencos [row] = gnvo_app.is_null
				return 1
			end if	
			
	END CHOOSE

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Evento Itemchanged')
	
end try






end event

event dw_detail::getfocus;if dw_master.getrow() = 0 then return
of_valida_cabecera()	// Verifica que exista la cuenta presupuestal


end event

event dw_detail::clicked;call super::clicked;of_set_status_doc(this)
end event

event dw_detail::ue_display;call super::ue_display;boolean 				lb_ret
string 				ls_codigo, ls_data, ls_sql, ls_und, ls_cnta_prsp, ls_tasa, ls_origen, &
						ls_cod_art, ls_cencos, ls_mensaje, ls_tipo_precio, ls_und2
Decimal				ldc_precio_unit, ldc_cant_proyect, ldc_descuento, ldc_impuesto, ldc_precio_venta, &
						ldc_porc_igv, ldc_factor_conv_und
Long					ll_count
str_parametros		lstr_param
str_articulo		lstr_articulo

choose case lower(as_columna)
	case "cod_art"
		ls_tipo_precio = dw_master.object.flag_tipo_precio [1]
		
		IF gs_empresa = "SERVIMOTOR" THEN
			
			OpenWithParm (w_pop_articulos_venta, parent)
			lstr_param = MESSAGE.POWEROBJECTPARM
			IF lstr_param.titulo <> 'n' then
				this.object.cod_art			[al_row] = lstr_param.field_ret[1]
				this.object.desc_art			[al_row] = lstr_param.field_ret[2]
				this.object.und				[al_row] = lstr_param.field_ret[3]	
				this.object.cnta_prsp		[al_row] = lstr_param.field_ret[7]
				
				if not of_set_articulo(lstr_param.field_ret[1], al_row) then return
				
				this.object.almacen			[al_row] = lstr_param.field_ret[8]
				this.object.cant_proyect	[al_row] = Dec(lstr_param.field_ret[9])
				
				this.ii_update = 1
			END IF
			
		ELSE
			lstr_articulo = gnvo_app.almacen.of_get_articulos_all( ) //of_get_articulo_venta( ls_almacen )
	
			if lstr_articulo.b_Return then
				this.object.cod_art		[al_row] = lstr_articulo.cod_art
				this.object.desc_art		[al_row] = lstr_articulo.desc_art
				this.object.und			[al_row] = lstr_articulo.und
				this.object.cnta_prsp	[al_row] = lstr_articulo.cnta_prsp_ingreso
				
				if not of_set_articulo(lstr_articulo.cod_art, al_row) then return
				
				this.ii_update = 1				
			end if
			
		END IF

		
	case "almacen"
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
					  + "  and al.flag_estado = '1' " &
					  + "order by al.almacen " 
		end if			
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
		if ls_codigo <> '' then
			this.object.almacen			[al_row] = ls_codigo
			this.object.cod_origen_alm	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "tipo_impuesto1"
		
		ls_sql = "SELECT tipo_impuesto AS tipo_impuesto, " &
				 + "desc_impuesto as desc_impuesto, "&
				 + "tasa_impuesto AS tasa_impuesto " &
				 + "FROM impuestos_tipo " 
					 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_tasa, '2')
			
		if ls_codigo <> '' then
			this.object.tipo_impuesto1	[al_row] = ls_codigo
			this.object.porc_impuesto	[al_row] = Dec(ls_tasa)
			
			//Calculo el impuesto
			ldc_precio_unit  = Dec(This.object.precio_unit	[al_row])
			ldc_cant_proyect = Dec(This.object.cant_proyect	[al_row])
			
			IF IsNull(ldc_precio_unit) OR Dec(ldc_precio_unit) = 0 THEN
				gnvo_app.of_mensaje_error('El VALOR DE VENTA no puede ser cero o estar en blanco')
				This.object.descuento	[al_row] = 0
				This.object.impuesto		[al_row] = 0	
				RETURN 
			END IF
			
			ldc_descuento = Dec(This.object.descuento[al_row])
			
			IF ldc_descuento > ldc_precio_unit THEN
				MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
				This.object.porc_dscto	[al_row] = 0
				This.object.descuento	[al_row] = 0
				RETURN 
			END IF
				
			ldc_impuesto = round((ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * Dec(ls_tasa) / 100,4)
			
			if ldc_cant_proyect <> 0 then
				ldc_precio_venta = ldc_precio_unit - ldc_descuento + ldc_impuesto / ldc_cant_proyect 
			else
				ldc_precio_venta = ldc_precio_unit - ldc_descuento
			end if
			
			This.object.impuesto		[al_row] = ldc_impuesto	
			This.object.precio_venta[al_row] = ldc_precio_venta	
			
			
			this.ii_update = 1
		end if


	case "cencos_gasto"
		ls_origen  = this.object.cod_origen_alm [al_row] 
		ls_cod_art = this.object.cod_art 		 [al_row] 
			  
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
			this.object.cencos_gasto 	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cencos"

		// Solo muestra los centros de costo de Ingreso
		if is_flag_cnta_prsp = '1' then
			ls_sql = "select distinct cc.cencos as codigo_cencos, " &
					 + "cc.desc_cencos as descripcion_cencos " &
					 + "from centros_costo     cc, " &
					 + "presupuesto_partida    pp, " &
					 + "presup_usr_autorizdos  p " &
					 + "where pp.cencos = cc.cencos " &
					 + "and p.cencos = cc.cencos " &
					 + "and p.cod_usr = '" + gs_user + "' " &
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
			this.object.cencos 	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cnta_prsp"

		ls_cencos = this.object.cencos[al_row]
		
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
			this.object.cnta_prsp 	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "und"

		ls_cencos = this.object.cencos[al_row]
		
		if ls_Cencos = '' or IsNull(ls_Cencos) then
			MessageBox('Aviso', 'Debe ingresar un centro de costo valido')
			return
		end if
		
		// Solo muestra los centros de costo de Ingreso
		ls_sql = "select u.und as unidad, " &
				 + "u.desc_unidad as descripcion_unidad " &
				 + "from unidad u " &
				 + "where u.flag_estado = '1'"
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.und 	[al_row] = ls_codigo
			
			this.object.cant_despacho			[al_Row] = 0.00
			this.object.cant_despacho_und2	[al_Row] = 0.00
			this.ii_update = 1
		end if

end choose


end event

event dw_detail::buttonclicked;call super::buttonclicked;str_parametros lstr_param

if row = 0 then return

if lower(dwo.name) = 'b_desc_art' then
		
	If this.is_protect("desc_art", row) then RETURN
	
	// Para la descripcion de la Factura
	lstr_param.string1   = 'Descripcion del articulo o del servicio '
	lstr_param.string2	 = this.object.desc_art [row]

	OpenWithParm( w_descripcion_fac, lstr_param)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
	IF lstr_param.titulo = 's' THEN
			This.object.desc_art [row] = left(lstr_param.string3, 2000)
			this.ii_update = 1
	END IF	
	
elseif lower(dwo.name) = 'b_obs' then
		
	If this.is_protect("desc_art", row) then RETURN
	
	// Para la descripcion de la Factura
	lstr_param.string1   = 'Observacion del articulo'
	lstr_param.string2	 = this.object.observacion [row]

	OpenWithParm( w_descripcion_fac, lstr_param)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
	IF lstr_param.titulo = 's' THEN
			This.object.observacion [row] = left(lstr_param.string3, 2000)
			this.ii_update = 1
	END IF		
end if
end event

type st_nro from statictext within w_ve300_orden_venta
integer x = 23
integer y = 52
integer width = 238
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_buscar from commandbutton within w_ve300_orden_venta
integer x = 731
integer y = 52
integer width = 297
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;EVENT ue_update_request()   // Verifica actualizaciones pendientes
of_retrieve(sle_nro.text)
end event

type sle_nro from u_sle_codigo within w_ve300_orden_venta
integer x = 265
integer y = 52
integer width = 448
integer height = 76
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

type cb_duplicar from commandbutton within w_ve300_orden_venta
integer x = 2487
integer y = 236
integer width = 297
integer height = 184
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Duplicar"
end type

event clicked;SetPointer(HourGlass!)
of_duplicar()
SetPointer(Arrow!)
end event

type gb_1 from groupbox within w_ve300_orden_venta
integer width = 1115
integer height = 160
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

