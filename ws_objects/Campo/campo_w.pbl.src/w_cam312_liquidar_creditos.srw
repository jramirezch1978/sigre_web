$PBExportHeader$w_cam312_liquidar_creditos.srw
forward
global type w_cam312_liquidar_creditos from w_abc_mastdet_smpl
end type
type cb_1 from commandbutton within w_cam312_liquidar_creditos
end type
type uo_fecha from u_ingreso_fecha within w_cam312_liquidar_creditos
end type
type tab_1 from tab within w_cam312_liquidar_creditos
end type
type tabpage_1 from userobject within tab_1
end type
type dw_cntas_pagar from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_cntas_pagar dw_cntas_pagar
end type
type tabpage_2 from userobject within tab_1
end type
type dw_habilitaciones from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_habilitaciones dw_habilitaciones
end type
type tabpage_3 from userobject within tab_1
end type
type dw_detail_liq from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_detail_liq dw_detail_liq
end type
type tab_1 from tab within w_cam312_liquidar_creditos
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type cb_liquidar from commandbutton within w_cam312_liquidar_creditos
end type
type cb_imprimir from commandbutton within w_cam312_liquidar_creditos
end type
type cb_anular from commandbutton within w_cam312_liquidar_creditos
end type
end forward

global type w_cam312_liquidar_creditos from w_abc_mastdet_smpl
integer width = 3278
integer height = 2468
string title = "[CM312] Liquidación de Créditos"
string menuname = "m_only_exit"
cb_1 cb_1
uo_fecha uo_fecha
tab_1 tab_1
cb_liquidar cb_liquidar
cb_imprimir cb_imprimir
cb_anular cb_anular
end type
global w_cam312_liquidar_creditos w_cam312_liquidar_creditos

type variables
String	is_soles, is_salir
u_dw_abc	idw_cntas_pagar, idw_habilitaciones, idw_detail_liq

end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_set_base (long al_row, string as_productor)
public subroutine of_retrieve (string as_nro)
public function integer of_get_param ()
public function boolean of_set_datos_ot (long al_row)
public subroutine of_asigna_dws ()
public subroutine of_liquidar (long al_row)
public subroutine of_anular_liquidacion (long al_row)
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_ult_nro, ll_j, ll_count
string	ls_mensaje, ls_nro

if is_action = 'new' then

	Select count(*) 
		into :ll_count
	from NUM_CAM_PLANT_CONSUMO
	where origen = :gs_origen;
	
	IF ll_count = 0 then
		Insert into NUM_CAM_PLANT_CONSUMO (origen, ult_nro)
			values( :gs_origen, 1);
	end if
	
	Select ult_nro 
		into :ll_ult_nro 
	from  NUM_CAM_PLANT_CONSUMO
	where origen = :gs_origen for update;
	
	// Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))
	
	dw_master.object.nro_plantilla[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update NUM_CAM_PLANT_CONSUMO 
		set ult_nro = :ll_ult_nro + 1 
	 where origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_plantilla[dw_master.getrow()] 
end if

// Asigna numero a detalle
for ll_j = 1 to dw_detail.RowCount()	
	dw_detail.object.nro_plantilla[ll_j] = ls_nro	
next
return 1
end function

public subroutine of_set_base (long al_row, string as_productor);string	ls_base, ls_Desc_base

select distinct ab.cod_base, ab.desc_base
	into :ls_base, :ls_desc_base
from ap_bases ab,
     ap_proveedor_certif apc
where ab.cod_base = apc.cod_base  
  and apc.proveedor = :as_productor;

dw_master.object.cod_base [al_row] = ls_base
dw_master.object.desc_base [al_row] = ls_desc_base
end subroutine

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	// Fuerza a leer detalle
	dw_detail.retrieve(as_nro)
	
	if dw_detail.RowCount() > 0 then
		dw_detail.il_row = 1
		dw_detail.SelectRow(0, false)
		dw_detail.SelectRow(dw_detail.il_Row, true)
		dw_detail.SetRow(1)
	end if
	
	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	dw_detail.ii_protect = 0
	dw_detail.ii_update	= 0
	dw_detail.of_protect()
	dw_detail.ResetUpdate()
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	is_action = 'open'
end if

return 
end subroutine

public function integer of_get_param ();String ls_mensaje

// busca tipos de movimiento definidos
SELECT 	cod_soles
	INTO 	:is_soles
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
if ISNULL( is_soles ) or TRIM( is_soles ) = '' then
	Messagebox("Error", "Defina Moneda Soles en logparam")
	return 0
end if


return 1

end function

public function boolean of_set_datos_ot (long al_row);String 	ls_ot_adm, ls_desc_ot_adm, ls_nro_ot, &
			ls_titulo_ot, ls_null, ls_empacadora, &
			ls_labor

SetNull(ls_null)

ls_labor 		= dw_master.object.cod_labor 			[al_row]
ls_empacadora 	= dw_master.object.cod_empacadora 	[al_row]

select ot.ot_adm, ota.descripcion, ot.nro_orden, ot.titulo
	into :ls_ot_adm, :ls_desc_ot_adm, :ls_nro_ot, :ls_titulo_ot
from labor l,
     ap_empacadora_ot aot,
     operaciones      op,
	  orden_trabajo	 ot,
	  ot_administracion ota
where op.cod_labor = l.cod_labor
  and aot.nro_orden = op.nro_orden
  and op.nro_orden  = ot.nro_orden
  and ot.ot_adm	  = ota.ot_adm
  and aot.cod_empacadora = :ls_empacadora
  and op.cod_labor		 = :ls_labor
  and op.flag_estado		 = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Error', 'No existe una operacion aprobada para la labor ' + trim(ls_labor) &
							+ ' asignada a la empacadora ' + trim(ls_empacadora) + ', por favor verifique')
							
	dw_master.object.ot_adm				[al_row] = ls_null
	dw_master.object.desc_ot_adm		[al_row] = ls_null
	dw_master.object.nro_orden			[al_row] = ls_null
	dw_master.object.titulo_ot			[al_row] = ls_null
	return false
end if
  
dw_master.object.ot_adm				[al_row] = ls_ot_adm
dw_master.object.desc_ot_adm		[al_row] = ls_desc_ot_adm
dw_master.object.nro_orden			[al_row] = ls_nro_ot
dw_master.object.titulo_ot			[al_row] = ls_titulo_ot

return true
end function

public subroutine of_asigna_dws ();idw_cntas_pagar = tab_1.tabpage_1.dw_cntas_pagar
idw_habilitaciones = tab_1.tabpage_2.dw_habilitaciones
idw_detail_liq  = tab_1.tabpage_3.dw_detail_liq
end subroutine

public subroutine of_liquidar (long al_row);DEcimal	ldc_total_cxc, ldc_total_cxp, ldc_importe, ldc_importe_det
String 	ls_proveedor, ls_nro_liquid, ldc_tasa_cambio, ls_mensaje, &
			ls_tipo_doc, ls_nro_doc, ls_confin, ls_moneda, ls_nro_credito, &
			ls_soles
Date		ld_fec_pago
Long		ll_ult_nro, ll_count, ll_item, ll_row, ll_item_credito

idw_cntas_pagar.AcceptText()
idw_habilitaciones.AcceptText()
idw_detail_liq.AcceptText()

select cod_soles
  into :ls_soles
from logparam
where reckey  = '1';

//Obtengo el tipo de cambio
ld_fec_pago = uo_Fecha.of_get_fecha()
select usf_fin_tasa_cambio(:ld_fec_pago)
	into :ldc_tasa_cambio
from dual;

//Valido si han marcado registros y si el total de cxp es mayor a cxc
ldc_total_cxc = 0 
ldc_total_cxp = 0

for ll_row = 1 to idw_cntas_pagar.RowCount()
	if idw_cntas_pagar.object.ck[ll_row] = '1' then
		ldc_total_cxp += Dec(idw_cntas_pagar.object.importe [ll_row])
	end if
next

for ll_row = 1 to idw_habilitaciones.RowCount()
	if idw_habilitaciones.object.ck[ll_row] = '1' then
		ldc_total_cxc += Dec(idw_habilitaciones.object.monto_cuota [ll_row])
	end if
next

if ldc_total_cxp = 0 then
	MessageBox('Error', 'Debe seleccionar o indicar un importe en cuentas por pagar para liquidar, por favor verifique')
	return
end if

if ldc_total_cxc = 0 then
	MessageBox('Error', 'Debe seleccionar o indicar un importe en habilitaciones para liquidar, por favor verifique')
	return
end if

ldc_importe = ldc_total_cxp - ldc_total_cxc

if ldc_importe < 0 then
	MessageBox('Error', 'No se puede liquidar con un importe negativo, Importe:' + string(ldc_importe) + ', por favor verifique')
	return
end if

//Insertar datos en la tabla maestra
ls_proveedor = dw_master.object.proveedor [al_row]
ls_moneda	= dw_master.object.cod_moneda		[al_row]

//1.- Creo un nuevo numero

select count(*)
  into :ll_count
  from num_cam_liquidacion
where origen = :gs_origen;

if ll_count = 0 then
	insert into num_cam_liquidacion(origen, ult_nro)
	values(:gs_origen, 1);
end if

select ult_nro
	into :ll_ult_nro
from num_cam_liquidacion
where origen = :gs_origen for update;

ls_nro_liquid = gs_origen + string(ll_ult_nro, '00000000')

update num_cam_liquidacion
   set ult_nro = :ll_ult_nro + 1
where origen = :gs_origen;



//SQL> desc cam_liquidacion_pago
//Name             Type          Nullable Default Comments         
//---------------- ------------- -------- ------- ---------------- 
//NRO_LIQUID_CAMPO CHAR(10)                       NRO_LIQUID_CAMPO 
//PROVEEDOR        CHAR(8)       Y                cod proveedor    
//NRO_LIQUIDACION  CHAR(10)      Y                NRO_LIQUIDACION  
//COD_USR          CHAR(6)       Y                cod usuario      
//FLAG_TIPO_PAGO   CHAR(1)       Y                FLAG_TIPO_PAGO   
//REG_CHEQUE       NUMBER(10)    Y                REG_CHEQUE       
//CHQ_A_NOMBRE     VARCHAR2(200) Y                CHQ_A_NOMBRE     
//ANO              NUMBER(4)     Y                ANO              
//MES              NUMBER(2)     Y                MES              
//NRO_LIBRO_LIQ    NUMBER(3)     Y                nro libro LIQ    
//NRO_LIBRO_CAJ    NUMBER(3)     Y                nro libro CAJ    
//COD_CTABCO       CHAR(20)      Y                cod ctabco       
//ORG_CAJA         CHAR(2)       Y                ORG_CAJA         
//REG_CAJA         NUMBER(10)    Y                REG_CAJA         
//TASA_CAMBIO      NUMBER(7,4)   Y                TASA_CAMBIO      
//FEC_REGISTRO     DATE          Y        SYSDATE FEC_REGISTRO     
//FEC_PAGO         DATE          Y                FEC_PAGO         
//IMPORTE          NUMBER(18,4)  Y                IMPORTE          
//FLAG_ESTADO      CHAR(1)       Y                FLAG_ESTADO      
//OBSERVACIONES    VARCHAR2(200) Y                OBSERVACIONES   

insert into cam_liquidacion_pago(
		NRO_LIQUID_CAMPO, PROVEEDOR, COD_USR, FLAG_TIPO_PAGO,
		TASA_CAMBIO, FEC_REGISTRO, FEC_PAGO, IMPORTE, 
		FLAG_ESTADO, OBSERVACIONES, ORIGEN)
values(
		:ls_nro_liquid, :ls_proveedor, :gs_user, '1',
		:ldc_tasa_cambio, sysdate, :ld_fec_pago, :ldc_importe,
		'1', 'LIQUIDACION AUTOMATICA', :gs_origen);

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error en insertar la cabecera' , ls_mensaje)
	return
end if

//Insertando el detalle, primero las cntas por pagar y luego los prestamos
//pero solamente los activos por ck
ll_item = 1
		
//SQL> desc cam_liquidacion_pago_det
//Name             Type         Nullable Default Comments         
//---------------- ------------ -------- ------- ---------------- 
//NRO_LIQUID_CAMPO CHAR(10)                      NRO_LIQUID_CAMPO 
//NRO_ITEM         NUMBER(4)                     NRO_ITEM         
//CONFIN_PROV      CHAR(8)      Y                confin PROV      
//COD_RELACION_CXP CHAR(8)      Y                cod relacion_CXP 
//TIPO_DOC_CXP     CHAR(4)      Y                tipo doc CXP     
//NRO_DOC_CXP      CHAR(10)     Y                Nro Doc CXP      
//TIPO_DOC_CXC     CHAR(4)      Y                tipo doc_CXC     
//NRO_DOC_CXC      CHAR(10)     Y                Nro Doc CXC      
//NRO_CREDITO      CHAR(10)     Y                NRO_CREDITO      
//ITEM_CREDITO     NUMBER(4)                     ITEM_CREDITO     
//FLAG_SIGNO       CHAR(1)      Y                FLAG_SIGNO       
//COD_MONEDA       CHAR(3)      Y                cod moneda       
//COD_USR          CHAR(6)      Y                cod usuario      
//ORG_CAJA         CHAR(2)      Y                ORG_CAJA         
//REG_CAJA         NUMBER(10)   Y                REG_CAJA         
//ITEM_CAJA        NUMBER(4)    Y                ITEM_CAJA        
//MONTO_CAPITAL    NUMBER(18,4) Y                MONTO_CAPITAL    
//MONTO_INTERES    NUMBER(18,4) Y                MONTO_INTERES    
//MONTO_COMISIONES NUMBER(18,4) Y                MONTO_COMISIONES 
//IMPORTE          NUMBER(18,4) Y                IMPORTE          
//FLAG_ESTADO      CHAR(1)      Y                FLAG_ESTADO 

for ll_row = 1 to idw_cntas_pagar.RowCount()
	if idw_cntas_pagar.object.ck[ll_row] = '1' then
		ls_tipo_doc = idw_cntas_pagar.object.tipo_doc 	[ll_row]
		ls_nro_doc	= idw_cntas_pagar.object.nro_doc		[ll_row]
		ls_confin	= idw_cntas_pagar.object.confin		[ll_row]
		ldc_importe_det = Dec(idw_cntas_pagar.object.importe	[ll_row])
		
		
		insert into cam_liquidacion_pago_det(
			NRO_LIQUID_CAMPO, NRO_ITEM, CONFIN_PROV, 
			COD_RELACION_CXP, TIPO_DOC_CXP, NRO_DOC_CXP, 
			FLAG_SIGNO, COD_MONEDA, COD_USR, IMPORTE,
			FLAG_ESTADO)
		values(
			:ls_nro_liquid, :ll_item, :ls_confin,
			:ls_proveedor, :ls_tipo_doc, :ls_nro_doc,
			'+', :ls_moneda, :gs_user, :ldc_importe_det,
			'1');
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error en insertar la cntas x pagar' , ls_mensaje)
			return
		end if

		ll_item ++
	end if
next

for ll_row = 1 to idw_habilitaciones.RowCount()
	if idw_habilitaciones.object.ck[ll_row] = '1' then
		ls_tipo_doc = idw_habilitaciones.object.tipo_doc_cxp 	[ll_row]
		ls_nro_doc	= idw_habilitaciones.object.nro_doc_cxp	[ll_row]
		ls_confin	= idw_habilitaciones.object.confin			[ll_row]
		ldc_importe_det = Dec(idw_habilitaciones.object.monto_cuota	[ll_row])
		ls_nro_credito = idw_habilitaciones.object.nro_credito		[ll_row]
		ll_item_credito = Long(idw_habilitaciones.object.nro_item		[ll_row])
		
		if IsNull(ldc_importe_det) or ldc_importe_det = 0 then
			ROLLBACK;
			MessageBox('Error', 'No ha especificado un importe de la cuota para el item de habilitación, por favor verifique')
			return
		end if
		
		insert into cam_liquidacion_pago_det(
			NRO_LIQUID_CAMPO, NRO_ITEM, CONFIN_PROV, 
			COD_RELACION_CXP, TIPO_DOC_CXP, NRO_DOC_CXP, NRO_CREDITO, ITEM_CREDITO,
			FLAG_SIGNO, COD_MONEDA, COD_USR, IMPORTE,
			FLAG_ESTADO)
		values(
			:ls_nro_liquid, :ll_item, :ls_confin,
			:ls_proveedor, :ls_tipo_doc, :ls_nro_doc, :ls_nro_credito, :ll_item_credito,
			'-', :ls_moneda, :gs_user, :ldc_importe_det,
			'1');
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error en insertar la detalle de habilitaciones' , ls_mensaje)
			return
		end if

		ll_item ++
	end if
next

//create or replace procedure USP_CAM_ASIENTO_LP(
//       asi_nro_liquid       in cam_liquidacion_pago.nro_liquid_campo%TYPE,
//       asi_moneda           in moneda.cod_moneda%TYPE
//) is
DECLARE USP_CAM_ASIENTO_LP PROCEDURE FOR 
	USP_CAM_ASIENTO_LP(:ls_nro_liquid,
							 :ls_moneda);
	
EXECUTE USP_CAM_ASIENTO_LP ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox('Error en Procedure USP_CAM_ASIENTO_LP', ls_mensaje)
	Return
END IF

CLOSE USP_CAM_ASIENTO_LP;

commit;

cb_liquidar.enabled = false
dw_master.object.nro_liquidacion [al_row] = ls_nro_liquid
dw_master.event ue_output(al_row)

Messagebox('Aviso','Proceso de Liquidacion Ha Concluido Satisfactoriamente')


end subroutine

public subroutine of_anular_liquidacion (long al_row);String ls_nro_liquid, ls_mensaje

ls_nro_liquid = dw_master.object.nro_liquidacion [al_row]

if IsNull(ls_nro_liquid) or ls_nro_liquid = "" then
	MessageBox('Error', 'No existe numero de liquidación, por favor verifique')
	return
end if

//create or replace procedure USP_CAM_ANULAR_LIQUIDACION(
//       asi_nro_liquid       in cam_liquidacion_pago.nro_liquid_campo%TYPE,
//) is
DECLARE USP_CAM_ANULAR_LIQUIDACION PROCEDURE FOR 
	USP_CAM_ANULAR_LIQUIDACION(:ls_nro_liquid);
	
EXECUTE USP_CAM_ANULAR_LIQUIDACION ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox('Error en Procedure USP_CAM_ANULAR_LIQUIDACION', ls_mensaje)
	Return
END IF

CLOSE USP_CAM_ANULAR_LIQUIDACION;

commit;

cb_liquidar.enabled = false
setNull(ls_nro_liquid)
dw_master.object.nro_liquidacion [al_row] = ls_nro_liquid
dw_master.event ue_output(al_row)

Messagebox('Aviso','Proceso de Anulación de Liquidacion Ha Concluido Satisfactoriamente')


end subroutine

on w_cam312_liquidar_creditos.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.tab_1=create tab_1
this.cb_liquidar=create cb_liquidar
this.cb_imprimir=create cb_imprimir
this.cb_anular=create cb_anular
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.cb_liquidar
this.Control[iCurrent+5]=this.cb_imprimir
this.Control[iCurrent+6]=this.cb_anular
end on

on w_cam312_liquidar_creditos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.tab_1)
destroy(this.cb_liquidar)
destroy(this.cb_imprimir)
destroy(this.cb_anular)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

ii_lec_mst = 0


this.event ue_query_Retrieve()

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
//if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, dw_detail.is_dwform) <> true then	return

if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle")
	return
end if

//of_set_total_oc()
//if of_set_numera() = 0 then return	

ib_update_check = true

//dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()


end event

event ue_retrieve_list;call super::ue_retrieve_list;//// Abre ventana pop
//str_parametros sl_param
//String ls_tipo_mov
//
//sl_param.dw1    = 'd_list_cam_plant_consumo_tbl'
//sl_param.titulo = 'Plantillas de Consumo de Campo'
//sl_param.field_ret_i[1] = 1
//
//OpenWithParm( w_lista, sl_param)
//sl_param = MESSAGE.POWEROBJECTPARM
//if sl_param.titulo <> 'n' then
//	of_retrieve(sl_param.field_ret[1])
//END IF
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_update;//Override
Boolean 	lbo_ok = TRUE
String	ls_msg, ls_crlf
Long		ll_row

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_detail.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)
IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	ll_row = dw_master.getRow()
	
	this.event ue_query_retrieve()
	
	if ll_row <= dw_master.RowCount() then
		dw_master.il_row = ll_row
		dw_master.setRow(ll_row)
		dw_master.SelectRow(0, false)
		dw_master.SelectRow(ll_row, true)
		dw_master.event ue_output(ll_row)
	end if

END IF

end event

event ue_anular;call super::ue_anular;String	ls_estado
Long		ll_i

if dw_master.getRow() = 0 then return

ls_estado = dw_master.object.flag_estado[dw_master.getRow()] 

if ls_estado <> '1' then
	MessageBox('Error', 'No se puede anular el documento porque no esta ACTIVO, por favor verifique')
	return
end if

IF dw_master.ii_update = 1 OR dw_detail.ii_update = 1 THEN 
	Messagebox('Aviso','Tiene Actualizaciones Pendientes Grabe Antes de Anular ,Verifique!')
	Return
END IF

if MessageBox('Aviso', 'Desea anular el documento?', Information!, YesNo!, 2) = 2 then return

dw_master.object.flag_estado [dw_master.getRow()] = '0'
dw_master.ii_update = 1

for ll_i = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado[ll_i] = '0'
	dw_detail.ii_update = 1
next
end event

event ue_print;call super::ue_print;// vista previa de mov. almacen
sg_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 		= 'd_frm_credito'
lstr_rep.titulo 	= 'Previo de Crédito'
lstr_rep.string1 	= dw_master.object.nro_credito[dw_master.getrow()]
lstr_rep.tipo		= '1S'

OpenSheetWithParm(w_cam304_creditos_frm, lstr_rep, w_main, 0, Layered!)
end event

event ue_insert;//Override
Long  ll_row

IF idw_1 = dw_master THEN
	MessageBox("Error", "No esta permitido insertar registros en este panel")
	RETURN
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_delete;//Override
Long  ll_row

if idw_1 = dw_master then
	MessageBox('Error', 'No esta permitido eliminar datos en este panel')
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
end event

event ue_query_retrieve;//Override
Int li_row

this.event ue_update_Request()

dw_master.retrieve(uo_fecha.of_get_fecha())
dw_master.ii_update = 0

dw_master.Modify("b_liquidar.Visible='1~tIf(ISNull(nro_liquid_campo),1,0)'")

//for li_row = 1 to dw_master.RowCount()
//	if Not(IsNull(dw_master.object.nro_liquid_campo[li_Row]) or dw_master.object.nro_liquid_campo[li_Row]= "") then
//		
//	end if
//next
end event

event resize;//Override

of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10
//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_cntas_pagar.width  = tab_1.tabpage_1.width  - idw_cntas_pagar.x - 10
idw_cntas_pagar.height = tab_1.tabpage_1.height - idw_cntas_pagar.y - 10

idw_habilitaciones.width  = tab_1.tabpage_2.width  - idw_habilitaciones.x - 10
idw_habilitaciones.height = tab_1.tabpage_2.height - idw_habilitaciones.y - 10

idw_detail_liq.width  = tab_1.tabpage_3.width  - idw_detail_liq.x - 10
idw_detail_liq.height = tab_1.tabpage_3.height - idw_detail_liq.y - 10

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cam312_liquidar_creditos
event ue_leftbuttonup pbm_dwnlbuttonup
integer x = 0
integer y = 128
integer width = 2651
integer height = 1196
string dataobject = "d_list_liq_creditos_tbl"
boolean livescroll = false
end type

event dw_master::ue_leftbuttonup;//cbx_PowerFilter.event post ue_buttonclicked(dwo.type, dwo.name)
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro			[al_row] = f_fecha_actual()
this.object.cod_usr					[al_row] = gs_user
this.object.flag_estado				[al_row] = '1'
this.object.cod_origen				[al_row] = gs_origen
		
this.setColumn('cod_labor')

is_Action = 'new'

end event

event dw_master::constructor;call super::constructor;is_dwform = 'tabular' // tabular form
 
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle


end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_codtra, ls_nom_trabajador, &
			ls_empacadora, ls_labor, ls_null, ls_ot_adm

SetNull(ls_null)

choose case lower(as_columna)
		
	case "cod_labor"
		
		ls_sql = "select l.cod_labor as codigo_labor, " &
				 + "l.desc_labor as descripcion_labor " &
				 + "from labor l " &
				 + "where l.flag_estado = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_labor		[al_row] = ls_codigo
			this.object.desc_labor		[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc, ls_desc2, ls_empacadora
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	case "cod_labor"
		
		ls_empacadora = this.object.cod_empacadora [row]
		
		if ls_empacadora = '' or IsNull(ls_empacadora) then
			MessageBox('Error', 'Debe indicar primero una empacadora')
			this.setColumn('cod_empacadora')
			return
		end if
		
		select l.desc_labor 
			into :ls_desc
		from 	labor l
		where l.cod_labor = :data
		  and l.flag_estado = '1';
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Codigo de Labor, no corresponde a ninguna operacion aprobada o no se encuentra activo, por favor verifique")
			this.object.cod_labor		[row] = ls_null
			this.object.desc_labor		[row] = ls_null
			return 1
		end if
		
		this.object.desc_labor		[row] = ls_Desc
END CHOOSE


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

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1], Integer(String(aa_id[2])))
end event

event dw_master::ue_output;call super::ue_output;parent.event ue_update_request()

//dw_detail.Retrieve(this.object.nro_Credito[al_row], this.object.nro_item[al_row])

//idw_det.ScrollToRow(al_row)

String 	ls_proveedor, ls_moneda, ls_nro_liquid
DAte		ld_fec_pago

ls_nro_liquid	= dw_master.object.nro_liquidacion [al_row]

if IsNull(ls_nro_liquid) or ls_nro_liquid = '' then
	cb_liquidar.enabled = true
	cb_anular.enabled = false
	cb_imprimir.enabled = false
else
	cb_liquidar.enabled = false
	cb_anular.enabled = true
	cb_imprimir.enabled = true
end if

ls_proveedor 	= dw_master.object.proveedor 	[al_row]
ls_moneda		= dw_master.object.cod_moneda [al_row]
ld_Fec_pago		= uo_fecha.of_get_fecha()

idw_cntas_pagar.Retrieve(ls_proveedor, ls_moneda, ld_fec_pago)
idw_habilitaciones.Retrieve(ls_proveedor, ls_moneda, ld_fec_pago)
idw_detail_liq.Retrieve(ls_nro_liquid)
end event

event dw_master::resize;call super::resize;//cbx_PowerFilter.event ue_positionbuttons()
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cam312_liquidar_creditos
boolean visible = false
integer x = 2711
integer y = 96
integer width = 215
integer height = 188
string dataobject = "d_abc_cam_creditos_ctacte_tbl"
boolean hsplitscroll = true
end type

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro		[al_row] = f_fecha_actual()
this.object.fec_pago				[al_row] = Date(f_fecha_actual())
this.object.cod_usr				[al_row] = gs_user
this.object.cod_moneda			[al_row] = dw_master.object.cod_moneda	[dw_master.getRow()]
this.object.importe				[al_row] = dw_master.object.monto_cuota[dw_master.getRow()]

this.object.nro_credito			[al_row] = dw_master.object.nro_credito	[dw_master.getRow()]
this.object.nro_item				[al_row] = dw_master.object.nro_item		[dw_master.getRow()]





end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master

end event

event dw_detail::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_ot, ls_labor, &
			ls_und, ls_Almacen
date		ld_fec_inicio
Integer	li_year

if dw_master.getRow() = 0 then return

choose case lower(as_columna)
		
	case "cod_art"
		
		ls_sql = "select a.cod_art as codigo_articulo, " &
			    + "a.desc_art as descripcion_articulo, " &
				 + "a.und as und " &
				 + "from articulo a " &
				 + "where a.flag_estado = '1' " 
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_und, '2')
		
		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.object.und		[al_row] = ls_und
			this.ii_update = 1
		end if
	
end choose
end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_art' 

		// Verifica que codigo ingresado exista			
		Select desc_art, und
	     into :ls_desc1, :ls_desc2
		  from articulo
		 Where cod_art = :data
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe codigo de Artículo o no se encuentra activo, por favor verifique")
			this.object.cod_art		[row] = ls_null
			this.object.desc_art		[row] = ls_null
			this.object.und			[row] = ls_null
			return 1
		end if
		
		this.object.desc_art		[row] = ls_desc1
		this.object.und			[row] = ls_desc2


END CHOOSE
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

type cb_1 from commandbutton within w_cam312_liquidar_creditos
integer x = 649
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event ue_query_retrieve()
end event

type uo_fecha from u_ingreso_fecha within w_cam312_liquidar_creditos
event destroy ( )
integer x = 5
integer y = 12
integer taborder = 40
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;of_set_label('Hasta:') // para seatear el titulo del boton
of_set_fecha(date(f_fecha_actual())) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type tab_1 from tab within w_cam312_liquidar_creditos
integer y = 1336
integer width = 2624
integer height = 912
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
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
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 2587
integer height = 792
long backcolor = 79741120
string text = "Cntas x Pagar"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_cntas_pagar dw_cntas_pagar
end type

on tabpage_1.create
this.dw_cntas_pagar=create dw_cntas_pagar
this.Control[]={this.dw_cntas_pagar}
end on

on tabpage_1.destroy
destroy(this.dw_cntas_pagar)
end on

type dw_cntas_pagar from u_dw_abc within tabpage_1
integer y = 8
integer width = 2555
integer height = 768
integer taborder = 20
string dataobject = "d_list_cntas_pagar_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_parametros   sl_param
choose case lower(as_columna)
	case "confin"
		sl_param.tipo			= ''
		sl_param.opcion		= 3
		sl_param.titulo 		= 'Selección de Concepto Financiero'
		sl_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
		sl_param.dw1			= 'd_lista_concepto_financiero_grd'
		sl_param.dw_m			=  This
		
		OpenWithParm( w_abc_seleccion_md, sl_param)
		IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
		IF sl_param.titulo = 's' THEN
			this.ii_update = 1
		END IF

		
end choose
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 2587
integer height = 792
long backcolor = 79741120
string text = "Habilitaciones / Prestamos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_habilitaciones dw_habilitaciones
end type

on tabpage_2.create
this.dw_habilitaciones=create dw_habilitaciones
this.Control[]={this.dw_habilitaciones}
end on

on tabpage_2.destroy
destroy(this.dw_habilitaciones)
end on

type dw_habilitaciones from u_dw_abc within tabpage_2
integer width = 2519
integer height = 744
integer taborder = 20
string dataobject = "d_list_habilitaciones_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw


end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_parametros   sl_param
choose case lower(as_columna)
	case "confin"
		sl_param.tipo			= ''
		sl_param.opcion		= 3
		sl_param.titulo 		= 'Selección de Concepto Financiero'
		sl_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
		sl_param.dw1			= 'd_lista_concepto_financiero_grd'
		sl_param.dw_m			=  This
		
		OpenWithParm( w_abc_seleccion_md, sl_param)
		IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
		IF sl_param.titulo = 's' THEN
			this.ii_update = 1
		END IF

		
end choose
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 2587
integer height = 792
long backcolor = 79741120
string text = "Detalle de Liquidacion"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail_liq dw_detail_liq
end type

on tabpage_3.create
this.dw_detail_liq=create dw_detail_liq
this.Control[]={this.dw_detail_liq}
end on

on tabpage_3.destroy
destroy(this.dw_detail_liq)
end on

type dw_detail_liq from u_dw_abc within tabpage_3
integer width = 2373
integer height = 732
integer taborder = 20
string dataobject = "d_list_liquidacion_pago_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type cb_liquidar from commandbutton within w_cam312_liquidar_creditos
integer x = 1070
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Liquidar"
end type

event clicked;String 	ls_nro_liquid
Long 		ll_row

ll_row = dw_master.getRow()

if ll_Row = 0 then return

ls_nro_liquid = dw_master.object.nro_liquidacion[ll_row]

if Not(ls_nro_liquid = '' or IsNull(ls_nro_liquid)) then
	MessageBox('Error', 'Registro ya ha sido liquidado, por favor verifique')
	return
end if

of_liquidar(ll_row)

end event

type cb_imprimir from commandbutton within w_cam312_liquidar_creditos
integer x = 1911
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Imprimir"
end type

event clicked;w_cam312_liquidacion_credito_frm lw_1

str_parametros lstr_rep

lstr_rep.string1 = dw_master.object.nro_liquidacion[dw_master.getrow()]

OpenSheetWithParm(lw_1, lstr_rep, w_main, 2, Layered!)
end event

type cb_anular from commandbutton within w_cam312_liquidar_creditos
integer x = 1490
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Anular"
end type

event clicked;String 	ls_nro_liquid
Long 		ll_row

ll_row = dw_master.getRow()

if ll_Row = 0 then return

ls_nro_liquid = dw_master.object.nro_liquidacion[ll_row]

if ls_nro_liquid = '' or IsNull(ls_nro_liquid) then
	MessageBox('Error', 'Registro no tiene liquidacion a anular, por favor verifique')
	return
end if

of_anular_liquidacion(ll_row)

end event

