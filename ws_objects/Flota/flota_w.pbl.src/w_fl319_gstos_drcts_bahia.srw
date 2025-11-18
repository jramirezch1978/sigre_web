$PBExportHeader$w_fl319_gstos_drcts_bahia.srw
forward
global type w_fl319_gstos_drcts_bahia from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_fl319_gstos_drcts_bahia
end type
type st_2 from statictext within w_fl319_gstos_drcts_bahia
end type
type em_nro_doc from editmask within w_fl319_gstos_drcts_bahia
end type
type st_3 from statictext within w_fl319_gstos_drcts_bahia
end type
type em_proveedor from editmask within w_fl319_gstos_drcts_bahia
end type
type cb_cencos from commandbutton within w_fl319_gstos_drcts_bahia
end type
type cb_cnta from commandbutton within w_fl319_gstos_drcts_bahia
end type
type cb_1 from commandbutton within w_fl319_gstos_drcts_bahia
end type
type cb_2 from commandbutton within w_fl319_gstos_drcts_bahia
end type
type em_tipo_doc from editmask within w_fl319_gstos_drcts_bahia
end type
end forward

global type w_fl319_gstos_drcts_bahia from w_abc_mastdet_smpl
integer width = 3017
integer height = 3396
string title = "Gastos Directos Bahia (FL319)"
string menuname = "m_mto_smpl_cslta"
st_1 st_1
st_2 st_2
em_nro_doc em_nro_doc
st_3 st_3
em_proveedor em_proveedor
cb_cencos cb_cencos
cb_cnta cb_cnta
cb_1 cb_1
cb_2 cb_2
em_tipo_doc em_tipo_doc
end type
global w_fl319_gstos_drcts_bahia w_fl319_gstos_drcts_bahia

type variables
string 	is_almacen, is_salir, is_ot_adm, is_forma_pago, &
			is_desc_forma_pago, is_labor, is_cencos_rsp, is_ejecutor, &
			is_ot_tipo, is_desc_ot_tipo, is_doc_gr, is_desc_cencos_rsp, &
			is_igv
decimal	ldc_porc_igv			
end variables

forward prototypes
public function integer of_retrieve (string as_tipo_doc, string as_nro_doc, string as_proveedor)
public function integer of_get_param ()
public function integer of_verificar_cxp ()
public function boolean of_set_articulo (string as_cod_art)
end prototypes

public function integer of_retrieve (string as_tipo_doc, string as_nro_doc, string as_proveedor);event ue_update_request( )

dw_master.Retrieve(as_tipo_doc, as_nro_doc, as_proveedor)
dw_detail.Retrieve(as_tipo_doc, as_nro_doc, as_proveedor)

dw_master.ii_protect = 0
dw_master.of_protect( )
dw_master.ii_update = 0

dw_detail.ii_protect = 0
dw_detail.of_protect( )
dw_detail.ii_update = 0

return 1 
end function

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

// busca Parametros iniciales en FL_PARAM
SELECT 	PAGO_CONTADO, LABOR_FLOTA, CENCOS_RSP, OT_ADM_FLOTA, 
			OT_TIPO_FLOTA, ALMACEN_FLOTA, EJECUTOR_FLOTA
	INTO 	:is_forma_pago, :is_labor, :is_cencos_rsp, :is_ot_adm,
			:is_ot_tipo, :is_almacen, :is_ejecutor
FROM fl_param 
where reckey = '1';

if sqlca.sqlcode = 100 then
	Messagebox( "Error en FL_PARAM", "no ha definido parametros en FL_PARAM")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error en FL_PARAM", ls_mensaje)
	return 0
end if

// busca FORMA_PAGO
if ISNULL( is_forma_pago ) or TRIM( is_forma_pago ) = '' then
	Messagebox("Error", "Defina forma de pago PAGO_CONTADO en FL_PARAM")
	return 0
end if

// busca LABOR_FLOTA
if ISNULL( is_labor ) or TRIM( is_labor ) = '' then
	Messagebox("Error", "Defina labor LABOR_FLOTA en FL_PARAM")
	return 0
end if

// busca CENCOS_RSP_FLOTA
if ISNULL( is_cencos_rsp) or TRIM( is_cencos_rsp) = '' then
	Messagebox("Error", "Defina CENCOS_RSP en FL_PARAM")
	return 0
end if

// busca OT_ADM_FLOTA
if ISNULL( is_ot_adm ) or TRIM( is_ot_adm ) = '' then
	Messagebox("Error", "Defina OT_ADM en FL_PARAM")
	return 0
end if

// busca OT_TIPO_FLOTA
if ISNULL( is_ot_tipo ) or TRIM( is_ot_tipo ) = '' then
	Messagebox("Error", "Defina OT_TIPO_FLOTA en FL_PARAM")
	return 0
end if

// busca ALMACEN_FLOTA
if ISNULL( is_almacen ) or TRIM( is_almacen ) = '' then
	Messagebox("Error", "Defina ALAMCEN_FLOTA en FL_PARAM")
	return 0
end if

// busca EJECUTOR_FLOTA
if ISNULL( is_ejecutor ) or TRIM( is_ejecutor ) = '' then
	Messagebox("Error", "Defina EJECUTOR en FL_PARAM")
	return 0
end if

// busca Parametros iniciales en LOGPARAM
SELECT 	DOC_GR
	INTO 	:is_doc_gr
FROM logparam
where reckey = '1';

if sqlca.sqlcode = 100 then
	Messagebox( "Error en LOGPARAM", "no ha definido parametros en LOGPARAM")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error en LOGPARAM", ls_mensaje)
	return 0
end if

// busca LOGPARAM
if ISNULL( is_doc_gr ) or TRIM( is_doc_gr ) = '' then
	Messagebox("Error", "Defina DOC_GR en LOGPARAM")
	return 0
end if

//Descripcion Forma Pago
select desc_forma_pago
	into :is_desc_forma_pago
from forma_pago
where forma_pago = :is_forma_pago;

if sqlca.sqlcode = 100 then
	Messagebox( "Error en FORMA_PAGO", "No existe Forma de Pago " + is_forma_pago)
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error en FORMA_PAGO", ls_mensaje)
	return 0
end if

// Descripción Ot_tipo
select descripcion
	into :is_desc_ot_tipo
from ot_tipo
where ot_tipo = :is_ot_tipo;

if sqlca.sqlcode = 100 then
	Messagebox( "Error en OT_TIPO", "No existe OT_TIPO " + is_ot_tipo)
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error en OT_TIPO", ls_mensaje)
	return 0
end if

// Descripción CENCOS_RSP
select desc_cencos
	into :is_desc_cencos_rsp
from centros_costo
where cencos = :is_cencos_rsp;

if sqlca.sqlcode = 100 then
	Messagebox( "Error en CENTROS_COSTO", "No existe CENTRO DE COSTO " + is_cencos_rsp)
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error en CENTROS_COSTO", ls_mensaje)
	return 0
end if

return 1
end function

public function integer of_verificar_cxp ();string 	ls_tipo_doc, ls_nro_doc, ls_proveedor
Long		ll_row, ll_count

if dw_master.GetRow() = 0 then return 0

ll_row = dw_master.GetRow()

ls_tipo_doc = dw_master.object.tipo_doc  [ll_row]
ls_nro_doc  = dw_master.object.nro_doc   [ll_row]
ls_proveedor= dw_master.object.proveedor [ll_row]

//Verifico si ya se ingreso este documento
select count(*)
  into :ll_count
from fl_gtos_drcts_bahia
where tipo_doc  = :ls_tipo_doc
  and nro_doc   = :ls_nro_doc
  and proveedor = :ls_proveedor;

if ll_count > 0 then
	MessageBox('Aviso', 'Documento ya ha sido ingresado anteriormente')
	return 0
end if

//Verifico que el documento existe en cntas x pagar
select count(*)
  into :ll_count
from cntas_pagar
where tipo_doc = :ls_tipo_doc
  and nro_doc  = :ls_nro_doc
  and cod_relacion = :ls_proveedor;

if ll_count > 0 then
	if MessageBox('Aviso', 'Documento ya existe en cuentas por pagar, desea continuar??', &
		Information!, YesNo!, 2)  = 2 then return 0
end if

return 1

end function

public function boolean of_set_articulo (string as_cod_art);string 	ls_almacen, ls_cod_clase, ls_proveedor, ls_moneda, &
			ls_tipo_impuesto, ls_signo, ls_cnta_prsp
date		ld_fecha
decimal	ldc_precio, ldc_saldo, ldc_impuesto, ldc_cantidad, &
			ldc_tasa_impuesto
Long		ll_row		

// Setea las variables x defecto de acuerdo al codigo de articulo
// x ejemplo el almacen tácito y el precio en articulo_precio_pactado

if dw_master.GetRow() = 0 then return false

ll_row = dw_master.GetRow()

ls_proveedor = dw_master.object.proveedor		[ll_row]
ls_moneda	 = dw_master.object.cod_moneda	[ll_row]
ld_fecha	 	 = Date(dw_master.object.fec_documento[ll_row])

if trim(ls_proveedor) = '' or IsNull(ls_proveedor) then
	MessageBox('Aviso', 'Debe indicar el proveedor en la cabecera de la Orden de Compra')
	return false
end if

if trim(ls_moneda) = '' or IsNull(ls_moneda) then
	MessageBox('Aviso', 'Debe indicar el proveedor en la cabecera de la Orden de Compra')
	return false
end if

//Obtengo la cuenta presupuestal de acuerdo a la subcategoría
select a.cnta_prsp_egreso
	into :ls_cnta_prsp
from 	articulo_sub_categ a,
		articulo				 b
where a.cod_sub_cat = b.sub_cat_art
  and b.cod_art = :as_cod_art;

////Obtengo el saldo del articulo en ese almacen
//select NVL(sldo_total, 0), 
//  into :ldc_saldo
//from articulo_almacen
//where cod_art = :as_cod_art
//  and almacen = :is_almacen;
//
//If SQLCA.SQlCode = 100 then ldc_saldo = 0
//
//dw_detail.object.saldo_almacen [dw_detail.GetRow()] = ldc_saldo

// Obtengo el precio pactado
//create or replace function usf_cmp_prec_compra_artic(
// 	asi_cod_art         in articulo.cod_art%TYPE,
// 	asi_proveedor       in proveedor.proveedor%type,
// 	adi_fec_reg         in orden_compra.fec_registro%type,
// 	asi_almacen         in almacen.almacen%TYPE,
//		asi_moneda          in moneda.cod_moneda%type
//) return number is

SELECT usf_cmp_prec_compra_artic(:as_cod_art, :ls_proveedor, :ld_fecha, :is_almacen, :ls_moneda)
	INTO :ldc_precio
FROM dual ;

if IsNull(ldc_precio) then ldc_precio = 0

ll_row = dw_detail.GetRow()

dw_detail.object.precio_unit 	[ll_row] = ldc_precio
dw_detail.object.cnta_prsp		[ll_row] = ls_cnta_prsp

ldc_cantidad = Dec(dw_detail.object.cantidad[ll_row])
ls_tipo_impuesto  = dw_detail.object.tipo_impuesto[ll_row]

select NVL(tasa_impuesto,0), NVL(signo, '+')
	into :ldc_tasa_impuesto, :ls_signo
from impuestos_tipo
where tipo_impuesto = :ls_tipo_impuesto;

ldc_impuesto = ldc_precio * ldc_tasa_impuesto / 100;

if ls_signo = '-' then ldc_impuesto = ldc_impuesto * -1
dw_detail.object.impuesto		[ll_row] = ldc_impuesto

return true
end function

on w_fl319_gstos_drcts_bahia.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl_cslta" then this.MenuID = create m_mto_smpl_cslta
this.st_1=create st_1
this.st_2=create st_2
this.em_nro_doc=create em_nro_doc
this.st_3=create st_3
this.em_proveedor=create em_proveedor
this.cb_cencos=create cb_cencos
this.cb_cnta=create cb_cnta
this.cb_1=create cb_1
this.cb_2=create cb_2
this.em_tipo_doc=create em_tipo_doc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.em_nro_doc
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.em_proveedor
this.Control[iCurrent+6]=this.cb_cencos
this.Control[iCurrent+7]=this.cb_cnta
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.em_tipo_doc
end on

on w_fl319_gstos_drcts_bahia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_nro_doc)
destroy(this.st_3)
destroy(this.em_proveedor)
destroy(this.cb_cencos)
destroy(this.cb_cnta)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.em_tipo_doc)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0   //hace que no se haga el retrieve del dw_master
ib_log = TRUE

if of_get_param() = 0 then 
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
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_update_pre;call super::ue_update_pre;/*Replicación*/
ib_update_check = TRUE

dw_master.of_set_flag_replicacion ()
dw_detail.of_set_flag_replicacion ()

IF is_action = 'anular' THEN RETURN

//Verificación de Data en Cabecera de Documento
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
END IF

//Verificación de Data en Detalle de Documento
IF f_row_Processing( dw_detail, "tabular") <> true then	
	ib_update_check = False	
	return
END IF

if dw_detail.RowCount() = 0 then
	MessageBox('Aviso', 'No puede grabar un documento sin detalle')
	return
end if

if is_action = 'new' then
	if of_verificar_cxp( ) = 0  then 
		ib_update_check = False		
		return
	end if
END IF
end event

event ue_update;//Ancestor Script Overriding
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf, ls_tipo_doc, ls_nro_doc, ls_proveedor

ls_crlf = char(13) + char(10)

if dw_master.ii_update = 0 and dw_detail.ii_update = 0 then return

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

if is_action = 'anular' then

	IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = "Se ha procedido al rollback"
			messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
		END IF
	END IF

	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = "Se ha procedido al rollback"
			messagebox("Error en Grabacion Master", ls_msg, StopSign!)
		END IF
	END IF

else
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = "Se ha procedido al rollback"
			messagebox("Error en Grabacion Master", ls_msg, StopSign!)
		END IF
	END IF
	
	IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = "Se ha procedido al rollback"
			messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
		END IF
	END IF

end if

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	
	if dw_master.GetRow() > 0 then
		ls_tipo_doc  = dw_master.Object.tipo_doc 	[dw_master.GetRow()]
		ls_nro_doc	 = dw_master.Object.nro_doc 	[dw_master.GetRow()]
		ls_proveedor = dw_master.Object.proveedor [dw_master.GetRow()]
		of_retrieve(ls_tipo_doc, ls_nro_doc, ls_proveedor)
	end if
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
	is_action = 'open'
END IF



end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
this.event ue_update_request()

str_parametros sl_param

sl_param.dw1 = "d_list_gsts_dircts_bahia_grd"   //"d_dddw_orden_compra_tbl"  // //
sl_param.titulo = "Ordenes de compra"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2], sl_param.field_ret[3])
	is_action = 'open'
END IF
end event

event ue_insert;//Ancestor Script Overriding
Long  ll_row

if idw_1 = dw_detail then
	if dw_master.GetRow() = 0 then
		MessageBox('Aviso', 'No puedes ingresar un detalle sin cabecera')
		return
	end if
else
	if dw_master.ii_update = 1 or dw_detail.ii_update = 1 then
		MessageBox('Aviso', 'No puedes ingresar otro documento si tienes pendientes cambios por grabar')
		return
	end if
	
	dw_master.Reset()
	dw_detail.Reset()
	
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_modify;//Ancetor Script Overriding
dw_master.of_protect()
dw_detail.of_protect()

if dw_master.GetRow() = 0 then return

if dw_master.object.flag_mat_serv [dw_master.GetRow()] = 'M' then
	dw_detail.object.servicio.protect = 1
	dw_detail.object.cod_art.Edit.Required  = 'Yes'
	dw_detail.object.servicio.Edit.Required = 'No'
else
	dw_detail.object.cod_art.protect = 1
	dw_detail.object.cod_art.Edit.Required  = 'No'
	dw_detail.object.servicio.Edit.Required = 'Yes'
end if

dw_master.object.flag_mat_serv.protect = 1
dw_master.object.tipo_doc.protect 		= 1
dw_master.object.nro_doc.protect 		= 1
dw_master.object.proveedor.protect 		= 1

if is_action <> 'anular' and is_Action <> 'new' then
	is_action = 'edit'
end if	
end event

event ue_anular;call super::ue_anular;if MessageBox('Aviso', 'Desea anular toda la transacción???', &
	Information!, YesNo!, 2) = 2 then return
	
dw_detail.event ue_delete_all( )
dw_master.event ue_delete( )
is_Action = 'anular'
end event

event ue_cancelar;call super::ue_cancelar;event ue_update_request( )

dw_master.Reset()
dw_detail.Reset()

dw_master.ii_update = 0
dw_detail.ii_update = 0
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_fl319_gstos_drcts_bahia
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 120
integer width = 2473
integer height = 964
string dataobject = "d_abc_gtos_drcts_bahia_ff"
boolean livescroll = false
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data1, ls_sql, ls_data2, ls_proveedor
choose case lower(as_columna)
		
	case "tipo_doc"
		
		ls_sql = "SELECT DT.TIPO_DOC as Tipo_documento, " &    
         	 + "DT.DESC_TIPO_DOC as descripcion_tipo_doc, " &
				 + "DT.NRO_LIBRO as numero_libro, " &
				 + "DT.TIPO_CRED_FISCAL as tipo_cred_fisal " &
				 + "FROM FINPARAM F, " &
				 + "DOC_GRUPO_RELACION  DGR, " &
				 + "DOC_TIPO DT " &
				 + "WHERE F.DOC_CXP = DGR.GRUPO " &
				 + "and DGR.TIPO_DOC = DT.TIPO_DOC " &
				 + "and F.RECKEY = '1' " &
				 + "and DT.FLAG_ESTADO = '1' " &
				 + "Order by dt.tipo_doc "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc			[al_row] = ls_codigo
			this.ii_update = 1
			of_verificar_cxp( )
		end if

	case "tipo_refer"
		
		ls_sql = "SELECT DT.TIPO_DOC as Tipo_documento, " &    
         	 + "DT.DESC_TIPO_DOC as descripcion_tipo_doc " &
				 + "FROM DOC_TIPO DT " &
				 + "WHERE DT.FLAG_ESTADO = '1' " &
				 + "Order by dt.tipo_doc "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_refer			[al_row] = ls_codigo
			this.ii_update = 1
		end if		

	case "proveedor"

		ls_sql = "SELECT proveedor as codigo_provedor, " &
				  + "nom_proveedor as razon_social, " &
				  + "ruc as RUC_proveedor " &
				  + "FROM PROVEEDOR " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data1, ls_data2, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data1
			this.object.ruc				[al_row] = ls_data2
			this.ii_update = 1
			of_verificar_cxp( )
		end if

	CASE "direccion_item"					
			
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
				 + "FROM DIRECCIONES " &
				 + "WHERE CODIGO = '" + ls_proveedor +"' " &
				 + "AND FLAG_USO = '1'"
												
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, "1")
		
		if ls_codigo <> "" then
			this.object.direccion_item	[al_row] = Integer(ls_codigo)
			this.object.direccion		[al_row] = ls_data1
			this.ii_update = 1
		end if
		
	case "cod_moneda"

		ls_sql = "SELECT cod_moneda as codigo_moneda, " &
				  + "descripcion as descripcion_moneda " &
				  + "FROM moneda " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, '2')
		
		if ls_codigo <> '' then
			this.object.cod_moneda		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cencos_rsp"

		ls_sql = "SELECT cencos as codigo_cencos, " &
				  + "desc_cencos as descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, '2')
		
		if ls_codigo <> '' then
			this.object.cencos_rsp		[al_row] = ls_codigo
			this.object.desc_cencos		[al_row] = ls_data1
			this.ii_update = 1
		end if		

	case "ot_tipo"

		ls_sql = "SELECT ot_tipo as tipo_ot, " &
				  + "descripcion as descripcion_ot_tipo " &
				  + "FROM ot_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, '2')
		
		if ls_codigo <> '' then
			this.object.ot_tipo		[al_row] = ls_codigo
			this.object.desc_ot_tipo[al_row] = ls_data1
			this.ii_update = 1
		end if		

	case "responsable"

		ls_sql = "SELECT proveedor as codigo_responsable, " &
				  + "nom_proveedor as nombre_responsable " &
				  + "FROM PROVEEDOR " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, '2')
		
		if ls_codigo <> '' then
			this.object.responsable		[al_row] = ls_codigo
			this.object.nom_responsable[al_row] = ls_data1
			this.ii_update = 1
		end if			
end choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro[al_row] = f_fecha_actual()
this.object.cod_usr		[al_row] = gs_user
this.object.cod_origen	[al_row] = gs_origen

//Datos de FL_PARAM
this.object.forma_pago 		[al_row] = is_forma_pago
this.object.desc_forma_pago[al_row] = is_desc_forma_pago
this.object.almacen			[al_row] = is_almacen
this.object.ot_adm_flota	[al_row] = is_ot_adm
this.object.ot_tipo			[al_row] = is_ot_tipo
this.object.desc_ot_tipo	[al_row] = is_desc_ot_tipo
this.object.labor_flota		[al_row] = is_labor
this.object.ejecutor_flota [al_row] = is_ejecutor
this.object.tipo_refer		[al_row] = is_doc_gr
this.object.cencos_rsp		[al_row] = is_cencos_rsp
this.object.desc_cencos		[al_row] = is_desc_cencos_rsp

is_Action = 'new'
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::constructor;call super::constructor; is_dwform = 'form' // tabular form
 ii_ck[1] = 1
 ii_ck[2] = 2
 ii_ck[3] = 3
 
is_mastdet = 'm'
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0

	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_data1, ls_null, ls_data2, ls_proveedor
Long		ll_count
Integer	li_item

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "tipo_doc"
		
		select count(*)
			into :ll_count
		from doc_tipo
		where tipo_doc = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "Tipo de Documento no existe, por favor verifique", StopSign!)
			this.object.tipo_doc			[row] = ls_null
			return 1
		end if
		
		of_verificar_cxp( )
		
	case "tipo_ref"
		
		select count(*)
			into :ll_count
		from doc_tipo
		where tipo_doc = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "Tipo de Documento no existe, por favor verifique", StopSign!)
			this.object.tipo_doc			[row] = ls_null
			return 1
		end if
		
	case "proveedor"
		
		select nom_proveedor, ruc
			into :ls_data1, :ls_data2
		from proveedor
		where proveedor = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "Codigo de Proveedor no existe o no esta activo, por favor verifique", StopSign!)
			this.object.proveedor		[row] = ls_null
			this.object.nom_proveedor	[row] = ls_null
			this.object.ruc				[row] = ls_null
			return 1
		end if

		this.object.nom_proveedor	[row] = ls_data1
		this.object.ruc				[row] = ls_data2
		of_verificar_cxp( )

	case "responsable"
		
		select nom_proveedor
			into :ls_data1
		from proveedor
		where proveedor = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "Codigo de Responsable no existe o no esta activo, por favor verifique", StopSign!)
			this.object.responsable		[row] = ls_null
			this.object.nom_responsable[row] = ls_null
			return 1
		end if

		this.object.nom_responsable[row] = ls_data1
		
	case 'direccion_item'
	
		ls_proveedor = dw_master.object.proveedor [row]		
		IF Isnull(ls_proveedor) OR Trim(ls_proveedor)  = "" THEN
			Messagebox("Aviso","Debe Ingresar Codigo de Proveedor, Verifique!")
			Return 
		END IF
		
		li_item = Integer(data)
		
		// Solo Tomo la Direccion de facturacion
		SELECT TRIM(DIR_DIRECCION) || ' ' || TRIM(DIR_DEP_ESTADO) || ' ' || TRIM(DIR_DISTRITO)
			into :ls_data1
		FROM DIRECCIONES 
		WHERE CODIGO 	= :ls_proveedor 
		  and item 		= :li_item
		  and flag_uso = '1';
												
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Item de Direccion no existe o no es de facturacion' + string(li_item))
			SetNull(li_item)
			this.object.direccion_item [row] = li_item
			this.object.direccion		[row] = ls_null
			return 1
		end if
		
		this.object.direccion [row] = ls_data1	
		
	case "cencos_rsp"
		
		select desc_cencos
			into :ls_data1
		from centros_costo
		where cencos = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "Centro de Costo no existe o no esta activo, por favor verifique", StopSign!)
			this.object.cencos		[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			return 1
		end if

		this.object.nom_cencos[row] = ls_data1	

	case "cod_moneda"
		
		select count(*)
			into :ll_count
		from moneda
		where cod_moneda = :data;
		
		if ll_count = 0 then
			Messagebox('FLOTA', "Tipo de Moneda no existe, por favor verifique", StopSign!)
			this.object.cod_moneda		[row] = ls_null
			return 1
		end if

	case "ot_tipo"
		
		select descripcion
			into :ls_data1
		from ot_tipo
		where ot_tipo = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "Tipo de OT no existe, por favor verifique", StopSign!)
			this.object.ot_tipo		[row] = ls_null
			this.object.desc_ot_tipo[row] = ls_null
			return 1
		end if

		this.object.desc_ot_tipo[row] = ls_data1	
	
	case 'flag_mat_serv'
		if dw_detail.RowCount() > 0 then
			MessageBox('Aviso', 'No puede cambiar el flag de Material/Servicio si ya existe detalle de documento')
			return 0
		end if
end choose
end event

event dw_master::buttonclicked;call super::buttonclicked;String 	ls_nro_doc
decimal 	ldc_vn, ldc_dcto, ldc_imp, ldc_vb
w_cm311_orden_compra_frm lw_1
str_parametros lstr_rep

if row = 0 then return

if dwo.name = 'b_oc' then
	
	ls_nro_doc = this.object.nro_oc[row]
	if ls_nro_doc = '' or IsNull(ls_nro_doc) then
		MessageBox('Aviso', 'No existe ningun nro de OC definido, verifique')
		return
	end if


	lstr_rep.string1 = this.object.origen_oc	[row]
	lstr_rep.string2 = ls_nro_doc
	
	select 	sum(precio_unit * cant_proyect), sum(decuento * cant_proyect), sum(impuesto)
		into 	:ldc_vb, :ldc_dcto, :ldc_imp
	from articulo_mov_proy
	where nro_doc = :ls_nro_doc
	  and tipo_doc = (select doc_oc from logparam where reckey = '1')
	  and flag_estado <> '0';
				
	ldc_vn = ldc_vb - ldc_dcto + ldc_imp
	
	lstr_rep.d_datos[1] = ldc_vb
	lstr_rep.d_datos[2] = ldc_dcto
	lstr_rep.d_datos[3] = ldc_imp
	lstr_rep.d_datos[4] = ldc_vn

	OpenSheetWithParm(lw_1, lstr_rep, w_main, 0, Layered!)
	
elseif dwo.name = 'b_ni' then	
	// vista previa de mov. almacen
	ls_nro_doc = this.object.nro_vale_ing [row]
	
	// Si esta anulado o sin VoBo no imprime
	IF ls_nro_doc = '' or IsNull(ls_nro_doc) THEN 
		MessageBox('Aviso', 'No existe un numero de Movimiento de Ingreso indicado')
		RETURN
	END IF
	
	
	lstr_rep.dw1 = 'd_frm_movimiento_almacen'
	lstr_rep.titulo = 'Previo de Movimiento de almacen'
	lstr_rep.string1 = this.object.org_vale_ing[row]
	lstr_rep.string2 = this.object.nro_vale_ing[row]
	
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)	
	
elseif dwo.name = 'b_os' then
	ls_nro_doc = this.object.nro_os [row]
	
	// Si esta anulado o sin VoBo no imprime
	IF ls_nro_doc = '' or IsNull(ls_nro_doc) THEN 
		MessageBox('Aviso', 'NO existe un numero de Orden de Servicio indicado')
		RETURN
	END IF
	
	lstr_rep.string1 = this.object.origen_os	[row]
	lstr_rep.string2 = this.object.nro_os		[row]
	
	OpenSheetWithParm(w_cm314_orden_servicio_frm, lstr_rep, w_main, 0, layered!)
	
end if
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fl319_gstos_drcts_bahia
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 1096
integer width = 2496
integer height = 664
string dataobject = "d_abc_gtos_drcts_bahia_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data1, ls_sql, ls_data2, ls_cencos, &
			ls_nave, ls_ot_tipo, ls_nro_ot
Integer	li_year
str_parametros sl_param
str_seleccionar lstr_seleccionar

dw_master.AcceptText()
dw_detail.accepttext( )

choose case lower(as_columna)
		
	case "cod_art"
		
		OpenWithParm (w_pop_articulos, parent)
		sl_param = MESSAGE.POWEROBJECTPARM
		IF sl_param.titulo <> 'n' then
			this.object.cod_art	[al_row] = sl_param.field_ret[1]
			this.object.desc_art	[al_row] = sl_param.field_ret[2]
			this.object.und		[al_row] = sl_param.field_ret[3]	
			
			of_set_articulo(sl_param.field_ret[1])
			
			this.ii_update = 1
		end if

	case "servicio"

		ls_sql = "SELECT s.servicio AS CODIGO_Servicio, " &
				 + "s.DESCRIPCION AS Descripcion_servicio, " &
				 + "b.cnta_prsp_egreso as cuenta_prsp " & 
				 + "FROM servicios s, " &
				 + "articulo_sub_categ b " &
				 + "where s.cod_sub_cat = b.cod_sub_cat " &
				 + "and S.flag_estado = '1'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data1, ls_data2, '1')
		
		if ls_codigo <> '' then
			this.object.servicio			[al_row] = ls_codigo
			this.object.desc_servicio	[al_row] = ls_data1
			this.object.cnta_prsp		[al_row] = ls_data2
			this.ii_update = 1
		end if
		
	case "nave"

		ls_sql = "SELECT nave AS CODIGO_nave, " &
				  + "nomb_nave AS nombre_nave, " &
				  + "cencos AS cencos_nave " &
				  + "FROM tg_naves " &
				  + "where flag_estado = '1' " &
				  + "and flag_tipo_flota = 'P'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data1, ls_data2, '1')
		
		if ls_codigo <> '' then
			this.object.nave			[al_row] = ls_codigo
			this.object.nomb_nave	[al_row] = ls_data1
			this.object.cencos		[al_row] = ls_data2
			this.ii_update = 1
		end if

	case 'cod_maquina'

		ls_sql = "SELECT cod_maquina AS codigo_maquina, " &
				  + "desc_maq AS descripcion_maquina " &
				  + "FROM maquina " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, '2')
		
		if ls_codigo <> '' then
			this.object.cod_maquina	[al_row] = ls_codigo
			this.object.desc_maq		[al_row] = ls_data1
			this.ii_update = 1
		end if	

	case 'cencos'
		li_year = Year(Date(dw_master.object.fec_documento[dw_master.GetRow()]))

		ls_sql = "SELECT distinct cc.cencos AS codigo_cencos, " &
				  + "cc.desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo cc, " &
				  + "presupuesto_partida pp " &
				  + "where cc.cencos = pp.cencos " &
				  + "and pp.flag_estado <> '0' " &
				  + "and cc.flag_estado = '1' " &
				  + "and pp.ano = " + string(li_year)
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, '1')
		
		if ls_codigo <> '' then
			this.object.cencos	[al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case 'cnta_prsp'
		li_year = Year(Date(dw_master.object.fec_documento[dw_master.GetRow()]))
		ls_cencos = this.object.cencos [al_row]

		ls_sql = "SELECT distinct pc.cnta_prsp AS codigo_cnta_prsp, " &
				  + "pc.descripcion AS descripcion_cnta_prsp " &
				  + "FROM presupuesto_cuenta pc, " &
				  + "presupuesto_partida pp " &
				  + "where pc.cnta_prsp = pp.cnta_prsp " &
				  + "and pp.flag_estado <> '0' " &
				  + "and pc.flag_estado = '1' " &
				  + "and pp.cencos = '" + ls_cencos + "' " &
				  + "and pp.ano = " + string(li_year) 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp	[al_row] = ls_codigo
			this.ii_update = 1
		end if			
	
	case 'tipo_impuesto'
	
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
			this.object.tipo_impuesto [al_row] = lstr_seleccionar.param1[1]
			
			
			this.object.impuesto	[al_row] = this.object.precio_unit[al_row] * lstr_seleccionar.paramdc3[1] /100
			if lstr_seleccionar.param4[1] = '-' then 
				this.object.impuesto [al_row] = this.object.impuesto[al_row] * -1
			END IF
			
			this.ii_update = 1
		END IF
	
	case 'nro_orden'
		ls_nave = this.object.nave[al_row]
		ls_ot_tipo = dw_master.object.ot_tipo [dw_master.GetRow()]
		if Not IsNull(ls_nave) and ls_nave <> '' then
			ls_sql = "SELECT ot.nro_orden as numero_orden, " &
					 + "ot.ot_adm as codigo_ot_adm, " &
					 + "ot.titulo as titulo_ot, " &
					 + "ot.fec_inicio as fecha_inicio " &
					 + "FROM fl_ot_nave a, " &
					 + "orden_trabajo ot " &
					 + "where ot.nro_orden = a.nro_orden " &
					 + "and ot.flag_estado in ('1', '3') " &
					 + "and a.nave = '" + ls_nave + "' " &
					 + "and ot.ot_adm = '" + is_ot_adm + "' " &
					 + "and ot_tipo = '" + ls_ot_tipo + "'"
		else
			ls_sql = "SELECT ot.nro_orden as numero_orden, " &
					 + "ot.ot_adm as codigo_ot_adm, " &
					 + "ot.titulo as titulo_ot, " &
					 + "ot.fec_inicio as fecha_inicio " &
					 + "FROM orden_trabajo ot " &
					 + "where ot.flag_estado in ('1', '3') " &
					 + "and ot.ot_adm = '" + is_ot_adm + "' " &
					 + "and ot_tipo = '" + ls_ot_tipo + "'"
		end if
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, '1')
		
		if ls_codigo <> '' then
			this.object.nro_orden	[al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case 'oper_sec'
		ls_nro_ot = this.object.nro_orden[al_row]
		
		if IsNull(ls_nro_ot) or ls_nro_ot = '' then
			MessageBox('Aviso', 'Debes ingresar un Numero de Orden de Trabajo')
			return
		end if

		ls_sql = "SELECT oper_sec as codigo_oper_sec, " &
				 + "desc_operacion as descripcion_operacion " &
				 + "FROM operaciones " &
				 + "where flag_estado = '1' " &
				 + "and nro_orden = '" + ls_nro_ot + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data1, '1')
		
		if ls_codigo <> '' then
			this.object.oper_sec	[al_row] = ls_codigo
			this.ii_update = 1
		end if			
		
end choose

end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4

is_mastdet = 'm'      // 'm' = master sin detalle (default), 'd' =  detalle,

end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

event dw_detail::clicked;call super::clicked;if f_row_processing(dw_master, 'form') = false then 
	dw_master.PostEvent(clicked!)
	return 
end if

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;string 	ls_mat_serv
Long		ll_row
if dw_master.GetRow() = 0 then return

ll_row = dw_master.GetRow()
ls_mat_serv = dw_master.object.flag_mat_serv[ll_row]

if ls_mat_serv = 'M' then
	this.object.servicio.protect = 1
	this.object.cod_art.Edit.Required  = 'Yes'
	this.object.servicio.Edit.Required = 'No'
else
	this.object.cod_art.protect = 1
	this.object.cod_art.Edit.Required  = 'No'
	this.object.servicio.Edit.Required = 'Yes'
end if

this.object.nro_item	[al_row] = f_numera_item(dw_detail)
this.object.tipo_doc	[al_row] = dw_master.Object.tipo_doc  [ll_row]
this.object.nro_doc	[al_row] = dw_master.Object.nro_doc	  [ll_row]
this.object.proveedor[al_row] = dw_master.Object.proveedor [ll_row]
this.object.cod_moneda   [al_row] = dw_master.Object.cod_moneda [ll_row]
this.object.cod_moneda_1 [al_row] = dw_master.Object.cod_moneda [ll_row]
this.object.cod_moneda_2 [al_row] = dw_master.Object.cod_moneda [ll_row]
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_detail::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0

	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_detail::itemchanged;call super::itemchanged;string 	ls_data1, ls_data2, ls_null, ls_impuesto, ls_signo
decimal	ldc_tasa, ldc_impuesto, ldc_precio
Long		ll_count

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "cod_art"
		
		select desc_art, und
			into :ls_data1, :ls_data2
		from articulo
		where cod_art = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE ARTICULO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cod_art	[row] = ls_null
			this.object.desc_art	[row] = ls_null
			this.object.und		[row] = ls_null
			return 1
		end if

		this.object.desc_art	[row] = ls_data1
		this.object.und		[row] = ls_data2
		
		of_set_articulo( data )

	case "servicio"
		
		SELECT DESCRIPCION, cnta_prsp_egreso 
			into :ls_data1, :ls_data2
		FROM 	servicios s, 
				articulo_sub_categ b 
		where s.cod_sub_cat = b.cod_sub_cat 
		  and s.servicio = :data
		  and s.flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE SERVICIO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.servicio			[row] = ls_null
			this.object.desc_servicio	[row] = ls_null
			return 1
		end if

		this.object.desc_servicio	[row] = ls_data1
		this.object.cnta_prsp		[row] = ls_data2

	case "nave"
		
		SELECT nomb_nave, cencos
			into :ls_data1, :ls_data2
		FROM 	tg_naves 
		where nave = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE NAVE NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.nave		[row] = ls_null
			this.object.nomb_nave[row] = ls_null
			return 1
		end if

		this.object.nomb_nave	[row] = ls_data1
		this.object.cencos		[row] = ls_data2		

	case "cod_maquina"
		
		SELECT desc_maq
			into :ls_data1
		FROM 	maquina 
		where cod_maquina = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE MAQUINA NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cod_maq	[row] = ls_null
			this.object.desc_maq	[row] = ls_null
			return 1
		end if

		this.object.desc_maq	[row] = ls_data1

	case 'precio_unit'
		ls_impuesto = this.object.tipo_impuesto[row]
		
		If IsNull(ls_impuesto) or ls_impuesto = '' then
			return 1
		end if
		
		select tasa_impuesto, signo
			into :ldc_tasa, :ls_signo
		from impuestos_tipo
		where tipo_impuesto = :ls_impuesto;

		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "Tipo de Impuesto no existe", StopSign!)
			this.object.cod_maq	[row] = ls_null
			this.object.desc_maq	[row] = ls_null
			return 1
		end if
		
		ldc_impuesto = Dec(data) * ldc_tasa / 100;
		
		if ls_signo = '-' then ldc_impuesto = ldc_impuesto * -1
		
		this.object.impuesto [row] = ldc_impuesto

	case 'tipo_impuesto'
		ldc_precio = Dec(this.object.precio_unit[row])
		
		select tasa_impuesto, signo
			into :ldc_tasa, :ls_signo
		from impuestos_tipo
		where tipo_impuesto = :data;

		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "Tipo de Impuesto no existe", StopSign!)
			this.object.cod_maq	[row] = ls_null
			this.object.desc_maq	[row] = ls_null
			return 1
		end if
		
		ldc_impuesto = ldc_precio * ldc_tasa / 100;
		
		if ls_signo = '-' then ldc_impuesto = ldc_impuesto * -1
		
		this.object.impuesto [row] = ldc_impuesto		

	case "cencos"
		
		SELECT count(*)
			into :ll_count
		FROM 	centros_costo 
		where cencos = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CENTRO DE COSTO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cencos	[row] = ls_null
			return 1
		end if

	case "cnta_prsp"
		
		SELECT count(*)
			into :ll_count
		FROM 	presupuesto_cuenta 
		where cnta_prsp = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CUENTA PRESUPUESTAL NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cnta_prsp	[row] = ls_null
			return 1
		end if		

	case "nro_orden"
		
		SELECT count(*)
			into :ll_count
		FROM 	orden_trabajo 
		where nro_orden = :data
		  and flag_estado in ('1', '3');
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "ORDEN DE TRABAJO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.nro_orden	[row] = ls_null
			return 1
		end if

	case "oper_sec"
		ls_data1 = this.object.nro_orden [row]
		
		if IsNull(ls_data1) or ls_data1 = '' then
			MessageBox('Aviso', 'Debe ingresar un numero de orden de trabajo')
			return 1
		end if
		
		SELECT count(*)
			into :ll_count
		FROM 	operaciones
		where oper_sec = :data
		  and nro_orden = :ls_data1
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "OPER_SEC NO EXISTE, NO ESTA ACTIVO O NO CORRESPONDE A LA ORDEN DE TRABAJO", StopSign!)
			this.object.oper_sec	[row] = ls_null
			return 1
		end if		
		
end choose
end event

event dw_detail::buttonclicked;call super::buttonclicked;str_parametros lstr_rep
if dwo.name = 'b_vs' then	
	// vista previa de mov. almacen
	
	lstr_rep.dw1 = 'd_frm_movimiento_almacen'
	lstr_rep.titulo = 'Previo de Movimiento de almacen'
	lstr_rep.string1 = this.object.org_am_sal [row]
	lstr_rep.string2 = this.object.nro_vale	[row]
	
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)	
end if
end event

type st_1 from statictext within w_fl319_gstos_drcts_bahia
integer x = 23
integer y = 20
integer width = 215
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Doc:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl319_gstos_drcts_bahia
integer x = 549
integer y = 20
integer width = 361
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Documento:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_nro_doc from editmask within w_fl319_gstos_drcts_bahia
integer x = 919
integer y = 8
integer width = 302
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_3 from statictext within w_fl319_gstos_drcts_bahia
integer x = 1317
integer y = 20
integer width = 288
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_proveedor from editmask within w_fl319_gstos_drcts_bahia
integer x = 1627
integer y = 12
integer width = 343
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_cencos from commandbutton within w_fl319_gstos_drcts_bahia
integer x = 1234
integer y = 8
integer width = 73
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tipo_doc

ls_tipo_doc = em_tipo_doc.text

if ls_tipo_doc = '' or IsNull(ls_tipo_doc) then
	MessageBox('Aviso', 'Debe especificar un tipo de documento')
	return
end if

ls_sql = "select distinct a.tipo_doc as tipo_documento, " &
		 + "b.nro_doc as numero_documento " &
		 + "from doc_tipo a, " &
		 + "fl_gtos_drcts_bahia b " &
		 + "where a.tipo_doc = b.tipo_doc " &
		 + "and a.tipo_doc = '" + ls_tipo_doc + "'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_nro_doc.text = ls_data
end if

end event

type cb_cnta from commandbutton within w_fl319_gstos_drcts_bahia
integer x = 1979
integer y = 8
integer width = 73
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tipo_doc, ls_nro_doc

ls_tipo_doc = em_tipo_doc.text
ls_nro_doc	= em_nro_doc.text

if ls_tipo_doc = '' or IsNull(ls_tipo_doc) then
	MessageBox('Aviso', 'Debe especificar un tipo de documento')
	return
end if

if ls_nro_doc = '' or IsNull(ls_nro_doc) then
	MessageBox('Aviso', 'Debe especificar un Numero de documento')
	return
end if

ls_sql = "select distinct a.proveedor as codigo_proveedor, " &
		 + "a.nom_proveedor as razon_social, " &
		 + "a.ruc as ruc_proveedor " &
		 + "from proveedor a, " &
		 + "fl_gtos_drcts_bahia b " &
		 + "where a.proveedor = b.proveedor " &
		 + "and b.tipo_doc = '" + ls_tipo_doc + "' " &
		 + "and b.nro_doc = '" + ls_nro_doc + "'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_proveedor.text = ls_codigo
end if
end event

type cb_1 from commandbutton within w_fl319_gstos_drcts_bahia
integer x = 2071
integer y = 8
integer width = 261
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;if em_tipo_doc.text = '' then
	MessageBox('Aviso', 'Debe especificar un año')
	return
end if

if em_nro_doc.text = '' then
	MessageBox('Aviso', 'Debe especificar un Centro de Costo')
	return
end if

if em_proveedor.text = '' then
	MessageBox('Aviso', 'Debe especificar una Cuenta Presupuestal')
	return
end if

of_retrieve(em_tipo_doc.text, em_nro_doc.text, em_proveedor.text)

end event

type cb_2 from commandbutton within w_fl319_gstos_drcts_bahia
integer x = 466
integer y = 8
integer width = 73
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_year

ls_sql = "select distinct a.tipo_doc as tipo_documento, " &
		 + "a.desc_tipo_doc as descripcion_tipo_doc " &
		 + "from doc_tipo a, " &
		 + "fl_gtos_drcts_bahia b " &
		 + "where a.tipo_doc = b.tipo_doc " 
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_tipo_doc.text = ls_codigo
end if

end event

type em_tipo_doc from editmask within w_fl319_gstos_drcts_bahia
integer x = 242
integer y = 8
integer width = 201
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

