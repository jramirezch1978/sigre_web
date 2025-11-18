$PBExportHeader$w_ope302_orden_trabajo.srw
forward
global type w_ope302_orden_trabajo from w_abc
end type
type cb_8 from commandbutton within w_ope302_orden_trabajo
end type
type sle_nro_ot from u_sle_codigo within w_ope302_orden_trabajo
end type
type st_orden from statictext within w_ope302_orden_trabajo
end type
type cb_buscar from commandbutton within w_ope302_orden_trabajo
end type
type cb_5 from commandbutton within w_ope302_orden_trabajo
end type
type cb_4 from commandbutton within w_ope302_orden_trabajo
end type
type dw_master from u_dw_abc within w_ope302_orden_trabajo
end type
type tab_1 from tab within w_ope302_orden_trabajo
end type
type tabpage_1 from userobject within tab_1
end type
type dw_det_ot from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_det_ot dw_det_ot
end type
type tabpage_2 from userobject within tab_1
end type
type pb_1 from picturebutton within tabpage_2
end type
type st_campo from statictext within tabpage_2
end type
type dw_lista_op from u_dw_abc within tabpage_2
end type
type dw_find from datawindow within tabpage_2
end type
type dw_det_op from u_dw_abc within tabpage_2
end type
type dw_det_art from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
pb_1 pb_1
st_campo st_campo
dw_lista_op dw_lista_op
dw_find dw_find
dw_det_op dw_det_op
dw_det_art dw_det_art
end type
type tabpage_3 from userobject within tab_1
end type
type st_filtrar from statictext within tabpage_3
end type
type dw_busqueda from datawindow within tabpage_3
end type
type dw_oper_lista_ingreso from u_dw_abc within tabpage_3
end type
type dw_ingresos_ins_tbl from u_dw_abc within tabpage_3
end type
type dw_oper_ingresos from u_dw_abc within tabpage_3
end type
type pb_actualizar from picturebutton within tabpage_3
end type
type tabpage_3 from userobject within tab_1
st_filtrar st_filtrar
dw_busqueda dw_busqueda
dw_oper_lista_ingreso dw_oper_lista_ingreso
dw_ingresos_ins_tbl dw_ingresos_ins_tbl
dw_oper_ingresos dw_oper_ingresos
pb_actualizar pb_actualizar
end type
type tabpage_5 from userobject within tab_1
end type
type dw_ot_distribucion from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_ot_distribucion dw_ot_distribucion
end type
type tabpage_4 from userobject within tab_1
end type
type dw_otros_gastos from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_otros_gastos dw_otros_gastos
end type
type tabpage_6 from userobject within tab_1
end type
type dw_plantilla from datawindow within tabpage_6
end type
type dw_lanza_plant from datawindow within tabpage_6
end type
type gb_1 from groupbox within tabpage_6
end type
type st_3 from statictext within tabpage_6
end type
type em_factor from editmask within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_plantilla dw_plantilla
dw_lanza_plant dw_lanza_plant
gb_1 gb_1
st_3 st_3
em_factor em_factor
end type
type tab_1 from tab within w_ope302_orden_trabajo
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_5 tabpage_5
tabpage_4 tabpage_4
tabpage_6 tabpage_6
end type
type dw_rpt from datawindow within w_ope302_orden_trabajo
end type
type gb_2 from groupbox within w_ope302_orden_trabajo
end type
end forward

global type w_ope302_orden_trabajo from w_abc
integer width = 4471
integer height = 3916
string title = "Ordenes de Trabajo (OPE302)"
string menuname = "m_master_lista_anular"
event ue_anular ( )
event ue_print_rango ( )
cb_8 cb_8
sle_nro_ot sle_nro_ot
st_orden st_orden
cb_buscar cb_buscar
cb_5 cb_5
cb_4 cb_4
dw_master dw_master
tab_1 tab_1
dw_rpt dw_rpt
gb_2 gb_2
end type
global w_ope302_orden_trabajo w_ope302_orden_trabajo

type variables
String 	is_plantilla, is_col, is_data_type, is_doc_ot, &
			is_ot_adm, is_cod_plant, is_flag_cnta_prsp, &
			is_dolares,	is_flag_cenbef, is_doc_oc, is_ejec_tercero
			
DatawindowChild idw_child

u_dw_abc idw_det_ot, idw_det_op, idw_det_art, &
			idw_ot_distribucion, idw_oper_ingresos, idw_ingresos_art, &
			idw_oper_lista_ingreso, idw_lista_op, idw_otros_gastos

DataWindow  idw_lanza_plant, idw_plantilla

n_cst_operaciones	invo_oper_ot
n_cst_wait			invo_Wait

// Para el registro del Log

end variables

forward prototypes
public subroutine wf_art_x_labor (string as_cod_labor)
public subroutine wf_accepttext ()
public subroutine wf_bloquea_dw ()
public function boolean wf_check_save_oper ()
public subroutine wf_retrieve_operaciones_ing ()
public subroutine wf_updt_art_finicio (datetime adt_fec_inicio)
public function boolean of_set_saldo_total (string as_cod_art, string as_almacen)
public subroutine of_asignar_dws ()
public subroutine of_bloquear_dws ()
public subroutine of_modify ()
public function integer of_control_ingresos ()
public function boolean of_set_articulo (string as_cod_art, u_dw_abc adw_op, u_dw_abc adw_art)
public subroutine of_retrieve_ot (string as_nro_orden)
end prototypes

event ue_anular;Long     ll_master_row,ll_nro_mant_prog,ll_null,ll_count
String   ls_doc_ot ,ls_flag_estado,ls_nro_orden,ls_cod_origen,ls_nro_sol,&
		   ls_msj_err
Integer  li_opcion
Boolean  lb_ok = TRUE
Datetime ld_fec_sol

ll_master_row = dw_master.Getrow()

IF ll_master_row = 0 OR IS_ACTION = 'new' THEN RETURN 

TriggerEvent('ue_update_request')
IF ib_update_check = FALSE THEN RETURN


SELECT doc_ot INTO :ls_doc_ot FROM prod_param WHERE reckey = '1' ;


ls_flag_estado = dw_master.Object.flag_estado [ll_master_row]
ls_cod_origen  = dw_master.Object.cod_origen  [ll_master_row]
ls_nro_orden   = dw_master.Object.nro_orden   [ll_master_row]


// Funcion que verifica si puede anularse la orden de trabajo
SELECT usf_ope_anula_ot(:ls_nro_orden) 
  INTO :ll_count 
  FROM dual ;

IF ll_count = 0 THEN
	Messagebox('Aviso','Orden de trabajo no puede anularse, Verifique!')
	RETURN
END IF

li_opcion = MessageBox('Anulacion','Esta Seguro de Anular Orden de Trabajo',Question!, yesno!, 2) //pgta

IF li_opcion = 2 THEN RETURN //no desea anular orden de trabajo

ls_nro_sol       = dw_master.Object.nro_solicitud [ll_master_row]

IF Isnull(ls_nro_sol) OR Trim(ls_nro_sol) = '' THEN
//	ll_nro_mant_prog = dw_master.Object.nro_mant_prog [ll_master_row]
//	
//	IF Not( Isnull(ll_nro_mant_prog) OR ll_nro_mant_prog = 0 ) THEN
//	   SetNull(ll_null)		
//		dw_master.Object.nro_mant_prog [ll_master_row] = ll_null
//	END IF
//	
ELSE
	 
	SetNull(ls_nro_sol) 
	SetNull(ld_fec_sol) 
	dw_master.object.nro_solicitud [ll_master_row] = ls_nro_sol
	dw_master.object.fec_solicitud [ll_master_row] = ld_fec_sol
END IF

//cambiar estado de la orden de trabajo
dw_master.object.flag_estado [ll_master_row] = '0'
	
//eliminar participantes
DO WHILE idw_otros_gastos.Rowcount() > 0
   idw_otros_gastos.deleterow(0)
LOOP

//eliminar distribucion de costo	
DO WHILE tab_1.tabpage_5.dw_ot_distribucion.Rowcount() > 0 
	tab_1.tabpage_5.dw_ot_distribucion.deleterow(0)		
LOOP

/*eliminar articulos referidos a esta orden de trabajo*/
DELETE FROM articulo_mov_proy 
 WHERE tipo_doc = :ls_doc_ot AND 
 		 nro_doc = :ls_nro_orden ;


IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = 'Fallo Delete de Articulo_mov_proy '+SQLCA.SQLErrText
	lb_ok = FALSE
	GOTO ERROR
END IF

//elimina informacion de articulo mov proy SALIDAS
DO WHILE idw_det_art.Rowcount() > 0
   idw_det_art.deleterow(0) //no hacer update de dw
LOOP

//elimina informacion de articulo mov proy INGRESOS
DO WHILE idw_ingresos_art.Rowcount() > 0
   idw_ingresos_art.deleterow(0) //no hacer update de dw
LOOP

//elimina informacion de operaciones
DO WHILE idw_det_op.Rowcount() > 0 //eliminar operaciones 
   idw_det_op.deleterow(0)
LOOP
	
DO WHILE idw_lanza_plant.Rowcount() > 0 //eliminar plantillas relacionadas
   idw_lanza_plant.deleterow(0)
LOOP
	

//ACTUALIZO DW

IF dw_master.update() = -1 						     THEN 
	ls_msj_err = 'Fallo Actualizacion de Cab. OT'
	lb_ok = FALSE
	GOTO ERROR
END IF
	
IF idw_det_op.update() = -1 	 	  THEN
	ls_msj_err = 'Fallo Actualización detalle de Operaciones'
	lb_ok = FALSE		
	GOTO ERROR
END IF
	
IF idw_lanza_plant.update() = -1   THEN
	ls_msj_err = 'Fallo Actualización Plantilla de Lanzamiento'
	lb_ok = FALSE		
	GOTO ERROR
END IF

IF tab_1.tabpage_5.dw_ot_distribucion.update() = -1 THEN
	ls_msj_err = 'Fallo Actualización de Distribucion de Costo'
	lb_ok = FALSE
	GOTO ERROR
END IF

IF idw_otros_gastos.update() = -1 THEN
	ls_msj_err = 'Fallo Actualización de otros gastos'
	lb_ok = FALSE
	GOTO ERROR
END IF
	

IF lb_ok THEN
	Commit ;
	wf_bloquea_dw ()
ELSE
	ERROR:
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
END IF

end event

event ue_print_rango();String  ls_nro_orden,ls_tipo_ot
Str_cns_pop lstr_cns_pop

//Verificacion de Nro de Orden
ls_nro_orden = dw_master.GetItemString(1, 'nro_orden'   )
ls_tipo_ot   = dw_master.GetItemString(1, 'ot_tipo')

//
IF IS_ACTION = 'new' THEN RETURN

lstr_cns_pop.arg[1] = ls_nro_orden

//messagebox('ls_nro_orden',ls_nro_orden)

//tipo de ot
OpenWithParm(w_abc_help_fecha,lstr_cns_pop)
	
/*Impresion*/
lstr_cns_pop = Message.PowerObjectParm		
OpenSheetWithParm(w_ma302_orden_trabajo_rpt_prev, lstr_cns_pop, this, 2, Layered!)
	



end event

public subroutine wf_art_x_labor (string as_cod_labor);String ls_cod_art,ls_desc_art,ls_und
Long   ll_row,ll_count


SELECT Count(*)
  INTO :ll_count
  FROM labor_insumo lb ,articulo art
 WHERE (lb.cod_art = art.cod_art  ) AND
		 (cod_labor  = :as_cod_labor) ;

/*Declaración de Cursor*/
DECLARE Mat_labor CURSOR FOR
		  SELECT lb.cod_art,art.desc_art,art.und
		  	 FROM labor_insumo lb ,
				   articulo art
			WHERE (lb.cod_art = art.cod_art  ) AND
			      (cod_labor  = :as_cod_labor) ;


/*Abrir Cursor*/		  	
OPEN Mat_labor ;
	
DO 				/*Recorro Cursor*/	
FETCH Mat_labor INTO :ls_cod_art,:ls_desc_art,:ls_und ;
IF sqlca.sqlcode = 100 THEN EXIT
/**Inserción de Registros**/ 
	 idw_det_art.TriggerEvent('ue_insert')
	 ll_row = idw_det_art.il_row
	 idw_det_art.object.cod_art      [ll_row] = ls_cod_art
	 idw_det_art.object.desc_art		[ll_row] = ls_desc_art
	 idw_det_art.object.und          [ll_row] = ls_und
	 idw_det_art.object.cant_proyect [ll_row] = 1.00

	 
LOOP WHILE TRUE
	
CLOSE Mat_labor ; /*Cierra Cursor*/



end subroutine

public subroutine wf_accepttext ();/* funcion de ventana que realiza los accepttext sobre todos los dw */
dw_master.Accepttext()
idw_det_ot.Accepttext()
idw_det_op.Accepttext()
idw_det_art.Accepttext()
idw_lista_op.Accepttext()
idw_ingresos_art.AcceptText()
idw_otros_gastos.Accepttext()
idw_ot_distribucion.Accepttext()

end subroutine

public subroutine wf_bloquea_dw ();dw_master.ii_protect = 0
idw_det_ot.ii_protect        	 = 0
idw_det_art.ii_protect       	 = 0
tab_1.tabpage_2.dw_lista_op.ii_protect      	 = 0
idw_det_op.ii_protect        	 = 0
idw_otros_gastos.ii_protect 	 = 0
tab_1.tabpage_5.dw_ot_distribucion.ii_protect = 0
tab_1.tabpage_3.dw_ingresos_ins_tbl.ii_protect = 0

								
dw_master.of_protect()
idw_det_ot.of_protect()
idw_det_art.of_protect() //SALIDAS
tab_1.tabpage_3.dw_ingresos_ins_tbl.of_protect() //INGRESOS
tab_1.tabpage_2.dw_lista_op.of_protect()
idw_det_op.of_protect()
idw_otros_gastos.of_protect()
tab_1.tabpage_5.dw_ot_distribucion.of_protect()

end subroutine

public function boolean wf_check_save_oper ();/*Funcion de ventana de verificación de acciones en las operaciones */
Boolean lb_retorno

IF idw_det_op.ii_update = 1 OR idw_det_art.ii_update = 1 THEN
	lb_retorno = TRUE			// si existe modificaciones en las operaciones
ELSE 
	lb_retorno = FALSE		// si no hay modificaciones en las operaciones
END IF

Return lb_retorno
end function

public subroutine wf_retrieve_operaciones_ing ();String ls_cod_origen,ls_nro_orden
dwobject dwo


ls_nro_orden  = dw_master.Object.nro_orden  [1]

tab_1.tabpage_3.dw_oper_lista_ingreso.Retrieve(ls_nro_orden)

//-Recupera Detalle de Operaciones
IF tab_1.tabpage_3.dw_oper_lista_ingreso.Rowcount() > 0 THEN
	tab_1.tabpage_3.dw_oper_lista_ingreso.Event clicked (0,0,1,dwo)
END IF


end subroutine

public subroutine wf_updt_art_finicio (datetime adt_fec_inicio);dwItemStatus ldis_status
Long   ll_inicio 


FOR ll_inicio = 1 TO idw_det_art.Rowcount()
	 
    ldis_status = idw_det_art.GetitemStatus(ll_inicio,0,primary!)
	 
	 IF ldis_status = NewModified! THEN
	    // Modifica solo los que estan planeados
	 	 IF ((idw_det_art.object.flag_estado[ll_inicio]='1') OR &
	 	 	  (idw_det_art.object.flag_estado[ll_inicio]='3') )THEN
	 		  idw_det_art.object.fec_proyect  [ll_inicio] = adt_fec_inicio
	 		  idw_det_art.ii_update = 1
	 	 END IF
	 END IF		 
	 
NEXT

end subroutine

public function boolean of_set_saldo_total (string as_cod_art, string as_almacen);Decimal	ldc_saldo_total, ldc_costo_unit

if idw_det_op.GetRow() = 0 then return false

select sldo_total
	into :ldc_saldo_total
from articulo_almacen
where cod_art = :as_cod_art
  and almacen = :as_almacen;

if SQLCA.SQLCode = 100 then ldc_saldo_total = 0

idw_det_art.object.saldo_total [idw_det_art.GetRow()] = ldc_saldo_Total

SELECT usf_cmp_prec_ult_compra(:as_cod_art, :as_almacen ) 
  INTO :ldc_costo_unit 
  FROM dual ;

idw_det_art.object.precio_unit[idw_det_art.GetRow()] = ldc_costo_unit


return true
end function

public subroutine of_asignar_dws ();// Asigno los Datawindows con sus respectivas variables globales
idw_det_ot 					= tab_1.tabpage_1.dw_det_ot

idw_lista_op 				= tab_1.tabpage_2.dw_lista_op
idw_det_op					= tab_1.tabpage_2.dw_det_op  
idw_det_art					= tab_1.tabpage_2.dw_det_art
idw_plantilla 				= tab_1.tabpage_6.dw_plantilla
idw_lanza_plant			= tab_1.tabpage_6.dw_lanza_plant

idw_oper_ingresos		  	= tab_1.tabpage_3.dw_oper_ingresos
idw_ingresos_art		  	= tab_1.tabpage_3.dw_ingresos_ins_tbl
idw_oper_lista_ingreso 	= tab_1.tabpage_3.dw_oper_lista_ingreso

idw_otros_gastos		  	= tab_1.tabpage_4.dw_otros_gastos

idw_ot_distribucion		= tab_1.tabpage_5.dw_ot_distribucion
end subroutine

public subroutine of_bloquear_dws ();// Asigno los Datawindows con sus respectivas variables globales
dw_master.ii_protect = 1
dw_master.of_protect()

idw_det_ot.ii_protect = 1
idw_det_ot.of_protect()

idw_det_op.ii_protect = 1
idw_det_op.of_protect()

idw_det_art.ii_protect = 1
idw_det_art.of_protect()

idw_ingresos_art.ii_protect = 1
idw_ingresos_art.of_protect()

idw_otros_gastos.ii_protect = 1
idw_otros_gastos.of_protect()

idw_ot_distribucion.ii_protect = 1
idw_ot_distribucion.of_protect()
end subroutine

public subroutine of_modify ();// Cuando el flag_modificacion es 0 (osea, no se puede modificar)
idw_det_art.Modify("cod_art.Protect='1~tIf(IsNull(modifica) or IsNull(estado) or ISNull(flag_cnt_cmp),1,0)'")	 
idw_det_art.Modify("almacen.Protect='1~tIf(IsNull(modifica) or IsNull(estado) or ISNull(flag_cnt_cmp),1,0)'")	 
idw_det_art.Modify("cant_proyect.Protect='1~tIf(IsNull(modifica) or IsNull(estado) or ISNull(flag_cnt_cmp),1,0)'")	 
idw_det_art.Modify("cnta_prsp.Protect='1~tIf(IsNull(flag_cerrado) or flag_estado <> ~~'3~~',1,0)'")	 
idw_det_art.Modify("fec_proyect.Protect='1~tIf(IsNull(flag_cerrado),1,0)'")
idw_det_art.Modify("flag_urgencia.Protect='1~tIf(IsNull(modifica),1,0)'")


end subroutine

public function integer of_control_ingresos ();String ls_flag_estado, ls_nro_orden, ls_ot_adm
Long ll_count

if dw_master.GetRow() = 0 then return 1

ls_flag_estado = dw_master.object.flag_estado[dw_master.getrow()] 
ls_nro_orden 	= dw_master.object.nro_orden 	[dw_master.getrow()] 
ls_ot_adm		= dw_master.object.ot_adm		[dw_master.GetRow()]

if ls_ot_adm = '' or IsNull(ls_ot_adm) then
	MessageBox('Aviso', 'Debe indicar primeramente un OT_ADM')
	dw_master.SetFocus()
	dw_master.SetColumn('ot_adm')
	return -1
end if

if ls_flag_estado='2' then
	messagebox('Orden de trabajo cerrada','No se puede adicionar mas items')
	return -1
end if

SELECT NVL(flag_cntrl_ot_plant,'0') 
  INTO :ls_flag_estado 
  FROM ot_administracion
 WHERE ot_adm = :ls_ot_adm;

IF ls_flag_estado='1' THEN 
	SELECT count(*) 
	  INTO :ll_count 
	  FROM prod_plant_lanz p 
	 WHERE p.nro_orden = :ls_nro_orden ;
	
	IF ll_count>0 THEN
		MessageBox('Aviso','No puede adicionar registros en OT con plantilla')
		return -1
	END IF
END IF 
return 1

end function

public function boolean of_set_articulo (string as_cod_art, u_dw_abc adw_op, u_dw_abc adw_art);string 	ls_almacen, ls_cod_clase, ls_flag_reposicion
Decimal	ldc_saldo_total, ld_costo_unit
// Setea las variables x defecto de acuerdo al codigo de articulo
// x ejemplo el almacen tácito y el precio en articulo_precio_pactado

if adw_op.GetRow() = 0 then return false

// Almacen Tacito
select cod_clase, NVL(flag_reposicion, '0')
	into :ls_cod_clase, :ls_flag_reposicion
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
where cod_origen = :gs_origen
  and cod_clase  = :ls_cod_clase;

if SQLCA.SQLCode = 100 then SetNull(ls_almacen)

adw_art.object.almacen 			[adw_art.GetRow()] = ls_almacen

if adw_art = idw_det_art then
	if Not IsNull(ls_almacen) then
		select sldo_total, NVL(flag_reposicion,'0')
			into :ldc_saldo_total, :ls_flag_reposicion
		from articulo_almacen
		where cod_art = :as_cod_art
		  and almacen = :ls_almacen;
		
		if SQLCA.SQLCode = 100 then ldc_saldo_total = 0
	else
		ldc_saldo_total = 0
	end if
	
	adw_art.object.flag_reposicion 	[adw_art.GetRow()] = ls_flag_reposicion
	
	// Todos los articulos tipo de reposicion de stock entran como pendientes (MM)
	IF ls_flag_reposicion = '1' THEN
		adw_art.object.flag_estado[adw_art.GetRow()] = '3'
	END IF
	adw_art.object.saldo_total [adw_art.GetRow()] = ldc_saldo_Total
	
	SELECT usf_cmp_prec_ult_compra(:as_cod_art, :ls_almacen ) 
	  INTO :ld_costo_unit 
	  FROM dual ;
	
	if ld_costo_unit <= 0 then
		MessageBox('Aviso', 'El articulo ' + as_cod_art + ' no tiene precio por favor verifique')
	end if
	
	adw_art.object.precio_unit[adw_art.GetRow()] = ld_costo_unit

end if

return true
end function

public subroutine of_retrieve_ot (string as_nro_orden);/*********************************************************************/
/* Función de Ventana de Recuperación de datos de la orden de trabajo*/
/*********************************************************************/
Long ll_row, ll_count, ll_oper_sec, ll_flag1, ll_flag2, ll_flag3
String ls_ot_adm, ls_mensaje
dwobject dwo

//REseteamos los datawindows
dw_master.ResetUpdate()
idw_det_ot.ResetUpdate()

idw_lista_op.ResetUpdate()
idw_det_op.ResetUpdate()
idw_det_art.ResetUpdate()

idw_oper_lista_ingreso.ResetUpdate()
idw_oper_ingresos.ResetUpdate()
idw_ingresos_art.ResetUpdate()

idw_otros_gastos.ResetUpdate()
idw_ot_distribucion.ResetUpdate()

idw_plantilla.ResetUpdate()
idw_lanza_plant.ResetUpdate()

dw_master.Reset()
idw_det_ot.Reset()

idw_lista_op.Reset()
idw_det_op.Reset()
idw_det_art.Reset()

idw_oper_lista_ingreso.Reset()
idw_oper_ingresos.Reset()
idw_ingresos_art.Reset()

idw_otros_gastos.Reset()
idw_ot_distribucion.Reset()

idw_plantilla.Reset()
idw_lanza_plant.Reset()



//-Recuperación de Orden de Trabajo
dw_master.Retrieve(as_nro_orden)

if dw_master.RowCount() > 0 then
	ls_ot_adm = dw_master.object.ot_adm [1]
	
	//Recuperando datos para lista de operaciones de la orden de trabajo
	idw_lista_op.Retrieve(as_nro_orden)
	
	if idw_lista_op.RowCount() > 0 then
		idw_lista_op.setRow(1)
		idw_lista_op.selectRow(0, false)
		idw_lista_op.SelectRow(1, true)
		
		idw_lista_op.event ue_output(1)
	end if
	
	idw_oper_lista_ingreso.Retrieve(as_nro_orden)
	
	if idw_oper_lista_ingreso.RowCount() > 0 then
		idw_oper_lista_ingreso.setRow(1)
		idw_oper_lista_ingreso.selectRow(0, false)
		idw_oper_lista_ingreso.SelectRow(1, true)
		
		idw_oper_lista_ingreso.event ue_output(1)
	end if
	
	idw_otros_gastos.Retrieve(as_nro_orden)
	idw_ot_distribucion.Retrieve(as_nro_orden)
	idw_lanza_plant.Retrieve(as_nro_orden)
	
	//-Recuperando datos plantilla, en caso halla cambiado el ot_adm
	idw_plantilla.Retrieve(gs_user, ls_ot_adm)
	
end if

//Bloquemos los datawindows
dw_master.ii_protect = 0
dw_master.of_protect()
dw_master.ii_update = 0

//Recuperando la lista de artículos requeridos
idw_det_art.ii_protect = 0
idw_det_art.of_protect()
idw_det_art.ii_update = 0

idw_det_op.ii_protect = 0
idw_det_op.of_protect()
idw_det_op.ii_update = 0

//-Recuperando datos para lista de operaciones de ingresos de la orden de trabajo
idw_oper_lista_ingreso.Retrieve(as_nro_orden)
idw_oper_lista_ingreso.ii_protect = 0
idw_oper_lista_ingreso.of_protect()

//distribucion de costo
idw_ot_distribucion.Retrieve(as_nro_orden)
idw_ot_distribucion.ii_protect = 0
idw_ot_distribucion.of_protect()
idw_ot_distribucion.ii_update = 0

//-Recupera Otros Gastos
idw_otros_gastos.Retrieve(as_nro_orden)
idw_otros_gastos.ii_protect = 0
idw_otros_gastos.of_protect()
idw_otros_gastos.ii_update = 0

//-Recupera Ingresos de Insumos Producidos
idw_ingresos_art.ii_protect = 0
idw_ingresos_art.of_protect()
idw_ingresos_art.ii_update = 0

IS_ACTION = 'fileopen'

end subroutine

on w_ope302_orden_trabajo.create
int iCurrent
call super::create
if this.MenuName = "m_master_lista_anular" then this.MenuID = create m_master_lista_anular
this.cb_8=create cb_8
this.sle_nro_ot=create sle_nro_ot
this.st_orden=create st_orden
this.cb_buscar=create cb_buscar
this.cb_5=create cb_5
this.cb_4=create cb_4
this.dw_master=create dw_master
this.tab_1=create tab_1
this.dw_rpt=create dw_rpt
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_8
this.Control[iCurrent+2]=this.sle_nro_ot
this.Control[iCurrent+3]=this.st_orden
this.Control[iCurrent+4]=this.cb_buscar
this.Control[iCurrent+5]=this.cb_5
this.Control[iCurrent+6]=this.cb_4
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.tab_1
this.Control[iCurrent+9]=this.dw_rpt
this.Control[iCurrent+10]=this.gb_2
end on

on w_ope302_orden_trabajo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_8)
destroy(this.sle_nro_ot)
destroy(this.st_orden)
destroy(this.cb_buscar)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.dw_master)
destroy(this.tab_1)
destroy(this.dw_rpt)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;String ls_nro_sol_orden, ls_tipo_doc
Long   ll_row
str_seleccionar_ot lstr_seleccionar



select doc_ot, cod_dolares, doc_oc
	into :is_doc_ot, :is_dolares, :is_doc_oc
from logparam 
where reckey = '1' ;

if SQLCA.SQlCode = 100 then
	MessageBox('Aviso','No tiene parametros en logparam')
	RETURN
end if

IF isnull(is_doc_ot) or is_doc_ot = '' THEN
	MessageBox('Aviso','Configure doc_ot en logparam')
	RETURN
END IF

IF isnull(is_doc_oc) or is_doc_oc = '' THEN
	MessageBox('Aviso','Configure doc_oc en logparam')
	RETURN
END IF

IF isnull(is_dolares) or is_dolares = '' THEN
	MessageBox('Aviso','Configure codigo dolares en logparam')
	RETURN
END IF

select NVL(flag_mod_cnta_prsp, '0')
	into :is_flag_cnta_prsp
from presup_param
where llave = '1' ;

if SQLCA.SQlCode = 100 then
	MessageBox('Aviso','No tiene parametros en presup_param')
	RETURN
end if

//Activar para que guarde el log_diario de la Orden de Trabajo
ib_log = true

sle_nro_ot.text = ''

of_position_window(0,0)        				// Posicionar la ventana en forma fija
im_1 = CREATE m_rButton
idw_1 = dw_master
//Help
ii_help = 302

//Transacciones
dw_master.SetTransObject(sqlca)					// Cabecera de la orden de Trabajo
idw_det_ot.SettransObject           (sqlca)	// Detalle  de la orden de Trabajo
idw_lista_op.SettransObject 		   (sqlca)	// Lista de Operaciones
idw_plantilla.SettransObject        (sqlca)	// Lista de Plantillas
idw_lanza_plant.SettransObject      (sqlca)	// Plantillas Tomadas en Cuenta
idw_det_art.SettransObject          (sqlca)	// Articulos de la Operación
idw_det_op.SettransObject     	   (sqlca)	// Detalle de Operaciones
idw_otros_gastos.SettransObject    	(sqlca)	// Otros gastos de ordenes de trabajo
idw_ot_distribucion.SettransObject  (sqlca)  // Distribución de Centro de Costo 

idw_oper_lista_ingreso.SettransObject  (sqlca)	// lista de operaciones para ingresos de insumos
idw_oper_ingresos.SettransObject  		(sqlca)	// detalle de operaciones para ingreso de insumos
idw_ingresos_art.SettransObject 			(sqlca)  // Ingreso de insumos al almacen



// Compartiendo dw
dw_master.sharedata(idw_det_ot)
idw_lista_op.sharedata(idw_det_op)
idw_oper_lista_ingreso.sharedata(idw_oper_ingresos)


////Recepcion de Solicitud de Orden de Trabajo
IF Isvalid(message.powerobjectparm) THEN //Proceso Normal
	IF message.powerobjectparm.Classname () = 'str_seleccionar_ot' THEN
			lstr_seleccionar = message.powerobjectparm
			//invocar objeto de autorización
		   nvo_nivel_aprobacion lnvo_nivel_aprobacion
			lnvo_nivel_aprobacion = CREATE nvo_nivel_aprobacion
			/**/

			ll_row = dw_master.Event ue_insert()	
			if ll_row > 0 then
				dw_master.object.nro_solicitud [ll_row] = lstr_seleccionar.param1  [1] //nro de sol
				dw_master.object.flag_estado   [ll_row] = lstr_seleccionar.param1  [2]
				dw_master.object.descripcion   [ll_row] = lstr_seleccionar.param1  [3]
				dw_master.object.cencos_rsp    [ll_row] = lstr_seleccionar.param1  [4]
				dw_master.object.cencos_slc    [ll_row] = lstr_seleccionar.param1  [5]
				dw_master.object.fec_solicitud [ll_row] = lstr_seleccionar.paramdt1[7]
				dw_master.object.cod_maquina   [ll_row] = lstr_seleccionar.param1  [8]
			END IF
			
			ls_tipo_doc    = 'SOT'
			
			//nivel de autorizacion
			lnvo_nivel_aprobacion.uf_insert_aprobacion(ls_tipo_doc,lstr_seleccionar.param1[1],gs_user,lstr_seleccionar.param1  [9])
			
			IS_ACTION = 'new'
	END IF
END IF	

idw_plantilla.Retrieve(gs_user, 'nada')
end event

event ue_insert;Long  	ll_row, ll_row_master, ll_row_op, ll_nro_ope, ll_mov_atrazados
Boolean  lb_flag = FALSE
String   ls_flag_estado, ls_cod_labor, ls_cod_ejecutor, ls_cencos_slc, ls_flag_estado_ope
Datetime ldt_fec_inicio
n_cst_diaz_retrazo lnvo_amp_retr

wf_accepttext() //accepttext del dw

ll_row_master = dw_master.Getrow()

IF ll_row_master > 0 THEN
	ls_flag_estado = dw_master.object.flag_estado [ll_row_master]	//estado de la orden de trabajo
	ls_cencos_slc  = dw_master.object.cencos_slc  [ll_row_master]
END IF

CHOOSE CASE idw_1
	 CASE dw_master
			
	  // Los dias de retrazo los toma de LogParam y el usuario de gs_user
	  lnvo_amp_retr = CREATE n_cst_diaz_retrazo
	  ll_mov_atrazados = lnvo_amp_retr.of_amp_retrazados( is_doc_ot )
		
	  DESTROY lnvo_amp_retr
	
	  if ll_mov_atrazados > 0 then
		  MessageBox('Aviso', 'Usted tiene pendientes ' + string(ll_mov_atrazados) &
				+ ' articulos proyectados en orden de trabajo. Reprograma previamente')
		  return
	  end if
	 
	  // Adicionando en dw_master
	  TriggerEvent ('ue_update_request') //verificar ii_update de los dw
	  IF ib_update_check = FALSE THEN RETURN
	  
	  // Limpieza de los demas dw en insercion
	  dw_master.Reset()
	  idw_det_ot.Reset()
	  idw_lista_op.Reset()
	  idw_det_op.Reset()
	  idw_det_art.Reset()
	  idw_lanza_plant.Reset()
	  idw_otros_gastos.Reset()
	  idw_ot_distribucion.Reset()
	  idw_oper_lista_ingreso.Reset()
	  idw_oper_ingresos.Reset()
	  idw_ingresos_art.Reset()
	  
	  //desproteger dw detalle 
	  idw_det_ot.ii_protect = 1
	  idw_det_ot.of_protect()
	  
	  //datos de plantillas
	  //asigna seccion general
		tab_1.tabpage_6.em_factor.text		 = '1'
		  
	CASE idw_lista_op
		Messagebox('Aviso','No puede ingresar Registros en esta opción')
		RETURN	
		  
	CASE idw_det_op
		IF Not(ls_flag_estado = '1' OR ls_flag_estado = '3') THEN 	
		  Messagebox('Aviso','No puede Insertar operaciones por el estado en que se Encuentra la Orden de Trabajo')
		  RETURN	
		END IF  
		  
	CASE idw_det_art
		  
		IF Not(ls_flag_estado = '1' OR ls_flag_estado = '3') THEN 	
		  Messagebox('Aviso','No puede Insertar Articulos por el estado en que se Encuentra la Orden de Trabajo')
		  RETURN	
		END IF
		
		//VERIFICAR datos de operacion
		ll_row_op  = idw_det_op.Getrow()
		ls_flag_estado_ope = idw_det_op.object.flag_estado [ll_row_op]
		
		IF Not(ls_flag_estado_ope = '1' OR ls_flag_estado_ope = '3') THEN 	
		  Messagebox('Aviso','No puede Insertar Articulos por el estado en que se Encuentra la Operación')
		  RETURN	
		END IF
		
		IF ll_row_op > 0 THEN
		  ll_nro_ope      = idw_det_op.object.nro_operacion [ll_row_op]
		  ls_cod_labor    = idw_det_op.object.cod_labor     [ll_row_op]
		  ls_cod_ejecutor = idw_det_op.object.cod_ejecutor  [ll_row_op]
		  ldt_fec_inicio  = idw_det_op.object.fec_inicio    [ll_row_op]
			
		  IF Isnull(ldt_fec_inicio) OR Trim(String(ldt_fec_inicio,'yyyymmdd')) = '00000000' THEN
			  Messagebox('Aviso','Debe Ingresar Fecha de Inicio de Operación , Verifique!')
			  Return
		  END IF	
		  IF Isnull(ls_cencos_slc) OR Trim(ls_cencos_slc) = '' THEN
			  Messagebox('Aviso','Debe Ingresar Centro de Costo Solicitante para Colocarle Articulo ,Verifique!')
			  Return	
		  END IF
		  
		  IF Isnull(ll_nro_ope) OR ll_nro_ope = 0 THEN
			  Messagebox('Aviso','Debe Ingresar Nro de Operación para Colocarle Articulo ,Verifique!')
			  Return
		  END IF
		  
		  IF Isnull(ls_cod_labor) OR Trim(ls_cod_labor) = '' THEN
			  Messagebox('Aviso','Debe Ingresar Labor de Operación ,Verifique!')
			  Return
		  END IF
		  
		  IF Isnull(ls_cod_ejecutor) OR Trim(ls_cod_ejecutor) = '' THEN
			  Messagebox('Aviso','Debe Ingresar Ejecutor de Operación ,Verifique!')
			  Return
		  END IF
		ELSE
		  Messagebox('Aviso','Debe Ingresar Operación para Colocarle Articulo ,Verifique!')
		  Return
		END IF	
	
	CASE idw_otros_gastos
		IF Not(ls_flag_estado = '1' OR ls_flag_estado = '3') THEN 	
		  Messagebox('Aviso','No puede insertar otros gastos por el estado de la Orden de Trabajo')
		  RETURN
		END IF
		
	CASE idw_ot_distribucion
		IF Not(ls_flag_estado = '1' OR ls_flag_estado = '3') THEN 	
		  Messagebox('Aviso','No puede Insertar Indicador de Mantenimiento por el Estado en que se Encuentra la Orden de Trabajo')
		  RETURN
		END IF	
	 
	CASE idw_ingresos_art
		IF Not(ls_flag_estado = '1' OR ls_flag_estado = '3') THEN 	
		  Messagebox('Aviso','No puede Insertar Articulos por el estado en que se Encuentra la Orden de Trabajo')
		  RETURN	
		END IF
		  
		//VERIFICAR datos de operacion
		ll_row_op  = tab_1.tabpage_3.dw_oper_ingresos.Getrow()
		IF ll_row_op > 0 THEN
		  ll_nro_ope      = tab_1.tabpage_3.dw_oper_ingresos.object.nro_operacion [ll_row_op]
		  ls_cod_labor    = tab_1.tabpage_3.dw_oper_ingresos.object.cod_labor     [ll_row_op]
		  ls_cod_ejecutor = tab_1.tabpage_3.dw_oper_ingresos.object.cod_ejecutor  [ll_row_op]
		  ldt_fec_inicio  = tab_1.tabpage_3.dw_oper_ingresos.object.fec_inicio    [ll_row_op]
			
		  IF Isnull(ldt_fec_inicio) OR Trim(String(ldt_fec_inicio,'yyyymmdd')) = '00000000' THEN
			  Messagebox('Aviso','Debe Ingresar Fecha de Inicio de Operación , Verifique!')
			  Return
		  END IF	
		  IF Isnull(ls_cencos_slc) OR Trim(ls_cencos_slc) = '' THEN
			  Messagebox('Aviso','Debe Ingresar Centro de Costo Solicitante para Colocarle Articulo ,Verifique!')
			  Return	
		  END IF
		  
		  IF Isnull(ll_nro_ope) OR ll_nro_ope = 0 THEN
			  Messagebox('Aviso','Debe Ingresar Nro de Operación para Colocarle Articulo ,Verifique!')
			  Return
		  END IF
		  
		  IF Isnull(ls_cod_labor) OR Trim(ls_cod_labor) = '' THEN
			  Messagebox('Aviso','Debe Ingresar Labor de Operación ,Verifique!')
			  Return
		  END IF
		  
		  IF Isnull(ls_cod_ejecutor) OR Trim(ls_cod_ejecutor) = '' THEN
			  Messagebox('Aviso','Debe Ingresar Ejecutor de Operación ,Verifique!')
			  Return
		  END IF
		ELSE
		  Messagebox('Aviso','Debe Ingresar Operación para Colocarle Articulo ,Verifique!')
		  Return
		END IF	
	
	
	CASE ELSE
		  RETURN
END CHOOSE

//insertar
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
END IF


end event

event ue_update;Boolean  lbo_ok = TRUE
String   ls_expresion,ls_origen,ls_msj_err
Long     ll_row_det, ll_oper_sec, ll_row
dwobject dwo

wf_accepttext()

THIS.EVENT ue_update_pre()

IF NOT ib_update_check THEN 
	Rollback ;
	Return
END IF

ll_row = idw_lista_op.GetRow()


IF ib_log  THEN
	// Grabo el Log de Maestro
	dw_master.of_create_log()
	idw_det_ot.of_create_log()
	
	// Grabo el Log de Operaciones
	idw_det_op.of_create_log()
	
	// Grabo el Log del Detalle del articulo
	idw_det_art.of_create_log()
	
	idw_ingresos_art.of_create_log()
	idw_ot_distribucion.of_create_log()
	idw_otros_gastos.of_create_log()

END IF


IF dw_master.ii_update = 1 OR idw_det_ot.ii_update = 1 THEN
	IF idw_det_ot.Update(true, false) = -1 then		// Grabacion del master
		lbo_ok = FALSE
		ls_msj_err = 'Error en Grabacion dw_det_ot'
		GOTO ERROR
	END IF
END IF

IF idw_det_op.ii_update = 1 THEN
	IF idw_det_op.Update(true, false) = -1 then		// Grabacion de operaciones
		lbo_ok = FALSE
		ls_msj_err = 'Error en Grabacion dw_det_op'
		GOTO ERROR
	END IF
END IF

IF idw_det_art.ii_update = 1 THEN
	IF idw_det_art.Update(true, false) = -1 then		// Grabacion de SALIDAS de insumos de operaciones
		lbo_ok = FALSE
		ls_msj_err = 'Error en Grabacion de Salida de Insumos'
		GOTO ERROR
	END IF
END IF

IF idw_ingresos_art.ii_update = 1 THEN
	IF idw_ingresos_art.Update(true, false) = -1 then //Grabacion de INGRESOS de insumos de operaciones 
		lbo_ok = FALSE
		ls_msj_err = 'Error en Grabacion de Ingresos de Insumos'
		GOTO ERROR
	END IF
END IF


IF idw_ot_distribucion.ii_update = 1 THEN
	IF idw_ot_distribucion.Update(true, false) = -1 then		// Grabacion del OT Costo
		lbo_ok = FALSE
		ls_msj_err = 'Error en Grabacion Distribucion OT Costo'
		GOTO ERROR
	END IF
END IF

IF idw_otros_gastos.ii_update = 1 THEN
	IF idw_otros_gastos.Update(true, false) = -1 then		// Grabacion de otros gastos
		lbo_ok = FALSE
		ls_msj_err = 'Error en Grabacion Otros Gastos'
		GOTO ERROR
	END IF
END IF

IF ib_log and lbo_ok THEN
	// Grabo el Log de Maestro
	dw_master.of_save_log()
	idw_det_ot.of_save_log()
	
	// Grabo el Log de Operaciones
	idw_det_op.of_save_log()
	
	// Grabo el Log del Detalle del articulo
	idw_det_art.of_save_log()
	
	idw_ingresos_art.of_save_log()
	idw_ot_distribucion.of_save_log()
	idw_otros_gastos.of_save_log()
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	
	dw_master.ii_update				= 0
	idw_det_ot.ii_update				= 0
	idw_det_op.ii_update				= 0
	idw_det_art.ii_update			= 0
	idw_ot_distribucion.ii_update	= 0
	idw_otros_gastos.ii_update		= 0
	idw_ingresos_art.ii_update 	= 0
	
	dw_master.ResetUpdate()
	idw_det_ot.ResetUpdate()
	idw_det_op.ResetUpdate()
	idw_det_art.ResetUpdate()
	idw_ot_distribucion.ResetUpdate()
	idw_otros_gastos.ResetUpdate()
	idw_ingresos_art.ResetUpdate()

	of_bloquear_dws()
	
	if ll_row <= idw_lista_op.RowCount() then
		idw_lista_op.SetRow(ll_row)
		idw_lista_op.event ue_output(ll_row)
	end if
	
	
	is_action = 'fileopen'
	f_mensaje("Cambios guardados satisfactoriamente", "")
 
ELSE 
	ERROR:
	ROLLBACK USING SQLCA;
	Messagebox(ls_msj_err,"Se ha procedido al rollback",exclamation!)
END IF

end event

event ue_modify;Long   ll_row_master
String ls_flag_estado

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN RETURN //NO EXISTE REGISTRO DE OT

ls_flag_estado = dw_master.Object.flag_estado [ll_row_master]

IF ls_flag_estado = '1' OR ls_flag_estado = '3' THEN //ACTIVO O PROYECTADO
	
	dw_master.of_protect()
	idw_det_ot.of_protect()
	idw_det_op.of_protect()
	idw_det_art.of_protect() //SALIDAS
	idw_ot_distribucion.of_protect()
	idw_otros_gastos.of_protect()
	idw_ingresos_art.of_protect() //INGRESOS

	
	IF idw_det_art.ii_protect = 0	THEN 
		of_modify()	 
	END IF
	
ELSE
	wf_bloquea_dw ()		
END IF

if is_flag_cnta_prsp = '1' then
	idw_det_art.object.cnta_prsp.protect = 1
	idw_det_art.object.cnta_prsp.background.color = RGB(192,192,192)   
end if

end event

event ue_update_pre;Long      	ll_row_det,ll_inicio
String    	ls_cod_origen, ls_nro_ot, ls_oper_sec, ls_cod_ejecutor, ls_Servicio, ls_flag_externo, &
				ls_ot_adm, ls_usuario
Long      	ll_row_master
Decimal   	ldc_cant_proy, ld_precio_unit
dwItemStatus 				ldis_status
nvo_numeradores_varios 	lnvo_numeradores_varios

//is_doc_ot
ib_update_check = false


//invocar objeto de numeracion de parte
lnvo_numeradores_varios    = CREATE nvo_numeradores_varios
//

ll_row_master = dw_master.Getrow()


IF dw_master.Rowcount() = 0 THEN
	Messagebox('Aviso','No existe Orden de Trabajo No Existe , Verifique!')
	RETURN
END IF

//--VERIFICACION Y ASIGNACION DE DATOS DE ORDEN DE TRABAJO
if gnvo_app.of_row_Processing( dw_master) <> true then return

//--VERIFICACION Y ASIGNACION DE DETALLE DE CABECERA
if gnvo_app.of_row_Processing( idw_det_ot) <> true then return

//--VERIFICACION Y ASIGNACION DE DATA EN DETALLE DE OPERACIONES
if gnvo_app.of_row_Processing( idw_det_op) <> true then return

//--VERIFICACION Y ASIGNACION DE DATOS EN DETALLE DE ARTICULOS
if gnvo_app.of_row_Processing( idw_det_art) <> true then return

//--VERIFICACION Y ASIGNACION DE DATOS EN INGRESOS DE ARTICULOS
if gnvo_app.of_row_Processing( idw_ingresos_art) <> true then return

//--VERIFICACION Y ASIGNACION DE DATOS EN DETALLE DE OTROS GASTOS
if gnvo_app.of_row_Processing( idw_otros_gastos) <> true then return

ls_cod_origen 	= dw_master.object.cod_origen [ll_row_master]
ls_nro_ot  		= dw_master.object.nro_orden  [ll_row_master] 
ls_ot_adm		= dw_master.object.ot_Adm	  	[ll_row_master] 
ls_usuario		= dw_master.object.cod_usr	  	[ll_row_master] 

if not invo_oper_ot.of_validar_ot_adm(ls_ot_adm, ls_usuario) then return


//Valido las operaciones
FOR ll_inicio = 1 TO idw_det_op.Rowcount() //detalle de operaciones
	//verifica si es un nuevo registro
	ls_cod_ejecutor 	= idw_det_op.object.cod_ejecutor [ll_inicio]
	ls_servicio	 		= idw_det_op.object.servicio 		[ll_inicio]
	 
	select nvl(flag_externo, '0')
		into :ls_flag_externo
	from ejecutor
	where cod_ejecutor = :ls_cod_ejecutor;
NEXT

IF IS_ACTION = 'new' THEN
	IF lnvo_numeradores_varios.uf_num_ot(ls_cod_origen,ls_nro_ot) = FALSE THEN RETURN
	dw_master.Object.nro_orden [ll_row_master] = ls_nro_ot
END IF

 
FOR ll_inicio = 1 TO idw_det_op.Rowcount() //detalle de operaciones
	 //verifica si es un nuevo registro
	 ls_oper_sec = idw_det_op.object.oper_sec [ll_inicio]
	 
	 IF idw_det_op.is_row_new(ll_inicio) or IsNull(ls_oper_sec) or trim(ls_oper_sec) = '' THEN
		 //genera oper_sec
		 IF lnvo_numeradores_varios.uf_num_oper_sec (gs_origen,ls_oper_sec) = FALSE THEN RETURN
		 
		 idw_det_op.object.oper_sec [ll_inicio] = ls_oper_sec

		 //actualiza datos de la orden de trabajo	
		 idw_det_op.Object.tipo_orden [ll_inicio] = is_doc_ot
		 idw_det_op.Object.nro_orden  [ll_inicio] = ls_nro_ot				 
	 END IF
NEXT


FOR ll_inicio = 1 TO idw_det_art.Rowcount()  //SALIDA DE articulo x operaciones
	 
	 if idw_det_art.is_row_modified(ll_inicio) then
		ldc_cant_proy 	= idw_det_art.Object.cant_proyect 	[ll_inicio]
		ld_precio_unit = idw_det_art.Object.precio_unit 	[ll_inicio]
		
		IF isnull(ld_precio_unit) THEN
			ld_precio_unit =0.1
		END IF
		
		IF ldc_cant_proy = 0.0000 OR Isnull(ldc_cant_proy) THEN
			Messagebox('Aviso','Debe Ingresar Alguna cantidad en articulo en el item ' &
						+ idw_det_art.Object.cod_art [ll_inicio], StopSign!)	
			ib_update_check = False
			Return
		END IF
	end if
	 
	ls_oper_sec = idw_det_op.object.oper_sec[idw_det_op.getrow()]
	idw_det_art.object.oper_sec [ll_inicio] = ls_oper_sec
	idw_det_art.object.tipo_doc [ll_inicio] = is_doc_ot
	idw_det_art.object.nro_doc  [ll_inicio] = ls_nro_ot
	 
NEXT


FOR ll_inicio = 1 TO idw_ingresos_art.Rowcount()  //INGRESO DE articulo x operaciones
	 
	if idw_ingresos_art.is_row_modified(ll_inicio) then
		//verifica si es un nuevo registro
		ldc_cant_proy = idw_ingresos_art.Object.cant_proyect [ll_inicio]
		
		IF ldc_cant_proy = 0.0000 OR Isnull(ldc_cant_proy) THEN
			Messagebox('Aviso','Debe Ingresar Alguna cantidad en articulo ')	
			ib_update_check = False
		 Return
		END IF
	end if
	
	ls_oper_sec = idw_oper_ingresos.object.oper_sec[idw_oper_ingresos.getrow()]
	idw_ingresos_art.object.oper_sec [ll_inicio] = ls_oper_sec
	idw_ingresos_art.object.tipo_doc [ll_inicio] = is_doc_ot
	idw_ingresos_art.object.nro_doc  [ll_inicio] = ls_nro_ot
	 
NEXT


//distribucion de centro de costo
FOR ll_inicio = 1  TO idw_ot_distribucion.Rowcount()
	idw_ot_distribucion.object.nro_orden [ll_inicio] = ls_nro_ot 
NEXT


FOR ll_inicio =1 TO idw_otros_gastos.Rowcount() //detalle de participantes
 	idw_otros_gastos.object.nro_orden [ll_inicio] = ls_nro_ot	
NEXT

dw_master.of_set_flag_replicacion()
idw_det_ot.of_set_flag_replicacion()
idw_det_op.of_set_flag_replicacion()
idw_det_art.of_set_flag_replicacion()
idw_ot_distribucion.of_set_flag_replicacion()
idw_otros_gastos.of_set_flag_replicacion()
idw_ingresos_art.of_set_flag_replicacion()

ib_update_check = true

end event

event ue_print;call super::ue_print;Integer 	li_row
String	ls_nro_orden
str_parametros lstr_param

if dw_master.getRow() = 0 then return
li_row = dw_master.getRow()

ls_nro_orden = dw_master.object.nro_orden [li_row]

lstr_param.dw1 		= 'd_rpt_formato_ot_tbl'
lstr_param.titulo 	= 'Previo de Orden de Trabajo [' + ls_nro_orden + "]"
lstr_param.string1 	= ls_nro_orden
lstr_param.posicion_paper = 2   //Portrait
lstr_param.tipo		= '1S'


OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end event

event ue_update_request;//override
Integer li_msg_result

wf_accepttext()

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1            OR idw_det_ot.ii_update        = 1 OR &
	 idw_det_op.ii_update = 1           OR idw_det_art.ii_update       = 1 OR &
	 idw_otros_gastos.ii_update = 1 		OR &
    tab_1.tabpage_5.dw_ot_distribucion.ii_update = 1  OR &
	 tab_1.tabpage_3.dw_ingresos_ins_tbl.ii_update = 1 ) THEN
	 li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	 IF li_msg_result = 1 THEN

 		 This.TriggerEvent("ue_update")
	 ELSE
		 dw_master.ii_update = 0
		 idw_det_ot.ii_update  = 0
	 	 idw_det_op.ii_update  = 0
		 idw_det_art.ii_update = 0
    	 tab_1.tabpage_5.dw_ot_distribucion.ii_update  = 0 
		 idw_otros_gastos.ii_update  = 0
		 tab_1.tabpage_3.dw_ingresos_ins_tbl.ii_update = 0
	 	
	 END IF
END IF

end event

event ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

sl_param.dw1     = 'd_abc_lista_orden_trabajo_x_usr_tbl'
sl_param.titulo  = 'Orden de Trabajo'
sl_param.tipo    = '1SQL'
sl_param.string1 =  "WHERE vw.USUARIO = '" + gs_user + "' " &
					  +  "ORDER BY vw.FEC_SOLICITUD DESC "


sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	of_retrieve_ot(sl_param.field_ret[2])
	sle_nro_ot.text = ''


	TriggerEvent ('ue_modify')
	
  	//asigna seccion general
	tab_1.tabpage_6.em_factor.text		 = '1'
	
END IF


end event

event ue_delete;//Override
Long   ll_row,ll_row_master,ll_row_det
String ls_flag_estado
Double ldb_cant_procesada

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN
ls_flag_estado = dw_master.Object.flag_estado [ll_row_master] // estado de la ot

IF ls_flag_estado = '0' OR ls_flag_estado = '2' THEN //no proyectado
	Messagebox('Aviso','Estado de la Orden de Trabajo No Permite Modificaciones , Verifique!')
	RETURN
END IF


CHOOSE CASE idw_1
		 CASE dw_master, idw_det_ot, idw_oper_lista_ingreso, idw_oper_ingresos, idw_lista_op //no elimina informacion de orden de trabajo
				Messagebox('Aviso','La operacion de eliminar no esta permitido en este panel', StopSign!)		
				Return
				
		 CASE	idw_det_op	
				ll_row_det  = idw_det_op.Getrow()
				IF ll_row_det = 0 THEN 
					Messagebox('Aviso','Debe seleccionar alguna operacion antes de eliminar', StopSign!)
					Return
				END IF
				
				ls_flag_estado = idw_det_op.object.flag_estado [ll_row_det]
				
				IF Not (ls_flag_estado = '3') THEN //NO PROYECTADO
					Messagebox('Aviso','No se puede Eliminar Operación por el estado en que se Encuentra')
					RETURN
				END IF
				idw_det_op.ii_update = 1
				
		 CASE idw_det_art 
				ll_row_det = idw_det_art.getrow()			
				
				IF ll_row_det = 0 THEN 
					Messagebox('Aviso','Seleccione Articulo a Eliminar')
					Return
				END IF
				
				ls_flag_estado = idw_1.object.flag_estado [ll_row_det]
				
				IF ls_flag_estado = '2' THEN
					//VERIFICAR SI ESTA PROCESADO
					MessageBox('Error', 'Requerimiento no se puede eliminar porque esta cerrado')
					return
				END IF
				
				IF ls_flag_estado = '1' THEN
					//VERIFICAR SI ESTA PROCESADO
					MessageBox('Error', 'Requerimiento no se puede eliminar porque esta aprobado')
					return
				END IF
				
				IF Dec(idw_det_art.Object.cant_procesada [ll_row_det]) > 0 THEN
					//VERIFICAR SI ESTA PROCESADO
					Messagebox('Aviso','Requerimiento no se puede eliminar porque registra consumo en Almacén, por favor Verifique!')
					RETURN
					
				END IF
				
		 CASE idw_ingresos_art //ARTICULOS QUE INGRESAN 
				ll_row_det = idw_ingresos_art.getrow()			
				
				IF ll_row_det = 0 THEN 
					Messagebox('Aviso','Seleccione Articulo a Eliminar')
					Return
				END IF
				
				IF ls_flag_estado = '2' THEN //articulo cerrado
					Messagebox('Aviso','No se puede Eliminar Operación por el estado en que se Encuentra')
					RETURN
				ELSEIF ls_flag_estado = '1' THEN
					//VERIFICAR SI ESTA PROCESADO
					ldb_cant_procesada = tab_1.tabpage_3.dw_ingresos_ins_tbl.Object.cant_procesada [ll_row_det]					
					
					IF Not( Isnull(ldb_cant_procesada) OR ldb_cant_procesada = 0 ) THEN
						Messagebox('Aviso','Cantidad de Articulo ha sido procesada ,Verifique!')
						RETURN
					END IF
					
					
				END IF
			
END CHOOSE
	
	
ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	This.Event ue_delete_list()
	This.Event ue_delete_pos(ll_row)
END IF


end event

event resize;call super::resize;of_asignar_dws()

tab_1.height  		= newheight - tab_1.y   - 50
tab_1.width  		= newwidth - tab_1.x   - 50


idw_det_ot.height  				= tab_1.height - idw_det_ot.y   - 150
idw_det_ot.width   				= tab_1.width  - idw_det_ot.x    - 100

idw_lista_op.height  			= tab_1.height - idw_lista_op.y   - 150
idw_det_op.width   				= tab_1.width  - idw_det_op.x    - 100
idw_det_art.width  				= tab_1.width  - idw_det_art.x   - 100
idw_det_art.height  				= tab_1.height - idw_det_art.y   - 150

idw_plantilla.height   			= tab_1.height - idw_plantilla.y   - 150
idw_lanza_plant.height 			= tab_1.height - idw_lanza_plant.y - 150

idw_otros_gastos.height 		= tab_1.height - idw_otros_gastos.y - 150
idw_otros_gastos.width  		= tab_1.width  - idw_otros_gastos.x - 100

idw_ot_distribucion.height 	= tab_1.height - idw_ot_distribucion.y - 150
idw_ot_distribucion.width  	= tab_1.width  - idw_ot_distribucion.x - 100

idw_oper_lista_ingreso.height = tab_1.height - idw_oper_lista_ingreso.y - 150
idw_ingresos_art.height 		= tab_1.height - idw_ingresos_art.y - 150
idw_ingresos_art.width  		= tab_1.width  - idw_ingresos_art.x - 100
idw_oper_ingresos.width  		= tab_1.width  - idw_oper_ingresos.x - 100



end event

event open;// Ancestor Script has been Override
of_asignar_dws()

IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF


//Obtengo el flag de centro de beneficio
select NVL(flag_centro_benef, '0')
	into :is_flag_cenbef
from logparam
where reckey = '1';

SELECT ejecutor_3ro 
	INTO :is_ejec_tercero 
FROM prod_param 
WHERE reckey='1' ;

//asigna seccion general
tab_1.tabpage_6.em_factor.text		 = '1'


//Abrir y recuperar (necesita parametros)
str_parametros sl_param
sl_param = Message.PowerObjectParm

String ls_nro_ot
Long ll_row, ll_operacion

If sl_param.opcion = 1 then
	ls_nro_ot = sl_param.string1
	ll_operacion = sl_param.long1

	of_retrieve_ot(ls_nro_ot)
	
	//Dirigirse al tab de Operaciones
	tab_1.SelectedTab = 2
	
	//Recuperar info del opersec
	//Busco row del opersec
	ll_row = idw_lista_op.Find("nro_operacion="+String(ll_operacion),1,idw_lista_op.RowCount())
	idw_1.BorderStyle = StyleRaised!
	idw_1 = idw_lista_op
	idw_1.BorderStyle = StyleLowered!
	
	idw_1.SelectRow(0, False)
	idw_1.SelectRow(ll_row, True)
	idw_1.SetRow(ll_row)

	IF ll_row = 0 Then Return
	
	idw_1.Event ue_output(ll_row)
	
	
END IF
end event

type cb_8 from commandbutton within w_ope302_orden_trabajo
integer x = 3781
integer y = 208
integer width = 347
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aprobación"
end type

event clicked;Integer li_row, li_cant
String	ls_ot, ls_aprob
str_parametros lstr_param, lstr_rep
Datastore lds_aprob
lds_aprob = Create DataStore
lds_aprob.DataObject = 'd_aprobacion_x_ot'
lds_aprob.SetTransObject(SQLCA)
IF dw_master.rowcount() < 1 THEN RETURN
ls_ot = dw_master.object.nro_orden[1]

IF isnull(ls_ot) or len(trim(ls_ot)) = 0 THEN RETURN
lds_aprob.retrieve(ls_ot)
li_cant = lds_aprob.rowcount()

IF li_cant = 0 THEN 
	DESTROY lds_aprob
	RETURN
END IF
ls_aprob = lds_aprob.object.nro_aprob[1]
DESTROY lds_aprob
//IF li_cant = 1 THEN
lstr_param.dw1 	= 'd_aprobacion_x_ot'
lstr_param.titulo 	= 'Aprobación [' + ls_aprob + ']'
lstr_param.string1 = ls_ot

OpenWithParm( w_lista_aprob, lstr_param)
lstr_param = Message.PowerObjectParm
IF lstr_param.titulo <> 'n' THEN
	lstr_rep.string1 = lstr_param.string1
ELSE
	RETURN
END IF
	lstr_rep.dw1 	= 'd_rpt_formato_aprob'
	lstr_rep.titulo 	= 'Aprobación [' + ls_aprob + ']'
	lstr_rep.posicion_paper = 2   //Portrait
	lstr_rep.tipo		= '1S'
	
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)

end event

type sle_nro_ot from u_sle_codigo within w_ope302_orden_trabajo
integer x = 3488
integer y = 72
integer width = 352
integer height = 80
integer taborder = 70
integer textsize = -8
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type st_orden from statictext within w_ope302_orden_trabajo
integer x = 3090
integer y = 72
integer width = 393
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Trabajo :"
boolean focusrectangle = false
end type

type cb_buscar from commandbutton within w_ope302_orden_trabajo
integer x = 3840
integer y = 64
integer width = 283
integer height = 100
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String ls_origen, ls_nro_ot
Long ll_count

ls_nro_ot = sle_nro_ot.text
IF ls_nro_ot = '' THEN
	MessageBox('Aviso', 'Debe Especificar un numero de Orden de Trabajo')
ELSE
	//Buscar
	select count(*) INTO :ll_count 
	  from orden_trabajo ot, ot_adm_usuario oa
	 where ot.ot_adm = oa.ot_adm and
      	 ot.nro_orden = :ls_nro_ot and
      	 oa.cod_usr	  = :gs_user ;

	IF ll_count>0 THEN
		of_retrieve_ot(ls_nro_ot)
		sle_nro_ot.text = ''
	ELSE
		Messagebox('Aviso', 'Orden de trabajo no existe o Ud. no esta autorizado a OT_ADM')
	END IF 
END IF
end event

type cb_5 from commandbutton within w_ope302_orden_trabajo
integer x = 3397
integer y = 208
integer width = 347
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cerrar OT"
end type

event clicked;Long    ll_row_master,ll_inicio
String  ls_flag_estado,ls_nro_orden,ls_tipo_ot,ls_mensaje
Boolean lb_ok = TRUE
Integer li_opcion

ll_row_master = dw_master.getrow()

IF ll_row_master>0 THEN
	li_opcion = MessageBox('Aviso','Esta seguro de cerrar orden de trabajo ', Question!, yesno!, 2)
	IF li_opcion = 2 THEN RETURN
ELSE
	MessageBox('Aviso','Seleccione previamente una orden de trabajo')
END IF

Parent.TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN

ls_flag_estado = dw_master.Object.flag_estado [ll_row_master]
ls_nro_orden   = dw_master.Object.nro_orden   [ll_row_master]

IF Not(ls_flag_estado = '1' OR ls_flag_estado = '3') THEN
	Messagebox('Aviso','Estado de la OT No esta disponible para cerrala Verifique!')
	RETURN
END IF

//create or replace procedure USP_OPE_CERRAR_OT(
//       asi_nro_ot           IN orden_trabajo.nro_orden%TYPE
//) IS

DECLARE 	USP_OPE_CERRAR_OT PROCEDURE FOR
			USP_OPE_CERRAR_OT( :ls_nro_orden);

EXECUTE 	USP_OPE_CERRAR_OT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_OPE_CERRAR_OT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_OPE_CERRAR_OT;

of_retrieve_ot( ls_nro_orden )

end event

type cb_4 from commandbutton within w_ope302_orden_trabajo
integer x = 3026
integer y = 208
integer width = 347
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Abrir OT"
end type

event clicked;Long    ll_row_master
String  ls_flag_estado, ls_msj_err, ls_tipo_ot, ls_nro_orden 
Integer li_opcion
Boolean lb_ok = TRUE

ll_row_master = dw_master.getrow()

IF ll_row_master>0 THEN
	li_opcion = MessageBox('Aviso','Esta Seguro de Abrir Orden de Trabajo ', Question!, yesno!, 2)
	IF li_opcion = 2 THEN RETURN
ELSE
	MessageBox('Aviso','Seleccione previamente una orden de trabajo')
	return
END IF

Parent.TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN

ls_flag_estado = dw_master.Object.flag_estado [ll_row_master]
ls_nro_orden	= dw_master.Object.nro_orden	 [ll_row_master]

select doc_ot into :ls_tipo_ot from prod_param where reckey = '1' ;


IF Not(ls_flag_estado = '2') THEN
	Messagebox('Aviso','Estado de la OT No esta disponible para Abrirla Verifique!')
	RETURN
END IF

DECLARE USP_USP_OPE_ABRE_OT PROCEDURE FOR 
	usp_ope_abre_ot( :ls_nro_orden);
											
EXECUTE USP_USP_OPE_ABRE_OT ;	

IF SQLCA.sqlcode = -1 THEN
	ls_msj_err =  SQLCA.SQLErrText
	Rollback ;
	Messagebox('Aviso','Error en Store Procedure USP_OPE_ABRE_OT: ' &
				+ ls_msj_err)
	Return
END IF	

CLOSE USP_USP_OPE_ABRE_OT ;

//actualiza estado de la OT
dw_master.object.flag_estado [ll_row_master] = '1'

//abrir correlativo
UPDATE campo_ciclo
   SET flag_estado = '1'
 WHERE (nro_orden = :ls_nro_orden);

dw_master.ii_update = 1

//ACTUALIZO DW
IF dw_master.update() = -1 						     THEN 
	ls_msj_err = 'Fallo Actualizacion de Cab. OT'
	lb_ok = FALSE
	GOTO ERROR
END IF
	
IF lb_ok THEN
	Commit ;
ELSE
	ERROR:
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
END IF
	
Parent.TriggerEvent('ue_modify')	
end event

type dw_master from u_dw_abc within w_ope302_orden_trabajo
integer width = 2985
integer height = 368
integer taborder = 30
string dataobject = "d_abc_orden_trabajo_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez


ii_ck[1] = 1		// columnas de lectrua de este dw

ii_dk[1] = 1 	   // columnas que se pasan al detalle


idw_mst  = dw_master

end event

event itemchanged;call super::itemchanged;String ls_descripcion, ls_ot_adm

Accepttext()

CHOOSE CASE dwo.name
		 CASE 'ot_adm'
				SELECT descripcion
				  INTO :ls_descripcion
				  FROM vw_cam_usr_adm
				 WHERE (cod_usr = :gs_user) and
				 		 (ot_adm  = :data   ) ;
				
				IF Isnull(ls_descripcion) OR Trim(ls_descripcion) = '' THEN
					SetNull(ls_descripcion)
					Messagebox('Aviso','Administracion No Existe , Verifique')
					This.object.ot_adm      [row] = ls_descripcion
					This.object.desc_ot_adm [row] = ls_descripcion
					Return 1
				END IF
				This.object.desc_ot_adm [row] = ls_descripcion
				
				// Recupera plantillas, en caso cambia de ot_adm
				ls_ot_adm = This.object.ot_adm [row]
				IF is_ot_adm <> ls_ot_adm THEN
					is_ot_adm = ls_ot_adm
					idw_plantilla.Retrieve(gs_user, ls_ot_adm)
				END IF 
				
		 CASE 'ot_tipo'
			   ls_ot_adm = This.object.ot_adm [row]
				
			   SELECT descripcion
				  INTO :ls_descripcion
				  FROM ot_tipo 
				 WHERE (ot_tipo = :data     ) ;

				
				IF Isnull(ls_descripcion) OR Trim(ls_descripcion) = '' THEN
					SetNull(ls_descripcion)
					Messagebox('Aviso','Tipo de OT No Existe , Verifique')
					This.object.ot_tipo      [row] = ls_descripcion
					This.object.desc_ot_tipo [row] = ls_descripcion
					Return 1
				END IF
				This.object.desc_ot_tipo [row] = ls_descripcion
				
END CHOOSE

end event

event clicked;call super::clicked;This.BorderStyle = StyleRaised!
idw_1 = THIS
This.BorderStyle = StyleLowered!

end event

event ue_insert_pre;call super::ue_insert_pre;dw_master.object.flag_estado  	 	[al_row] = '3'      //estado de la ot
dw_master.object.cod_origen   	 	[al_row] = gs_origen
dw_master.object.cod_usr      	 	[al_row] = gs_user
dw_master.object.fec_registro 	 	[al_row] = f_fecha_actual()
dw_master.object.fec_inicio   	 	[al_row] = Date(f_fecha_actual())
dw_master.object.fec_estimada 	 	[al_row] = Date(f_fecha_actual())
dw_master.object.flag_programado	 	[al_row] = '0'
dw_master.object.flag_estructura  	[al_row] = '0'      // Ot simple
dw_master.object.flag_costo_tipo 	[al_row] = 'F'		// Costo Fijo
dw_master.object.titulo 			 	[al_row] = '?'      // Ot simple

IS_ACTION = 'new'
end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String ls_adm,ls_name,ls_prot
str_seleccionar lstr_seleccionar


ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

This.Accepttext()


CHOOSE CASE dwo.name
	    CASE 'ot_tipo'

		
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT OT_TIPO.OT_TIPO AS CODIGO, '&   
												 +'OT_TIPO.DESCRIPCION  AS DESCRIPCION  '&   
												 +'FROM  OT_TIPO '&
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'ot_tipo',lstr_seleccionar.param1[1])
					Setitem(row,'desc_ot_tipo',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF												 
		 CASE 'ot_adm'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_CAM_USR_ADM.OT_ADM AS CODIGO, '&   
												 +'VW_CAM_USR_ADM.DESCRIPCION  AS DESCRIPCION  '&   
												 +'FROM  VW_CAM_USR_ADM '&
												 +'WHERE VW_CAM_USR_ADM.COD_USR = '+"'"+gs_user+"'"    	

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'ot_adm',lstr_seleccionar.param1[1])
					Setitem(row,'desc_ot_adm',lstr_seleccionar.param2[1])
					this.ii_update = 1
					// recupero plantilla, en caso halla cambiado ot_adm
					IF is_ot_adm <> lstr_seleccionar.param1[1] then
						is_ot_adm = lstr_seleccionar.param1[1]
						idw_plantilla.Retrieve(gs_user, lstr_seleccionar.param1[1])
					END IF
				END IF
END CHOOSE
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tab_1 from tab within w_ope302_orden_trabajo
event ue_popm ( integer ai_x,  integer ai_y )
string tag = "Operaciones"
integer y = 376
integer width = 4398
integer height = 2568
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean powertips = true
boolean boldselectedtext = true
boolean pictureonright = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_5 tabpage_5
tabpage_4 tabpage_4
tabpage_6 tabpage_6
end type

event ue_popm(integer ai_x, integer ai_y);Parent.Event Post Dynamic ue_PopM(ai_x, ai_y)
end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_5=create tabpage_5
this.tabpage_4=create tabpage_4
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_5,&
this.tabpage_4,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_5)
destroy(this.tabpage_4)
destroy(this.tabpage_6)
end on

event clicked;//String ls_ot_adm
//
//IF dw_master.Getrow() = 0 then return
//
//ls_ot_adm = dw_master.object.ot_adm[dw_master.GetRow()]
//
//tab_1.tabpage_2.dw_plantilla.Retrieve(gs_user, ls_ot_adm)
end event

type tabpage_1 from userobject within tab_1
event ue_popm ( integer ai_x,  integer ai_y )
integer x = 18
integer y = 112
integer width = 4361
integer height = 2440
long backcolor = 79741120
string text = "Orden de Trabajo"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Query!"
long picturemaskcolor = 536870912
string powertiptext = "Detalles de la Orden de Trabajo"
dw_det_ot dw_det_ot
end type

event ue_popm(integer ai_x, integer ai_y);Parent.Event Post ue_popm(ai_x, ai_y)
end event

on tabpage_1.create
this.dw_det_ot=create dw_det_ot
this.Control[]={this.dw_det_ot}
end on

on tabpage_1.destroy
destroy(this.dw_det_ot)
end on

type dw_det_ot from u_dw_abc within tabpage_1
integer width = 3150
integer height = 1376
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_orden_trabajo_ff_det"
boolean maxbox = true
boolean hscrollbar = false
boolean vscrollbar = false
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;
ii_ck[1] = 1			// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle


end event

event itemerror;call super::itemerror;RETURN 1
end event

event itemchanged;call super::itemchanged;Integer  li_count = 0, li_rpta
Long     ll_row, ll_nbrow, li
String 	ls_desc, ls_codigo, ls_null, ls_tercero, ls_ejecutor, &
			ls_cencos, ls_lote, ls_cliente

Accepttext()
SetNull(ls_null)

CHOOSE CASE dwo.name
	CASE 'cencos_slc'
		
		// Actualiza las operaciones
		ll_nbrow = long(tab_1.tabpage_2.dw_det_op.RowCount()) //numero de operaciones por orden de trabajo
			
		FOR li=1 to ll_nbrow
			tab_1.tabpage_2.dw_det_op.ii_update=1
			// Actualiza siempre y cuando la operacion este proyectada
			IF tab_1.tabpage_2.dw_det_op.object.flag_estado[li] = '3' THEN
				tab_1.tabpage_2.dw_det_op.object.cencos[li] = data
			END IF
				
		NEXT
				
		// Actualiza articulo movimiento proyectado		
		idw_det_art.SetFilter('cant_procesada > 0')
		idw_det_art.Filter()

		IF idw_det_art.Rowcount() > 0 THEN
			This.Object.cencos_slc[row] = idw_det_art.Object.cencos[1] 
			
			Messagebox('Aviso','Orden de Trabajo Ya Tiene Articulos Proyectados Considerando '&
						 +'el Centro de Costo Actual, Verifique')
						 
			idw_lista_op.TriggerEvent(clicked!)
			
			idw_det_art.SetFilter('')
			idw_det_art.Filter()
			
			Return 1
		END IF
		idw_det_art.SetFilter('')
		idw_det_art.Filter()
		
		//Verificar Centro de Costo Exista
		SELECT desc_cencos
		  INTO :ls_desc
		  FROM centros_costo
		 WHERE cencos      =  :data 
		 	AND flag_estado = '1';
					  
			
		IF SQLCA.SQLCode = 100 THEN
			This.Object.cencos_slc  	 [row] = ls_null
			This.Object.desc_cencos_slc [row] = ls_null
			Messagebox('Aviso','Centro de Costo ' + data + ' no existe o no esta activo, por favor verifique!', StopSign!)	
			Return 1
		END IF
		
		this.Setitem( row, 'desc_cencos_slc', ls_desc )
				
	CASE 'cencos_rsp'
		
		SELECT desc_cencos
		  INTO :ls_desc
		  FROM centros_costo
		 WHERE cencos       = :data 
		 	AND flag_estado <> '0';
		
		IF SQLCA.SQLCode = 100 THEN
			This.Object.cencos_rsp		[row] = ls_null
			This.Object.desc_cencos_rsp[row] = ls_null
			Messagebox('Aviso','Centro de Costo ' + data + ' no existe o no esta activo, por favor verifique!', StopSign!)	
			Return 1
		END IF
		
		This.Object.desc_cencos_rsp[row] = ls_desc
			
	CASE 'cliente'
			
		SELECT nom_proveedor
		  INTO :ls_desc
		  FROM proveedor
		 WHERE proveedor   =  :data 
			AND flag_estado <> '0';
		
		IF SQLCA.SQLCode = 100 THEN
			This.Object.cliente		[row] = ls_null
			This.Object.nom_cliente [row] = ls_null
			Messagebox('Aviso','Codigo de relacion ' + data + " no existe o no se encuentra activo, por favor verifique!", StopSign!)					
			Return 1
		END IF
		
		this.object.nom_cliente [row] = ls_desc

		// Actualiza codigo de cliente a operaciones proyectadas si las hubiera
		ll_nbrow = long(tab_1.tabpage_2.dw_det_op.RowCount())
		
		FOR li=1 to ll_nbrow 
			tab_1.tabpage_2.dw_det_op.ii_update=1
			ls_ejecutor = tab_1.tabpage_2.dw_det_op.object.cod_ejecutor[li]
			
			select NVL(flag_externo,'0') 
			 into :ls_tercero
			  from ejecutor
			 where cod_ejecutor = :ls_ejecutor ;

			//flag_facturacion
			IF ls_tercero = '1' THEN
				tab_1.tabpage_2.dw_det_op.object.flag_facturacion[li] = 'F'
			ELSE
				tab_1.tabpage_2.dw_det_op.object.flag_facturacion[li] = 'N'
			END IF
			// Solo a las operaciones proyectadas
			IF tab_1.tabpage_2.dw_det_op.object.flag_estado[li] = '3' THEN
				tab_1.tabpage_2.dw_det_op.object.proveedor[li] = data
			END IF
			
		NEXT

	CASE 'nro_ov'
		ls_cliente = this.object.cliente	[row]
		
		if ISNull(ls_cliente) or trim(ls_cliente) = '' then
			MessageBox('Error', 'No se ha seleccionado ningun cliente, por favor corrija!', StopSign!)
			return 
		end if
			
		SELECT obs
		  INTO :ls_desc
		  FROM orden_Venta
		 WHERE nro_ov 		= :data 
		   and cliente 	= :ls_cliente
			AND flag_estado <> '0';
		
		IF SQLCA.SQLCode = 100 THEN
			This.Object.nro_ov [row] = ls_null
			This.Object.obs    [row] = ls_null
			Messagebox('Aviso','Nro de Orden de Venta ' + data + " no existe, no se encuentra activo o no le pertenece al cliente " &
									+ ls_cliente + ", por favor verifique y corrija!", StopSign! )	
			Return 1
		END IF
		
		This.Object.obs    [row] = ls_desc
			
	 CASE 'cod_maquina'
			
		SELECT desc_maq
		  INTO :ls_desc
		  FROM maquina
		 WHERE cod_maquina = :data 
			AND flag_estado <> '0';
		
		IF SQLCA.SQLCode = 100 THEN
			This.Object.cod_maquina [row] = ls_null
			This.Object.desc_maq    [row] = ls_null
			Messagebox('Aviso','Codigo de Maquina ' + data + " no existe o no es valida", STopSign!)	
			Return 1
		END IF
		
		This.Object.desc_maq    [row] = ls_desc
			
	CASE 'centro_benef'
		
		ls_cencos = this.object.cencos_slc[row]
		if ls_cencos = '' or IsNull(ls_cencos) then
			MessageBox('Aviso', 'Debe Ingresar un Centro de Costo Solicitante', StopSign!)
			this.object.centro_benef [row] = ls_null
			this.setColumn('cencos_slc')
			return 1
		end if
		
		select a.desc_centro
		  into :ls_desc
		  from centro_beneficio a
		 where a.centro_benef = :data
		   and a.flag_estado = '1';

		IF SQLCA.SQLCode = 100 THEN
			This.Object.centro_benef    	[row] = ls_null
			This.Object.desc_centro_benef [row] = ls_null
			Messagebox('Aviso','Centro de Beneficios ' + data + ' no existe, no se encuentra activo ' &
				+ ', por favor verifique', StopSign!)
			RETURN 1
		END IF
		
		This.Object.desc_centro_benef [row] = ls_desc
			
		
	CASE 'plant_ratio'
		
		SELECT desc_plantilla
		  INTO :ls_desc
		  FROM prod_ratio
		 WHERE cod_plantilla = :data ;
			
		IF SQLCA.SQLCode = 100 THEN
			This.Object.plant_ratio    [row] = ls_null
			This.Object.desc_plantilla [row] = ls_null
			Messagebox('Aviso','Plantilla de Ratios no existe, por favor verifique')
			RETURN 1
		END IF
		This.Object.desc_plantilla [row] = ls_desc
		
	CASE 'fec_estimada'
		This.Object.fec_inicio[row] = This.Object.fec_estimada[row]

	CASE 'lote_campo'
		SELECT descripcion
			INTO :ls_desc
		FROM lote_campo
		WHERE nro_lote = :data 
		AND flag_estado <> '0';
		
		IF SQLCA.SQLCode = 100 THEN
			This.Object.lote_campo [row] = ls_null
			This.Object.desc_lote  [row] = ls_null
			Messagebox('Aviso','Debe Ingresar un lote válido')	
			Return 1
		END IF
		
		this.object.desc_lote 		[row] = ls_desc
		this.object.variedad 		[row] = ls_null
		this.object.desc_variedad 	[row] = ls_null
			 
	CASE 'variedad'
		ls_lote = this.object.lote_campo [row]
		
		if IsNull(ls_lote) or ls_lote = '' then
			MessageBox("Error", "Debe especificar un número de lote")
			this.setColumn("lote_campo")
			return
		end if
		
		SELECT a.desc_art
			INTO :ls_desc
		FROM articulo a,
			  cultivos c
		WHERE c.variedad = a.cod_art
			and a.cod_art = :data 
			AND c.flag_estado <> '0'
			and c.nro_lote = :ls_lote;
		
		IF SQLCA.SQLCode = 100 THEN
			This.Object.variedad 		[row] = ls_null
			This.Object.desc_variedad  [row] = ls_null
			Messagebox('Aviso','Debe Ingresar una variedad válida')	
			Return 1
		END IF
		
		This.Object.desc_variedad  [row] = ls_desc

END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;
// Si el flag de Centro de Beneficio esta activo entonces
// Debo pedir obligatoriamente un centro de beneficio
if is_flag_cenbef = '1' then
	this.object.centro_benef.edit.required = 'Yes'
end if
end event

event clicked;call super::clicked;idw_det_ot = this
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;String 		ls_sql, ls_cod_maq, ls_codigo, ls_data, ls_filter, ls_ejecutor, &
				ls_tercero, ls_cencos, ls_lote, ls_cliente, ls_origen
Boolean		lb_ret
Decimal		ldc_prox_mtto
Long 			ll_nbrow, li
str_maquinas	lstr_maquina

try 

	CHOOSE CASE lower(as_columna)
		CASE 'cencos_slc','cencos_rsp'
			ls_origen = this.object.cod_origen [al_Row]
			
			ls_sql = "SELECT CENCOS AS Código_CENCOS, " &
					 + "DESC_CENCOS AS DESCRIPCION_cencos "		&     	
					 + "FROM CENTROS_COSTO " &
					 + "WHERE FLAG_ESTADO = '1' " &
					 + "  and origen = '" + ls_origen + "'"
		
		CASE 'cliente'
			ls_sql = "SELECT PROVEEDOR AS CODIGO," &
					 + "NOM_PROVEEDOR AS NOMBRE, "	&
					 + "TIPO_PROVEEDOR AS TIPO "		&
					 + "FROM PROVEEDOR "					&	
					 + "WHERE PROVEEDOR.FLAG_ESTADO = '1' "
	
		CASE 'nro_ov'
			ls_cliente = this.object.cliente	[al_row]
			
			if ISNull(ls_cliente) or trim(ls_cliente) = '' then
				MessageBox('Error', 'No se ha seleccionado ningun cliente, por favor corrija!', StopSign!)
				return 
			end if
			
			ls_sql = "SELECT ov.nro_ov as numero_ov, " &
					 + "ov.obs as observaciones " &
					 + "FROM ORDEN_vENTA ov " &
					 + "where ov.flag_estado = '1' " &
					 + "  and ov.cliente     = '" + ls_cliente + "'"				 
					 
		CASE 'responsable'
			
			if gnvo_app.of_get_parametro("OPER_OT_RESPONSABLE_TERCERO", "0") = "0" THEN
				ls_sql = "SELECT M.COD_TRABAJADOR AS CODIGO, "&
						 + "m.nom_trabajador AS nom_trabajador " 	&
						 + "FROM vw_pr_trabajador M "					&	
						 + "WHERE M.FLAG_ESTADO = '1'"
			else
				ls_sql = "select p.proveedor as codigo, "&
						 + "       p.nom_proveedor as nombre_proveedor "&
						 + "from proveedor p "&
						 + "where p.flag_estado = '1'"
			end if
			
													 
		CASE	'cod_maquina'
			lstr_maquina = gnvo_app.of_get_maquina()
			
			if lstr_maquina.b_return then
				this.object.cod_maquina	[al_row] = lstr_maquina.cod_maquina
				this.object.desc_maq		[al_row] = lstr_maquina.desc_maquina
				this.ii_update = 1
			end if
			return												 
													 
		CASE 'plant_ratio'
		  ls_sql   = "SELECT COD_PLANTILLA AS CODIGO, "&
					  + "DESC_PLANTILLA AS DESCRIPCION "&
					  + "FROM PROD_RATIO "&
					  + "WHERE FLAG_ESTADO = '1'"
		
		CASE 'centro_benef'
			ls_cencos = this.object.cencos_slc[al_row]
			if ls_cencos = '' or IsNull(ls_cencos) then
				MessageBox('Aviso', 'Debe ingresar un Centro de costo Solicitante')
				return
			end if
			
			ls_sql   = "SELECT distinct a.CENTRO_BENEF AS centro_beneficio, "&
						+ "a.DESC_centro AS DESCRIPCION_centro "&
						+ "FROM centro_beneficio a " &
						+ "WHERE a.FLAG_ESTADO = '1' " &
						+ "and NVL(a.FLAG_ESTRUCTURA, '0') = '0' "
	
		CASE 'prog_mnt'
			ls_cod_maq = this.object.cod_maquina [al_row]
			if IsNull(ls_Cod_maq) or ls_cod_maq = '' then
				MessageBox('Aviso', 'Debe ingresar un codigo de Equipo')
				return
			end if
			
			  ls_sql   = "select a.prog_mnt as cod_prog_mnt, " &
						  + "a.cod_plantilla as codigo_plantilla, " &
						+ "b.desc_plantilla as descripcion_plantilla, " &
						+ "a.frecuencia as frecuencia_plantilla " &
						+ "from mt_prog_ciclo_mantto a, " &
						+ "plant_prod           b " &
						+ "where a.cod_plantilla = b.cod_plantilla " &
						+ "and a.flag_estado = '1' " &
						+ "and b.flag_estado = '1' " &
						+ "and a.cod_maquina = '" + ls_cod_maq + "'"
		  
		CASE 'lote_campo'
		  ls_sql   = "SELECT a.nro_lote AS CODIGO_lote, "&
					  + "a.descripcion AS DESCRIPCION_lote, "&
					  + "a.cencos AS codigo_cencos, "&
					  + "cc.desc_cencos as descripcion_cencos, " &
					  + "a.total_ha as total_hectareas " &
					  + "FROM lote_campo a, "&
					  + "centros_costo cc " &
					  + "WHERE a.cencos = cc.cencos " &
					  + "and a.FLAG_ESTADO = '1'"
	
		CASE 'variedad'
			ls_lote = this.object.lote_campo [al_row]
			
			if isnull(ls_lote) or ls_lote = '' then
				MessageBox('Error', 'Debe especificar un numero de lote')
				this.setColumn('lote_campo')
				return
			end if
			
			ls_sql   = "SELECT a.cod_art AS CODIGO_articulo, "&
						 + "a.desc_art AS DESCRIPCION_artículo, "&
						+ "a.und AS unidad "&
						+ "FROM articulo a, "&
						+ "cultivos cc " &
						+ "WHERE a.cod_art = cc.variedad " &
						+ "and a.FLAG_ESTADO = '1' " &
						+ "and cc.nro_lote = '" + ls_lote + "'"
	
	END CHOOSE			
	
	if ls_sql <> '' then
		if not gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then return
	end if
	
	CHOOSE CASE lower(as_columna)
		CASE 'cencos_slc'
			this.object.cencos_slc		[al_row] = ls_codigo
			this.object.desc_Cencos_slc[al_row] = ls_data
			this.ii_update = 1
	
			//Actualiza las operaciones, si las hubiera
			ll_nbrow = long(tab_1.tabpage_2.dw_det_op.RowCount()) //numero de operaciones por orden de trabajo
				
			FOR li=1 to ll_nbrow
				tab_1.tabpage_2.dw_det_op.ii_update=1
				IF tab_1.tabpage_2.dw_det_op.object.flag_estado[li] = '3' THEN
					tab_1.tabpage_2.dw_det_op.object.cencos[li] = ls_codigo
				END IF
					
			NEXT	
			
			
			return
			
		CASE 'cencos_rsp'
			this.object.cencos_rsp		[al_row] = ls_codigo
			this.object.desc_cencos_rsp[al_row] = ls_data
			this.ii_update = 1
			return
			
		CASE	'cliente'
			this.object.cliente		[al_row] = ls_codigo
			this.object.nom_cliente	[al_row] = ls_data
			this.ii_update = 1
			
			// Actualiza las operaciones proyectadas
			ll_nbrow = long(tab_1.tabpage_2.dw_det_op.RowCount())
			for li=1 to ll_nbrow 
				tab_1.tabpage_2.dw_det_op.ii_update=1
				ls_ejecutor = tab_1.tabpage_2.dw_det_op.object.cod_ejecutor[li]
				
				select NVL(flag_externo,'0') 
				 into :ls_tercero
				  from ejecutor
				 where cod_ejecutor = :ls_ejecutor ;
	
				//flag_facturacion
				IF ls_tercero = '1' THEN
					tab_1.tabpage_2.dw_det_op.object.flag_facturacion[li] = 'F'
				ELSE
					tab_1.tabpage_2.dw_det_op.object.flag_facturacion[li] = 'N'
				END IF
				
				// Solo a las operaciones proyectadas
				IF tab_1.tabpage_2.dw_det_op.object.flag_estado[li] = '3' THEN
					tab_1.tabpage_2.dw_det_op.object.proveedor[li] = ls_codigo
				END IF
				
			next
	
			return
		
		CASE	'nro_ov'
			this.object.nro_ov	[al_row] = ls_codigo
			this.object.obs		[al_row] = ls_data
			this.ii_update = 1
			return
			
		CASE	'responsable'
			this.object.responsable		[al_row] = ls_codigo
			this.object.nom_responsable[al_row] = ls_data
			this.ii_update = 1
			return
			
	
			
		CASE 'plant_ratio'
			this.object.plant_ratio		[al_row] = ls_codigo
			this.object.desc_plantilla	[al_row] = ls_data
			this.ii_update = 1
			return
	
		CASE 'centro_benef'
			this.object.centro_benef		[al_row] = ls_codigo
			this.object.desc_centro_benef	[al_row] = ls_data
			this.ii_update = 1
			return
	
		CASE 'prog_mnt'
			select ULTIMO_MNT + frecuencia + REPROGRAMACION
				into :ldc_prox_mtto
			from mt_prog_ciclo_mantto
			where prog_mnt = :ls_codigo;
			
			if SQLCA.SQLCode = 100 then
				MessageBox('Error', 'No existe PROG_MNT ' + ls_codigo)
				return
			end if
			
			ls_filter = "cod_plantilla = '" + ls_data + "'"
			
			idw_plantilla.SetFilter(ls_filter)
			idw_plantilla.Filter()
			
			this.object.prog_mnt				[al_row] = ls_codigo
			this.object.mnt_und_act_proy	[al_row] = ldc_prox_mtto
			this.ii_update = 1
			return
			
		CASE 'lote_campo'
			this.object.lote_campo	 	[al_row] = ls_codigo
			this.object.desc_lote	 	[al_row] = ls_data
			this.object.variedad	 	 	[al_row] = gnvo_app.is_null
			this.object.desc_variedad	[al_row] = gnvo_app.is_null
			this.ii_update = 1
			return
	
		CASE 'variedad'
			this.object.variedad			[al_row] = ls_codigo
			this.object.desc_variedad	[al_row] = ls_data
			this.ii_update = 1
			return
			
	END CHOOSE	

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Ha ocurrido una exception')

end try

		



end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

type tabpage_2 from userobject within tab_1
event ue_popm ( integer ai_x,  integer ai_y )
string tag = "Operaciones"
integer x = 18
integer y = 112
integer width = 4361
integer height = 2440
long backcolor = 79741120
string text = "Operaciones"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ToDoList!"
long picturemaskcolor = 536870912
string powertiptext = "Operaciones"
pb_1 pb_1
st_campo st_campo
dw_lista_op dw_lista_op
dw_find dw_find
dw_det_op dw_det_op
dw_det_art dw_det_art
end type

event ue_popm(integer ai_x, integer ai_y);Parent.Event Post ue_popm(ai_x, ai_y)
end event

on tabpage_2.create
this.pb_1=create pb_1
this.st_campo=create st_campo
this.dw_lista_op=create dw_lista_op
this.dw_find=create dw_find
this.dw_det_op=create dw_det_op
this.dw_det_art=create dw_det_art
this.Control[]={this.pb_1,&
this.st_campo,&
this.dw_lista_op,&
this.dw_find,&
this.dw_det_op,&
this.dw_det_art}
end on

on tabpage_2.destroy
destroy(this.pb_1)
destroy(this.st_campo)
destroy(this.dw_lista_op)
destroy(this.dw_find)
destroy(this.dw_det_op)
destroy(this.dw_det_art)
end on

type pb_1 from picturebutton within tabpage_2
integer x = 1079
integer width = 133
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\Toolbar\actualiza.png"
string disabledname = "C:\SIGRE\resources\Toolbar\actualiza.png"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Refrescar operaciones"
end type

event clicked;wf_retrieve_operaciones_ing()
end event

type st_campo from statictext within tabpage_2
integer x = 14
integer y = 36
integer width = 1029
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Buscar por :"
boolean focusrectangle = false
end type

type dw_lista_op from u_dw_abc within tabpage_2
integer x = 9
integer y = 204
integer width = 1207
integer height = 1228
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_operaciones_ot_tbl"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

if row = 0 then return

This.SelectRow(0, False)
This.SelectRow(row, True)
This.SetRow(row)

This.Event ue_output(row)



end event

event constructor;call super::constructor;idw_det = dw_det_op

ii_ck[1] = 1		// columnas de lectrua de este dw
ii_dk[1] = 21     // columnas que se pasan al detalle

ii_ss = 1
is_dwform = 'tabular'

end event

event ue_output;call super::ue_output;string 	ls_nro_orden, ls_oper_sec
Integer 	li_operacion

if al_row > 0 then

	THIS.EVENT ue_retrieve_det(al_row)

	idw_det.ScrollToRow(al_row)

	li_operacion = idw_lista_op.object.nro_operacion 	[al_row]
	ls_nro_orden = idw_lista_op.object.nro_orden			[al_row]
	
	ls_oper_sec = this.object.oper_sec [al_row]
	
	idw_det_art.retrieve(ls_oper_sec)
		
		
	idw_det_art.ResetUpdate()
	idw_det_art.ii_update = 0
	
	idw_det_art.ii_protect = 0
	idw_det_art.of_protect()

	
	//Recuperando datos para los lanzamientos
	idw_lanza_plant.Retrieve(ls_nro_orden)

end if



end event

event ue_insert_pre;call super::ue_insert_pre;String  ls_nro_orden
Date    ld_fec_inicio_est, ld_fec_inicio


ls_nro_orden      = dw_master.object.nro_orden[1] 
ld_fec_inicio_est = today() 
ld_fec_inicio     = today()

// Asignando datos de dw_master
This.SetItem( al_row, "tipo_orden", is_doc_ot )
This.SetItem( al_row, "nro_orden", ls_nro_orden )
This.SetItem( al_row, "flag_estado", '3' )



end event

event doubleclicked;Integer li_pos, li_col
String  ls_column , ls_report, ls_color,ls_data_type,ls_col_tipo
Long ll_row


li_col = tab_1.tabpage_2.dw_lista_op.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	ls_col_tipo = is_col+'.coltype' 
	ls_data_type = this.Describe(ls_col_tipo)
	is_data_type = Mid(ls_data_type,1,pos(ls_data_type,'(') - 1)

	st_campo.text = "Buscar por :" + Trim(is_col)
	dw_find.reset()
	dw_find.InsertRow(0)
	dw_find.SetFocus()
	This.SelectRow(0, False)
END IF

if row = 0 then
	IF is_dwform = 'tabular' THEN
		THIS.Event ue_column_sort()
	end if
end if
end event

event rowfocuschanged;call super::rowfocuschanged;Int li_nro_operacion
Long ll_found

This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)



idw_det_op.Setrow(currentrow)
idw_det_op.ScrollToRow(currentrow)


end event

type dw_find from datawindow within tabpage_2
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 9
integer y = 108
integer width = 1207
integer height = 84
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long dw_enter();
tab_1.tabpage_2.dw_lista_op.triggerevent(doubleclicked!)
return 1
end event

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

IF keydown(keyuparrow!) THEN		// Anterior
	tab_1.tabpage_2.dw_lista_op.scrollpriorRow()
ELSEIF keydown(keydownarrow!) THEN	// Siguiente
	tab_1.tabpage_2.dw_lista_op.scrollnextrow()	
END IF
ll_row = tab_1.tabpage_2.dw_lista_op.Getrow()

Return ll_row
end event

event constructor;Long ll_row

This.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
String ls_item, ls_ordenado_por, ls_comando
Long ll_fila
dwobject dwo_c

SetPointer(hourglass!)

IF TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo

		if is_data_type = 'char' THEN 
			ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		else
			ls_comando = is_col+ " = " + ls_item 
		end if
		
		ll_fila = tab_1.tabpage_2.dw_lista_op.find(ls_comando, 1, tab_1.tabpage_2.dw_lista_op.rowcount())
		
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			tab_1.tabpage_2.dw_lista_op.selectrow(0, false)
			tab_1.tabpage_2.dw_lista_op.selectrow(ll_fila,true)
			tab_1.tabpage_2.dw_lista_op.scrolltorow(ll_fila)
			/*Recupero Informacion de Operaciones*/	
			dwo_c = tab_1.tabpage_2.dw_lista_op.object.oper_sec
			tab_1.tabpage_2.dw_lista_op.Trigger Event Clicked(0,0,ll_fila,dwo)	
			//*//
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type dw_det_op from u_dw_abc within tabpage_2
integer x = 1234
integer width = 3022
integer height = 1004
integer taborder = 20
string dataobject = "d_abc_operacion_ot_ff"
boolean hscrollbar = false
boolean vscrollbar = false
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;Long   ll_row, ll_inicio, ll_count, ll_opcion, ll_nro_item
String ls_flag_estado, ls_flag_estado_ot, ls_oper_sec, ls_nro_parte, ls_ot_adm
String ls_flag_ctrl_aprt_ot
Decimal ld_cant_real


idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


IF dwo.name = 'b_abrir' THEN
	ll_row = idw_det_op.getrow()

	IF ll_row = 0 THEN RETURN
	
	//estado de la ot
	ls_flag_estado_ot = dw_master.object.flag_estado [dw_master.getrow()]

	IF ls_flag_estado_ot = '0' THEN  //ANULADO
		Messagebox('Aviso','Orden de Trabajo esta Anulada')
		RETURN
	ELSEIF ls_flag_estado_ot = '2' THEN// CERRADA
		ll_opcion = Messagebox('Orden de Trabajo cerrada', &
						'Desea continuar', &
						exclamation!, yesno!,2)
		
		IF ll_opcion = 2 THEN
			RETURN
		END IF
		dw_master.object.flag_estado[1]='1'
		
	END IF
		
	//estado de la operacion
	ls_flag_estado = idw_det_op.object.flag_estado [ll_row]
	ls_oper_sec		= idw_det_op.object.oper_sec    [ll_row]
	
	IF ls_flag_estado = '1' THEN
		Messagebox('Aviso','Operacion se Encuentra Activa ')
		RETURN
	ELSEIF ls_flag_estado = '3' THEN
		Messagebox('Aviso','Operacion se Encuentra Proyectada ')
		RETURN
	ELSEIF ls_flag_estado = '0' THEN
		Messagebox('Aviso','Operacion Ha Sido Anulada')
		RETURN
	END IF
	
	SELECT count(*) 
	  INTO :ll_count 
	  FROM pd_ot_det 
	 WHERE oper_sec = :ls_oper_sec 
	   AND flag_terminado='1' ;
	
	IF ll_count > 0 THEN 
		select min(nro_parte), nro_item 
		  into :ls_nro_parte, :ll_nro_item
		  from pd_ot_det 
       where oper_sec = :ls_oper_sec AND flag_terminado='1'
	 group by nro_parte, nro_item ;
	
		Messagebox('Corrija por parte diario', 'Operacion cerrada por parte diario '+ls_nro_parte + ', item ' + string(ll_nro_item))
		Return
	END IF
	
	IF idw_det_op.object.cant_real[ll_row] > 0 THEN
		idw_det_op.object.flag_estado [ll_row] = '1' //abrir operacion
	ELSE
		idw_det_op.object.flag_estado [ll_row] = '3' //proyectar operacion
	END IF
	
	ls_ot_adm = dw_master.object.ot_adm[dw_master.GetRow()]	//ABRIR ARTICULOS
	
	SELECT NVL(o.flag_ctrl_aprt_ot,1)
	  INTO :ls_flag_ctrl_aprt_ot
	  FROM ot_administracion o
	 WHERE ot_adm = :ls_ot_adm ;
	
	//ABRIR ARTICULOS, DEPENDIENDO DEL PARAMETRO DE CONTROL DEL OT ADM
	For ll_inicio = 1 TO idw_det_art.Rowcount()
		 IF ls_flag_ctrl_aprt_ot = '0' THEN
		 	idw_det_art.object.flag_estado [ll_inicio] = '1'
		 ELSE
			idw_det_art.object.flag_estado [ll_inicio] = '3'
		 END IF
	Next
	
	dw_master.ii_update = 1
	idw_det_art.ii_update = 1
	idw_det_op.ii_update = 1
	
ELSEIF dwo.name = 'b_cerrar' THEN
	
	ll_row = idw_det_op.getrow()

	IF ll_row = 0 THEN RETURN
	//estado de la ot
	ls_flag_estado_ot = dw_master.object.flag_estado [dw_master.getrow()]

	IF ls_flag_estado_ot = '0' THEN  //ANULADO
		Messagebox('Aviso','Orden de Trabajo esta Anulada')
		RETURN
	ELSEIF ls_flag_estado_ot = '2' THEN// CERRADA
		Messagebox('Aviso','Orden de Trabajo esta Cerrada')
		RETURN
	END IF	

	//estado de la operacion
	ld_cant_real = idw_det_op.object.cant_real [ll_row]
	IF ld_cant_real > 0 THEN
		MessageBox('Aviso','Operación tiene parte diario, verifique!')
		Return
	END IF
	
	ls_flag_estado = idw_det_op.object.flag_estado [ll_row]
	IF ls_flag_estado = '2' THEN
		Messagebox('Aviso','Operacion ya se Encuentra Cerrada ')
		RETURN
	ELSEIF ls_flag_estado = '0' THEN
		Messagebox('Aviso','Operacion Ha Sido Anulada')
		RETURN
	END IF
	
	idw_det_op.object.flag_estado [ll_row] = '2' //cerrar operacion
	
	//CERRAR ARTICULOS
	For ll_inicio = 1 TO idw_det_art.Rowcount()
		 idw_det_art.object.flag_estado [ll_inicio] = '2'
	Next	

	idw_det_op.ii_update  = 1
	idw_det_art.ii_update = 1
END IF
end event

event ue_insert_pre;call super::ue_insert_pre;Long   ll_nro_operacion 

IF This.Rowcount() > 1 THEN
	ll_nro_operacion = this.object.nro_operacion [al_row - 1] + 10
ELSE
	ll_nro_operacion = 10
END IF

// Asignando datos de dw_master
this.object.cod_maquina			[al_Row] = idw_det_ot.object.cod_maquina 	[idw_det_ot.getrow()] 
this.object.desc_maq				[al_row] = idw_det_ot.object.desc_maq	 	[idw_det_ot.getrow()] 
this.object.nro_operacion		[al_row] = ll_nro_operacion
this.object.tipo_orden			[al_row] = is_doc_ot
this.object.nro_orden			[al_row] = dw_master.object.nro_orden 		[idw_det_ot.getrow()] 
this.object.flag_estado			[al_row] = '3'
this.object.fec_inicio			[al_row] = date(gnvo_app.of_fecha_actual())
this.object.fec_inicio_est		[al_row] = date(gnvo_app.of_fecha_actual())
this.object.cant_proyect		[al_row] = 0.00
this.object.costo_unitario		[al_row] = 0.00
this.object.costo_proyect		[al_row] = 0.00
this.object.cencos				[al_row] = idw_det_ot.object.cencos_slc 			[idw_det_ot.getrow()] 
this.object.desc_cencos			[al_row] = idw_det_ot.object.desc_cencos_slc 	[idw_det_ot.getrow()] 
this.object.centro_benef		[al_row] = idw_det_ot.object.centro_benef 		[idw_det_ot.getrow()] 
this.object.desc_centro			[al_row] = idw_det_ot.object.desc_centro_benef 	[idw_det_ot.getrow()] 
this.object.cod_usr				[al_row] = gs_user

end event

event constructor;call super::constructor;is_mastdet = 'md'		  // 'm' = master sin detalle (default), 'd' =  detalle,
                    	  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'

ii_ck[1] = 1		     // columnas de lectrua de este dw
ii_dk[1] = 2          // columnas que se pasan al detalle

ib_delete_cascada = true

idw_det = dw_det_art   // dw_detail

end event

event itemchanged;call super::itemchanged;DataWindowChild ldwc_labor
String   ls_desc_labor, ls_und              , ls_filter, &
		   ls_ejecutor  , ls_cod_labor        , ls_codigo, &
			ls_tercero   , ls_flag_facturacion , ls_cliente, &
			ls_sub_cat, 	ls_cencos, ls_data,  &
			ls_flag_estado, ls_opersec, ls_cencos_ante, &
			ls_centro_benef, ls_cod_ejecutor, ls_cod_moneda
			
Datetime ldt_fec_inicio
Decimal  ldc_costo_unitario
Integer  li_registros, ll_i
Long		ll_count

this.accepttext()
SetNull(gnvo_app.is_null)

ls_opersec = trim(this.object.oper_sec [row])

CHOOSE CASE dwo.name
	CASE 'fec_inicio'
		
		//modifico si existe articulos a modificar
		ldt_fec_inicio = This.object.fec_inicio [row]
		wf_updt_art_finicio(ldt_fec_inicio)
		This.object.fec_inicio_est [row] = ldt_fec_inicio
		
	CASE 'cod_ejecutor'
		ls_cod_labor = This.object.cod_labor [row]

		SELECT le.cod_ejecutor, NVL(le.costo_unitario,0), le.cod_moneda
		  INTO :ls_cod_ejecutor, :ldc_costo_unitario, :ls_cod_moneda
		  FROM labor_ejecutor le,
				 ejecutor 		 e
		 WHERE le.cod_ejecutor 	= :data
			and le.cod_labor 		= :ls_cod_labor
			and le.flag_estado 	= '1'
			and e.flag_estado 	= '1';
		
		IF sqlca.SQLCode = 100 THEN
			SetNull(ls_codigo)
			Messagebox('AViso','Ejecutor no existe para esta Labor o no esa activo, por favor Verifique')
			This.object.cod_ejecutor 	[row] = gnvo_app.is_null
			This.object.costo_unit 		[row] = 0.00
			This.object.costo_proyect	[row] = 0.00
			This.object.cod_moneda 		[row] = gnvo_app.is_null
			This.object.cod_moneda_1	[row] = gnvo_app.is_null
			Return 1
		END IF

		This.object.cod_ejecutor 	[row] = ls_cod_ejecutor
		This.object.costo_unit 		[row] = ldc_costo_unitario
		This.object.cod_moneda 		[row] = ls_cod_moneda
		This.object.cod_moneda_1	[row] = ls_cod_moneda
		
		//Determinar si es facturable
		ls_cliente = dw_master.object.cliente [dw_master.getRow()]
	
		IF isnull(ls_cliente) then
			this.object.flag_facturacion[row] = 'N'
		ELSE
			// Asignando flag de facturacion
			IF IS_ACTION = 'new' THEN
				IF data <> is_ejec_tercero THEN
					this.object.flag_facturacion[row] = 'F'
				ELSE
					this.object.flag_facturacion[row] = 'N'
				END IF
			END IF
		END IF
		
	CASE 'cod_labor'
		ls_cod_labor = String(This.object.cod_labor [row])
	
		IF dw_det_art.rowcount() > 0 THEN
			This.object.cod_labor [row] = ls_cod_labor
			Messagebox('Aviso','No puede Cambiar Codigo de Labor tiene Articulo , Verifique!')
			RETURN 1	
		END IF
	
		SELECT desc_labor,und
			  INTO :ls_desc_labor,:ls_und
		  FROM labor 
		 WHERE (cod_labor =  :data )
			and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			messagebox('Aviso', 'Dato ingresado no existe o no esta activo')
			
			this.object.cod_labor      [row] = gnvo_app.is_null
			this.object.cod_ejecutor   [row] = gnvo_app.is_null
			this.object.desc_operacion [row] = gnvo_app.is_null
			This.object.und	   		[row] = gnvo_app.is_null
			This.object.und_1 			[row] = gnvo_app.is_null
			
			RETURN 1
		end if
		
		This.object.desc_operacion [row] = ls_desc_labor
		This.object.und	   		[row] = ls_und
		
		/*Recupero Ejecutor*/
		SELECT Count(*)
		  INTO :ll_count
		  FROM labor_ejecutor a,
				 ejecutor b
		 WHERE a.cod_ejecutor = b.cod_ejecutor
			and a.cod_labor 	 = :ls_cod_labor
			and a.flag_estado  = '1'
			and b.flag_estado  = '1';
		
		if ll_count = 0 then
			This.object.cod_ejecutor 	[row] = gnvo_app.is_null
			This.object.costo_unit 		[row] = 0.00
			This.object.cod_moneda 		[row] = gnvo_app.is_null
			This.object.cod_moneda_1	[row] = gnvo_app.is_null
			This.object.costo_proyect	[row] = 0.00
		end if
		
		SELECT le.cod_ejecutor, NVL(le.costo_unitario,0), le.cod_moneda
		  INTO :ls_cod_ejecutor, :ldc_costo_unitario, :ls_cod_moneda
		  FROM labor_ejecutor le,
				 ejecutor 		 e
		 WHERE le.cod_ejecutor 	= e.cod_ejecutor
			and le.cod_labor 		= :ls_cod_labor
			and le.flag_estado 	= '1'
			and e.flag_estado 	= '1';
		
		This.object.cod_ejecutor 	[row] = ls_cod_ejecutor
		This.object.costo_unit 		[row] = ldc_costo_unitario
		This.object.cod_moneda 		[row] = ls_cod_moneda
		This.object.cod_moneda_1	[row] = ls_cod_moneda
			
		// Asignando flag de facturacion
		//Determinar si es facturable
		ls_cliente = dw_master.object.cliente [dw_master.getRow()]
	
		IF isnull(ls_cliente) then
			this.object.flag_facturacion[row] = 'N'
		ELSE
			// Asignando flag de facturacion
			IF IS_ACTION = 'new' THEN
				IF data <> is_ejec_tercero THEN
					this.object.flag_facturacion[row] = 'F'
				ELSE
					this.object.flag_facturacion[row] = 'N'
				END IF
			END IF
		END IF
			
	CASE 'proveedor'
		SELECT nom_proveedor
		  INTO :ls_data
		  FROM proveedor
		 WHERE proveedor = :data 
		   and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso','Código de proveedor no esta activo o no existe, por favor Verifique!')
			This.object.proveedor 		[row] = gnvo_app.is_null
			This.object.nom_proveedor 	[row] = gnvo_app.is_null
			return 1
		end if

		This.object.nom_proveedor [row] = ls_data
		
	CASE 'servicio'
		ls_cod_labor = this.object.cod_labor [row]
		
		select sub_cat_serv_3ro
			into :ls_sub_cat 
		from labor 
		where cod_labor = :ls_cod_labor 
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso','Código de Labor no esta activo o no existe, Verifique!')
			this.object.servicio [row] = gnvo_app.is_null
			return 1
		end if
		
		if IsNull(ls_sub_cat) or ls_sub_cat = '' then
			Messagebox('Aviso','La Labor no tiene enlazado una subcategoria de servicios, por favor Verifique!')
			this.object.servicio [row] = gnvo_app.is_null
			return 1
		end if
	
		SELECT descripcion
		  INTO :ls_data
		  FROM servicios
		 WHERE servicio    = :data      
			and flag_estado = '1'        
			and cod_sub_cat = :ls_sub_cat;
	  
		
		IF SQLCA.sqlcode = 100 THEN
			Messagebox('Aviso','Código de Servicio: ' + data + ' No Existe, no esta activo o no pertenece a la subcategoria de servicios especificada en la labor ,Verifique!')
			this.object.servicio 		[row] = gnvo_app.is_null
			this.object.desc_servicio	[row] = gnvo_app.is_null
			Return 1
		END IF
		
		this.object.desc_servicio [row] = ls_data
	
	case "cencos"
	
		Select c.desc_cencos
		  into :ls_data
		  from centros_costo c
		 where c.cencos = :data
		   and flag_estado = '1';
		 
		IF sqlca.SQLCode = 100 THEN
			Messagebox('Aviso','Cencos no existe o no esta activo, por favor Verifique')
			This.object.cencos 		[row] = gnvo_app.is_null
			This.object.desc_cencos [row] = gnvo_app.is_null
			Return 1
		END IF
		
		 if dw_det_art.GetRow() > 0 then
	
			Select count(p.flag_estado)
			  into :ll_count
			  from articulo_mov_proy p
			 where p.flag_estado <> '3' 
				and p.oper_sec = :ls_opersec
				and p.tipo_doc = :gnvo_app.is_doc_ot;
				
			if ll_count = 0 then
				
				For ll_i = 1 to dw_det_art.RowCount()
					 dw_det_art.object.cencos      [ll_i] = data
					 dw_det_art.object.desc_cencos [ll_i] = ls_data
				Next
			else
				messagebox('Error', 'No puede cambiar el Cencos de la Operación ' + ls_opersec &
							+ " porque tiene " + string(ll_count) + " articulos ya atendidos o aprobados, por favor verifique")
	
				Return 1
			end if
			
		end if
	
	case "centro_benef"
	
		SELECT desc_centro
		 INTO :ls_data
		 FROM centro_beneficio a
		 WHERE a.flag_estado = '1' 
			and a.centro_benef = :data;
			 
		IF SQLCA.SQLCode = 100 THEN 
			Messagebox('Aviso','Centro de beneficio no existe o no esta activo, por favor Verifique')
			This.object.centro_benef 	[row] = gnvo_app.is_null
			This.object.desc_centro 	[row] = gnvo_app.is_null
			Return 1
		END IF
		
		this.object.desc_centro [row] = ls_data				
		
END CHOOSE
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)


end event

event ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;//idw_det.retrieve(aa_id[18])
end event

event rowfocuschanged;call super::rowfocuschanged;tab_1.tabpage_2.dw_lista_op.Setrow(currentrow)
tab_1.tabpage_2.dw_lista_op.ScrollToRow(currentrow)
end event

event ue_insert;//Ancestor Overriding
Integer li_ingreso

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

/// Controlando ingresos de registros de OTs con plantilla
li_ingreso = of_control_ingresos()
IF li_ingreso <> 1 THEN return -1

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row



end event

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_und, ls_cod_moneda, ls_ot_adm, ls_cod_labor, &
			ls_cod_ejecutor, ls_costo_unit, ls_opersec, ls_sub_cat, ls_cliente
Long		ll_count, ll_i
Decimal	ldc_costo_unitario
str_maquinas	lstr_maquina

choose case lower(as_columna)
	case "cod_labor"

		ls_ot_adm = dw_master.object.ot_adm[dw_master.getRow()]
		
		IF dw_det_art.rowcount() > 0 THEN
			Messagebox('Aviso','No puede Cambiar Codigo de Labor tiene Articulo , Verifique!')
			RETURN 
		END IF
		
		ls_sql = "SELECT COD_LABOR AS CODIGO, "&   
				 + "DESC_LABOR AS DESCRIPCION, "&
				 + "UND AS UNIDAD " &
				 + "FROM VW_OPE_LABOR_X_OT_ADM "&
				 + "WHERE OT_ADM = '" + ls_ot_adm + "'"	

		lb_ret = f_lista_3ret(ls_sql, ls_cod_labor, ls_data, ls_und, '2')

		if ls_cod_labor <> '' then
			this.object.cod_labor		[al_row] = ls_cod_labor
			this.object.desc_operacion	[al_row] = ls_data
			this.object.und				[al_row] = ls_und

			/*Recupero Ejecutor*/
			SELECT Count(*)
			  INTO :ll_count
			  FROM labor_ejecutor a,
					 ejecutor b
			 WHERE a.cod_ejecutor = b.cod_ejecutor
				and a.cod_labor = :ls_cod_labor
				and a.flag_estado = '1'
				and b.flag_estado = '1';
			
			IF ll_count > 0 THEN
				SELECT le.cod_ejecutor, NVL(le.costo_unitario,0), le.cod_moneda
				  INTO :ls_cod_ejecutor, :ldc_costo_unitario, :ls_cod_moneda
				  FROM labor_ejecutor le,
				  		 ejecutor 		 e
				 WHERE le.cod_ejecutor 	= e.cod_ejecutor
				   and le.cod_labor 		= :ls_cod_labor
				   and le.flag_estado 	= '1'
					and e.flag_estado 	= '1';
				
				This.object.cod_ejecutor 	[al_row] = ls_cod_ejecutor
				This.object.costo_unit 		[al_row] = ldc_costo_unitario
				This.object.cod_moneda 		[al_row] = ls_cod_moneda
				This.object.cod_moneda_1	[al_row] = ls_cod_moneda
					
				// Asignando flag de facturacion
				//Determinar si es facturable
				ls_cliente = dw_master.object.cliente [dw_master.getRow()]
			
				IF isnull(ls_cliente) then
					this.object.flag_facturacion[al_row] = 'N'
				ELSE
					// Asignando flag de facturacion
					IF IS_ACTION = 'new' THEN
						IF ls_cod_ejecutor <> is_ejec_tercero THEN
							this.object.flag_facturacion[al_row] = 'F'
						ELSE
							this.object.flag_facturacion[al_row] = 'N'
						END IF
					END IF
				END IF
		
			END IF
			
			this.ii_update = 1
		end if
		
		
	case "cod_ejecutor"
  		ls_cod_labor = this.object.cod_labor [al_row]
		  
		if ISNull(ls_cod_labor) or trim(ls_cod_labor) = '' then
			MessageBox('Error', 'No ha especificado un código de labor para esta operación, por favor verifique!', StopSign!)
			return 
		end if
		  
		ls_sql = "SELECT A.COD_EJECUTOR AS COD_EJECUTOR, "&
				 + "B.DESCRIPCION AS DESC_EJECUTOR " &
				 + "FROM LABOR_EJECUTOR A, " &
				 + "     EJECUTOR       B " &
				 + "WHERE A.COD_LABOR    = '"+ls_cod_labor+"' " &
				 + "  and A.cod_ejecutor = b.cod_ejecutor " &
				 + "  AND A.FLAG_ESTADO  = '1' " &
				 + "  AND B.FLAG_ESTADO  = '1' "
										  
				 
		f_lista(ls_sql, ls_cod_ejecutor, ls_data, '2')
		
		if trim(ls_cod_ejecutor) <> '' then
			SELECT NVL(le.costo_unitario,0), le.cod_moneda
			  INTO :ldc_costo_unitario, :ls_cod_moneda
			  FROM labor_ejecutor le,
					 ejecutor 		 e
			 WHERE le.cod_ejecutor 	= e.cod_ejecutor
				and le.cod_labor 		= :ls_cod_labor
				and le.cod_ejecutor	= :ls_cod_ejecutor;
			
			This.object.cod_ejecutor 	[al_row] = ls_cod_ejecutor
			This.object.costo_unit 		[al_row] = ldc_costo_unitario
			This.object.cod_moneda 		[al_row] = ls_cod_moneda
			This.object.cod_moneda_1	[al_row] = ls_cod_moneda
				
			// Asignando flag de facturacion
			//Determinar si es facturable
			ls_cliente = dw_master.object.cliente [dw_master.getRow()]
		
			IF isnull(ls_cliente) then
				this.object.flag_facturacion[al_row] = 'N'
			ELSE
				// Asignando flag de facturacion
				IF IS_ACTION = 'new' THEN
					IF ls_cod_ejecutor <> is_ejec_tercero THEN
						this.object.flag_facturacion[al_row] = 'F'
					ELSE
						this.object.flag_facturacion[al_row] = 'N'
					END IF
				END IF
			END IF
				
			this.ii_update = 1
		end if
		
	CASE 'cencos'
	
		if dw_det_art.GetRow() > 0 then
		
			Select count(amp.flag_estado)
			  into :ll_count
			  from articulo_mov_proy amp
			 where amp.flag_estado <> '3'
				and amp.oper_sec = :ls_opersec
				and amp.tipo_doc = :gnvo_app.is_doc_ot;
		 
			if ll_count > 0 then
				messagebox('Error', 'No puede cambiar el Cencos de la Operación ' + ls_opersec &
									+ " porque tiene " + string(ll_count) + " articulos ya atendidos o aprobados, por favor verifique")
				Return 
			end if
		else
			
			ll_count = 0
			
		end if

		if ll_count = 0 then
			
			ls_sql = "SELECT CENCOS AS codigo, "&   
					 + "DESC_CENCOS AS DESCripcion_CENCOS "&
					 + "FROM CENTROS_COSTO "&
					 + "WHERE FLAG_ESTADO = '1'"
			
			f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.cencos 		[al_row] = ls_codigo
				this.object.desc_cencos [al_row] = ls_data

				this.ii_update = 1
				
				For ll_i = 1 to dw_det_art.RowCount()
					 dw_det_art.object.cencos      [ll_i] = ls_codigo
					 dw_det_art.object.desc_cencos [ll_i] = ls_data
				Next

			END IF
		end if
			
			
	CASE 'servicio'
		//BUSCAR SUB CATEGORIA DE LABOR
		ls_cod_labor = this.object.cod_labor [al_row]
		
		
		select Nvl(sub_cat_serv_3ro,' ') 
		  into :ls_sub_cat 
		from labor 
		where cod_labor = :ls_cod_labor 
		  and flag_estado = '1';
		
		
		ls_sql = "SELECT SERVICIO AS CODIGO_servicio, " &
	 			 + "DESCRIPCION AS DESCRIPCION_servicio, " &
				 + "COD_SUB_CAT AS SUB_CATEGORIA " &
				 + "FROM SERVICIOS  S "&   
				 + "WHERE S.FLAG_ESTADO = '1' " &
				 + "  AND S.COD_SUB_CAT = '" + ls_sub_cat +"'"
		
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.servicio 		[al_row] = ls_codigo
			this.object.desc_servicio 	[al_row] = ls_data

			this.ii_update = 1
			
		END IF
		
	CASE 'centro_benef'
	
		ls_sql = "SELECT distinct a.CENTRO_BENEF AS centro_beneficio, "&
				 + "a.DESC_centro AS DESCRIPCION_centro "&
				 + "FROM centro_beneficio a " &
				 + "WHERE a.FLAG_ESTADO = '1' " &
				 + "and NVL(a.FLAG_ESTRUCTURA, '0') = '0' "		
		
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.object.desc_centro 	[al_row] = ls_data

			this.ii_update = 1
			
		END IF

	CASE	'cod_maquina'
		lstr_maquina = gnvo_app.of_get_maquina()
		
		if lstr_maquina.b_return then
			this.object.cod_maquina	[al_row] = lstr_maquina.cod_maquina
			this.object.desc_maq		[al_row] = lstr_maquina.desc_maquina
			this.ii_update = 1
		end if
		return		
end choose



end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

type dw_det_art from u_dw_abc within tabpage_2
integer x = 1234
integer y = 1020
integer width = 2418
integer height = 520
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_insumo_ot_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;Long     ll_nro_operac, ll_count
String   ls_cencos, ls_cencos_slc, ls_cod_dolar, ls_tipo_mov, ls_cod_origen, &
			ls_flag_estado, ls_ot_adm, ls_flag_ctrl_aprt_ot, ls_desc_cencos, ls_flag_urgencia
Datetime ldt_fec_inicio, ldt_fecha_actual


ls_cencos_slc  = dw_master.object.cencos_slc    [dw_master.Getrow()] //centro de costo solicitante
ls_cod_origen	= dw_master.object.cod_origen    [dw_master.Getrow()] //origen de ot
ls_ot_adm		= dw_master.object.ot_adm			[dw_master.Getrow()] //ot adm
ls_cencos      = dw_det_op.object.cencos		   [dw_det_op.Getrow()] //centros de costo
ls_flag_estado	= dw_det_op.object.flag_estado   [dw_det_op.Getrow()] //flag de estado de operacion
ldt_fec_inicio = dw_det_op.object.fec_inicio    [dw_det_op.Getrow()] //fecha der inicio de operaciones
ll_nro_operac  = dw_det_op.object.nro_operacion [dw_det_op.Getrow()] //nro de operacion

if ls_cencos = '' or isnull(ls_cencos) then
	
	messagebox('Operaciones OT', 'Debe de Ingresar Un Cencos en la Operación')
	Return

End If


// Asignacion de flag de estado, en funcion al tipo de control de ot_adm

select NVL(ota.flag_ctrl_aprt_ot,'1')
  into :ls_flag_ctrl_aprt_ot
  from ot_administracion ota
 where ota.ot_adm = :ls_ot_adm ;

// Si es tipo no control, estado para articulos '1'
IF ls_flag_ctrl_aprt_ot='0' THEN
	ls_flag_estado = '1'
ELSE
// Si no es directo, estado para articulos '3'
	ls_flag_estado = '3'
end if

/*Recuperacion de tipo de moneda $*/
SELECT cod_dolares, oper_cons_interno  
  INTO :ls_cod_dolar,:ls_tipo_mov  
  FROM logparam WHERE (reckey = '1');

ldt_fecha_actual = f_fecha_actual()

//DECODE(AMP.FLAG_MODIFICACION,1,'S',NULL)

	select desc_cencos
		into :ls_desc_cencos
		from centros_costo
	  where cencos = :ls_cencos
		 and flag_estado = '1';

// Flag de urgencia
SELECT count(*) 
  INTO :ll_count
  FROM estado_atencion_req e
 WHERE e.flag_estado='1' ;
 
 IF ll_count>0 THEN
	select a.flag_urgencia 
	  into :ls_flag_urgencia 
	  from (select e.flag_urgencia 
	          from estado_atencion_req e 
				where e.flag_estado='1' 
			order by e.dias_aprobacion desc) a
	where rownum=1 ;
	
	isnull(ls_flag_urgencia)
END IF
//// Asignando datos a dw_detail
This.SetItem( al_row, 'nro_operacion' ,ll_nro_operac    )
This.SetItem( al_row, 'cod_origen'    ,ls_cod_origen    )
This.SetItem( al_row, 'flag_estado'   ,ls_flag_estado   ) 
This.SetItem( al_row, 'cant_proyect'  , 0.0000          )
This.SetItem( al_row, 'cant_procesada', 0.0000          )
This.SetItem( al_row, 'cant_comprada' , 0.0000          )
This.SetItem( al_row, 'cant_reservado', 0.0000          )
This.SetItem( al_row, 'precio_unit'	  , 0.0001          )
This.SetItem( al_row, 'cencos'        , ls_cencos       )
This.SetItem( al_row, 'desc_cencos'   , ls_desc_cencos  )
This.SetItem( al_row, 'cod_moneda'	  , ls_cod_dolar    )
This.SetItem( al_row, 'tipo_mov'      , ls_tipo_mov     )
This.SetItem( al_row, 'fec_registro'  , ldt_fecha_actual)
This.SetItem( al_row, 'fec_proyect'   , ldt_fec_inicio  )
This.SetItem( al_row, 'flag_modificacion', '1' 			  )
This.SetItem( al_row, 'cod_usr'   	  , gs_user			  )
This.SetItem( al_row, 'flag_urgencia' , ls_flag_urgencia)
This.SetItem( al_row, 'estado'        , 'S'             ) //POR DEFECTO
This.SetItem( al_row, 'modifica'      , 'S'             ) //POR DEFECTO
This.SetItem( al_row, 'flag_cerrado'  , '1'             ) //POR DEFECTO
This.SetItem( al_row, 'flag_cnt_cmp'  , '1'             ) //POR DEFECTO
this.object.flag_urgencia [al_row] = 'N'	//Por defecto el flag de criticidad es baja

of_modify()

if is_flag_cnta_prsp = '1' then
	this.object.cnta_prsp.protect = 1
	this.object.cnta_prsp.background.color = RGB(192,192,192)
end if

this.SetColumn('cod_art')
end event

event clicked;call super::clicked;String ls_cod_origen, ls_flag_estado, ls_msj_err
Long ll_row, ll_nro_mov

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ll_row = this.getrow()

IF ll_row = 0 THEN RETURN

IF lower(dwo.name) = 'b_cerrar' THEN
	
	ls_flag_estado = this.object.flag_estado[ll_row]	
	
	if (ls_flag_estado = '1' or ls_flag_estado = '3') then
			
		if MessageBox('Aviso', 'Desea cerrar item', &
							 Exclamation!, OKCancel!, 2) = 2 then return
	
		this.object.flag_estado 	[row] = '2'
		this.object.fecha_aprob		[row] = gnvo_app.id_null
		this.object.nro_aprob		[row] = gnvo_app.is_null
		
		this.ii_update = 1
		
		/*
		ls_cod_origen 	= this.object.cod_origen[ll_row]	
		ls_flag_estado = this.object.flag_estado[ll_row]	
		ll_nro_mov 		= LONG(this.object.nro_mov[ll_row])
		
	
		IF ls_flag_estado='1' THEN
			DECLARE USP_OPE_CIERRE_AMP_OT PROCEDURE FOR 
					  USP_OPE_CIERRE_AMP_OT(:ls_cod_origen, 
													:ll_nro_mov, 
													:gs_user );
													
			EXECUTE USP_OPE_CIERRE_AMP_OT ;
			
			IF SQLCA.SQLCode = -1 THEN 
				ls_msj_err = SQLCA.SQLErrText
				Rollback ;
				Messagebox('Error',ls_msj_err)
				Return
			end if
			
			CLOSE USP_OPE_CIERRE_AMP_OT ;

		ELSEIF ls_flag_estado='3' THEN
			this.object.flag_estado[ll_row]	= '2'
			idw_det_art.ii_update = 1
		END IF
		
		*/
		
	end if
END IF

end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1	
ii_ck[2] = 2	
ii_rk[1] = 22

idw_mst  =  dw_det_op
idw_det  =  dw_det_art
end event

event itemchanged;call super::itemchanged;String ls_desc_art, ls_uni_art, ls_colname, ls_labor, &
		 ls_cnta_prsp, ls_desc, ls_null, ls_nro_orden, ls_cod_art

Long ll_count		 

DateTime ldt_fec_inicio_ope, ldt_fec_inicio_mat

this.acceptText()

ldt_fec_inicio_ope = dw_det_op.object.fec_inicio [dw_det_op.Getrow()] //fecha der inicio de operaciones
ldt_fec_inicio_mat = this.object.fec_proyect [row] //fecha proyectada del material


IF ldt_fec_inicio_mat < ldt_fec_inicio_ope then
	messagebox('Aviso','Fecha de material no puede ser menor que fecha de operación')
   THIS.object.fec_proyect [row] = ldt_fec_inicio_ope
	return 1
END IF

// Falta evaluar que fecha proyectada no puede ser menor que fecha proyectada aprobada, 
// siempre y cuando exista una aprobacion

ls_colname = dwo.name
SetNull(ls_null)

IF dwo.name = 'cod_art' then
	ls_labor = idw_det_op.object.cod_labor [idw_det_op.getrow()]
	
	if of_control_ingresos( ) = -1 then
		
		SELECT distinct a.desc_art, a.und, p3.CNTA_PRSP
			into :ls_desc_art, :ls_uni_art, :ls_cnta_prsp
	  FROM 	plant_prod  p1, 
	  			plant_prod_oper p2,
	  			plant_prod_mov  p3,
	  			prod_plant_lanz ppl,
	  			articulo a 
	  WHERE ppl.cod_plantilla = p1.cod_plantilla 
	  AND p1.cod_plantilla = p2.cod_plantilla 
	  AND p2.cod_plantilla = p3.cod_plantilla 
	  AND p2.nro_operacion = p3.nro_operacion 
	  and p3.cod_art = a.cod_art 
	  and p2.cod_labor 	= :ls_labor 
	  and ppl.nro_orden 	= :ls_nro_orden 
	  and p3.cod_art		= :data;
		
	else
		SELECT a.desc_art, a.und, l.cnta_prsp_insm
		  INTO :ls_desc_art, :ls_uni_art, :ls_cnta_prsp
		  FROM articulo a,
				 labor_insumo l
		 WHERE a.cod_art     = l.cod_art     
			AND a.flag_estado = '1'           
			AND l.cod_labor   = :ls_labor 
			AND a.cod_art	  = :data;
	end if
	
	IF SQLCA.SQLCode = 100 then
		Messagebox('Aviso','Verifique Codigo de Articulo')
		This.object.cod_art 	[row] = ls_null
		This.object.desc_art	[row] = ls_null
		This.object.und 		[row] = ls_null
		This.object.cnta_prsp[row] = ls_null
		Return 1
	end if
	
   THIS.object.desc_art	[row] = ls_desc_art
	THIS.object.und		[row] = ls_uni_art
	THIS.object.cnta_prsp[row] = ls_cnta_prsp
	
	of_set_articulo(data, dw_lista_op, this)
	
elseif dwo.name = 'cnta_prsp' then
	select descripcion
		into :ls_desc
	from presupuesto_cuenta
	where cnta_prsp = :data;
	
	IF SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Cuenta Presupuestal no existe')
		this.object.cnta_prsp [row] = ls_null
		return
	end if

elseif dwo.name = 'almacen' then
	
	ls_cod_art   = this.object.cod_art [row]
	
	select desc_almacen
		into :ls_desc
	from almacen
	where almacen = :data
	  and flag_estado = '1';
	
	IF SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'El codigo de almacen no existe o no esta activo')
		this.object.almacen [row] = ls_null
		return
	end if
	
	of_set_saldo_total(this.object.cod_art[this.GetRow()], data)

	of_set_articulo(ls_cod_art, dw_lista_op, this)

elseif dwo.name = 'flag_urgencia' then
	
	ls_cod_art   = this.object.flag_urgencia [row]
	
	select count(*) 
	  into :ll_count
	  from estado_atencion_req
	 where flag_urgencia = :data
	   and flag_estado = '1';
	
	IF ll_count = 0 then
		MessageBox('Aviso', 'El codigo de criticidad no existe o no esta activo')
		this.object.flag_urgencia [row] = ls_null
		return
	end if

END IF		


end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
//TriggerEvent ue_modify()
end event

event dberror;call super::dberror;
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
//	CASE 1                        // Llave Duplicada
//        Messagebox('Error PK: ' + this.ClassName(),'Llave Duplicada, Linea: ' + String(row))
//		  Return 1
	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        INTO :ls_name
        FROM ALL_CONSTRAINTS
       WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;
        Messagebox('Error FK: ' + this.ClassName(),'Registro Tiene Movimientos en Tabla: '+ls_name)
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
		//ls_msg += 'SQLDBCode: ' + String(SQLCA.SQLDBCode) + ls_crlf
		//ls_msg += 'SQLErrText: ' + SQLCA.SQLErrText + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		messagebox('dberror: ' + this.ClassName(), ls_msg, StopSign!)
END CHOOSE





end event

event ue_insert;//Ancestor Overriding
Integer li_ingreso
long ll_row

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF
//// Controlando ingresos en OTs con plantilla
li_ingreso = of_control_ingresos()

IF li_ingreso <> 1 THEN return -1 

//Hago la inserción normal
ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row

end event

event ue_display;call super::ue_display;string 	ls_codigo, ls_data, ls_sql, ls_estado, ls_modifica, ls_cod_art, ls_nro_orden, ls_Desc_art, &
			ls_und, ls_cnta_prsp, ls_labor, ls_mensaje
Long		ll_count			

ls_estado 	= this.Object.estado		[al_row]
ls_modifica = this.Object.modifica	[al_row]

choose case lower(as_columna)
	CASE 'cod_art'
		// No muestra ayuda, en caso no esta permitido modificar cod_art
		IF (isnull(ls_estado) OR isnull(ls_modifica)) THEN RETURN
	
		ls_labor = idw_det_op.object.cod_labor [idw_det_op.getrow()]
		if ls_labor = '' or IsNull(ls_labor) then
			gnvo_app.of_mensaje_error('Debe Indicar primeramente un codigo de labor en la operacion')
			idw_det_op.SetFocus( )
			idw_det_op.SetColumn( 'cod_labor' )
			return
		end if
		
		if of_control_ingresos( ) = -1 then
			ls_nro_orden 	= dw_master.object.nro_orden 	[dw_master.getrow()] 
			
			//Si esta amarrado a una plantilla solo debo mostrar los de esa plantilla nada mas
			ls_sql = "SELECT distinct a.cod_art as codigo_articulo, " &
					 + "a.desc_art as descripcion_articulo, "&
					 + "a.und as unidad, " &
					 + "p3.CNTA_PRSP as cuenta_prsp " &
					 + "FROM plant_prod  p1, " &
					 + "plant_prod_oper p2, "&
					 + "plant_prod_mov  p3, " &
					 + "prod_plant_lanz ppl, " &
					 + "articulo a " &
					 + "WHERE ppl.cod_plantilla = p1.cod_plantilla " &
					 + "AND p1.cod_plantilla = p2.cod_plantilla " &
					 + "AND p2.cod_plantilla = p3.cod_plantilla " &
					 + "AND p2.nro_operacion = p3.nro_operacion " &
					 + "and p3.cod_art = a.cod_art " &
					 + "and p2.cod_labor = '" + ls_labor + "'" &   
					 + "and ppl.nro_orden = '" + ls_nro_orden + "'"
			
		else
			ls_sql = "SELECT COD_ART AS CODIGO, "&   
					 + "DESC_ART AS DESCRIPCION, "&   
					 + "UND AS UNIDAD, "&   
					 + "CNTA_PRSP_INSM AS CUENTA_PRESUPUESTAL "&
					 + "FROM  VW_MTT_ART_X_LABOR "&
					 + "WHERE COD_LABOR = '" + ls_labor + "'"    
		end if
		
		f_lista_4ret(ls_sql, ls_cod_art, ls_desc_art, ls_und, ls_cnta_prsp, '2')

		if ls_cod_art <> '' then
			this.object.cod_art 			[al_row] = ls_Cod_art
			this.object.desc_art			[al_row] = ls_Desc_art
			this.object.und				[al_row] = ls_und
			this.object.cnta_prsp		[al_row] = ls_cnta_prsp
			this.ii_update = 1
			of_set_articulo(ls_cod_art, dw_lista_op, this)
		END IF

		
 	CASE 'cnta_prsp'
		// No muestra ayuda, en caso no esta permitido modificar cnta_prsp
		IF (isnull(ls_estado) OR isnull(ls_modifica)) THEN RETURN
		ls_sql = "SELECT CNTA_PRSP AS CNTA_PRSP, "&   
				 + "DESCRIPCION AS DESCRIPCION_CNTA_PRSP "&   
				 + "FROM  PRESUPUESTO_CUENTA " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cnta_prsp	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "flag_urgencia"
		ls_sql = "SELECT flag_urgencia AS codigo, "&   
				 + "descripcion AS desc_criticidad "&   
				 + "FROM  estado_atencion_req " &
				 + "where flag_estado = '1'"

		f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.flag_urgencia	[al_row] = ls_codigo
			this.object.desc_urgencia	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "almacen"
		// No muestra ayuda, en caso no esta permitido modificar almacen
		IF (isnull(ls_estado) OR isnull(ls_modifica)) THEN RETURN
		ls_cod_art = this.object.cod_art[al_row]
		
		if ISNull(ls_cod_art) or ls_cod_art = '' then
			gnvo_app.of_mensaje_error( "No ha especificado el código de artículo, por favor verifique!")
			this.SetColumn( "cod_art" )
			return
		end if
		
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
					  + "where cod_origen = '" + gs_origen + "' " &
					  + "and flag_estado = '1' " &
					  + "and flag_tipo_almacen <> 'O' " &
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
					  + "  and al.flag_tipo_almacen <> 'O' " &
					  + "order by al.almacen " 
		end if	
		
		

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.almacen		[al_row] = ls_codigo
			of_set_saldo_total(ls_cod_art, ls_codigo)
			this.ii_update = 1
		end if
		

end choose

//
//ls_name = dwo.name
//if this.Describe( lower(dwo.name) + ".Protect") = '1' then return
//
//
//
//CHOOSE CASE dwo.name
//		
//
//END CHOOSE
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

IF row = 0 THEN Return

THIS.AcceptText()

STR_CNS_POP lstr_1

choose case lower(dwo.name)
	case 'cant_comprada'

		
		lstr_1.DataObject = 'd_oc_x_requerimiento_articulo_tbl'
		lstr_1.Width = 3800
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_oc
		lstr_1.Arg[2] = this.object.cod_origen [row]
		lstr_1.Arg[3] = String(this.object.nro_mov[row])
		lstr_1.Title = 'OC Asociadas a este Requerimiento'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
		return

	case 'cant_reservado'

		lstr_1.DataObject = 'd_cns_reservacion_x_requerimiento_tbl'
		lstr_1.Width = 3800
		lstr_1.Height= 900
		lstr_1.Arg[1] = this.object.cod_origen [row]
		lstr_1.Arg[2] = String(this.object.nro_mov[row])
		lstr_1.Title = 'Reservaciones Asociadas a este Requerimiento'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)

	CASE "cant_procesada"
		lstr_1.DataObject = 'd_art_mov_amp_tbl'
		lstr_1.Width = 3000
		lstr_1.Height= 700
		lstr_1.Arg[1] = this.object.cod_origen[row]
		lstr_1.Arg[2] = String(this.object.nro_mov[row])
		lstr_1.Title = 'Retiros de Almacen asociados a este requerimiento'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)

end choose


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

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4361
integer height = 2440
long backcolor = 79741120
string text = "Ingresos al Almacen   "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "DisplayCurrentLibrary!"
long picturemaskcolor = 536870912
st_filtrar st_filtrar
dw_busqueda dw_busqueda
dw_oper_lista_ingreso dw_oper_lista_ingreso
dw_ingresos_ins_tbl dw_ingresos_ins_tbl
dw_oper_ingresos dw_oper_ingresos
pb_actualizar pb_actualizar
end type

on tabpage_3.create
this.st_filtrar=create st_filtrar
this.dw_busqueda=create dw_busqueda
this.dw_oper_lista_ingreso=create dw_oper_lista_ingreso
this.dw_ingresos_ins_tbl=create dw_ingresos_ins_tbl
this.dw_oper_ingresos=create dw_oper_ingresos
this.pb_actualizar=create pb_actualizar
this.Control[]={this.st_filtrar,&
this.dw_busqueda,&
this.dw_oper_lista_ingreso,&
this.dw_ingresos_ins_tbl,&
this.dw_oper_ingresos,&
this.pb_actualizar}
end on

on tabpage_3.destroy
destroy(this.st_filtrar)
destroy(this.dw_busqueda)
destroy(this.dw_oper_lista_ingreso)
destroy(this.dw_ingresos_ins_tbl)
destroy(this.dw_oper_ingresos)
destroy(this.pb_actualizar)
end on

type st_filtrar from statictext within tabpage_3
integer width = 1024
integer height = 116
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busca Por :"
boolean focusrectangle = false
end type

type dw_busqueda from datawindow within tabpage_3
integer y = 128
integer width = 1166
integer height = 88
integer taborder = 30
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_oper_lista_ingreso from u_dw_abc within tabpage_3
integer y = 228
integer width = 1179
integer height = 884
integer taborder = 20
string dataobject = "d_abc_ingresos_operaciones_ot_tbl"
end type

event constructor;call super::constructor;idw_det = tab_1.tabpage_3.dw_oper_ingresos

ii_ck[1] = 1		// columnas de lectrua de este dw
ii_dk[1] = 2     // columnas que se pasan al detalle

is_dwform = 'tabular'

ii_ss = 1

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


IF row = 0 Then Return

This.SelectRow(0, False)
This.SelectRow(row, True)
This.SetRow(row)

This.Event ue_output(row)
end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;String ls_oper_sec

ls_oper_sec = this.GetItemString(this.GetRow(),'oper_sec')

IF Isnull(ls_oper_sec) THEN
	tab_1.tabpage_3.dw_ingresos_ins_tbl.reset()
ELSE
	tab_1.tabpage_3.dw_ingresos_ins_tbl.retrieve(ls_oper_sec)
END IF 




end event

event doubleclicked;call super::doubleclicked;String  	ls_column , ls_report, ls_color,ls_data_type,ls_col_tipo
Long 		ll_row


ls_column = upper(dwo.name)

IF right(ls_column,2) = '_T' THEN
	is_col = UPPER( left(ls_column, len(ls_column) - 2))	
	ls_column = this.Describe(is_col + "_t.text")
	ls_col_tipo = is_col+'.coltype' 
	ls_data_type = this.Describe(ls_col_tipo)
	is_data_type = Mid(ls_data_type,1,pos(ls_data_type,'(') - 1)

	st_filtrar.text = "Buscar por :" + Trim(is_col)
	dw_busqueda.reset()
	dw_busqueda.InsertRow(0)
	dw_busqueda.SetFocus()
	This.SelectRow(0, False)
END IF

if row = 0 then
	IF is_dwform = 'tabular' THEN
		THIS.Event ue_column_sort()
	end if
end if
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)

tab_1.tabpage_3.dw_oper_ingresos.Setrow(currentrow)
tab_1.tabpage_3.dw_oper_ingresos.ScrollToRow(currentrow)
end event

type dw_ingresos_ins_tbl from u_dw_abc within tabpage_3
integer x = 1202
integer y = 724
integer width = 2423
integer height = 508
integer taborder = 20
string dataobject = "d_abc_insumo_ot_prod_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1			
ii_rk[1] = 22

idw_mst  =  tab_1.tabpage_3.dw_oper_ingresos
idw_det  =  tab_1.tabpage_3.dw_ingresos_ins_tbl
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String ls_cod_art, ls_desc_art,ls_und, ls_colname, ls_desc, ls_null
SetNull(ls_null)
		 
ls_colname = dwo.name

IF dwo.name = 'cod_art' then
	SELECT a.desc_art , a.und		
	  INTO :ls_desc_art, :ls_und
	  FROM articulo a
	 WHERE  a.flag_estado = '1'           
	 	AND a.cod_art	  = :data   ;
				
	IF SQLCA.SQLCode = 100 THEN
		Messagebox('Aviso','Verifique Codigo de Articulo')
		This.object.cod_art 		 [row] = ls_null
		This.object.desc_art		 [row] = ls_null
		This.object.und 			 [row] = ls_null
		Return 1
	END IF
   THIS.object.desc_art [row] = ls_desc_art
	THIS.object.und		[row] = ls_und
	
elseif dwo.name = 'almacen' then
	select desc_almacen
		into :ls_desc
	from almacen
	where almacen = :data
	  and flag_estado = '1';
	
	IF SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'El codigo de almacen no existe o no esta activo')
		this.object.almacen [row] = ls_null
		return
	end if
	
END IF
end event

event ue_insert_pre;call super::ue_insert_pre;Long     ll_nro_operac
String   ls_cencos_slc ,ls_tipo_mov,ls_cod_origen, ls_oper_sec
Datetime ldt_fec_inicio,ldt_fecha_actual


ls_cencos_slc  = dw_master.object.cencos_slc    		  		 [dw_master.Getrow()] //centro de costo solicitante
ls_cod_origen	= dw_master.object.cod_origen   			  		 [dw_master.Getrow()] //origen de ot
ldt_fec_inicio = idw_oper_lista_ingreso.object.fec_inicio    [idw_oper_lista_ingreso.Getrow()] //fecha der inicio de operaciones
ll_nro_operac  = idw_oper_lista_ingreso.object.nro_operacion [idw_oper_lista_ingreso.Getrow()] //nro de operacion
ls_oper_sec		= idw_oper_lista_ingreso.object.oper_sec 		 [idw_oper_lista_ingreso.GetRow()]


/*Recuperacion de tipo de moneda $*/
SELECT oper_ing_prod  
	INTO :ls_tipo_mov  
FROM logparam 
WHERE (reckey = '1');

ldt_fecha_actual = gnvo_app.of_fecha_actual()

//// Asignando datos a dw_detail
this.object.oper_sec			[al_row] = ls_oper_sec
this.object.nro_operacion	[al_row] = ll_nro_operac
this.object.cod_origen		[al_row] = ls_cod_origen
this.object.flag_estado		[al_row] = '1'
this.object.ratio_costo		[al_row] = 1.000000
this.object.cant_proyect	[al_row] = 0.000000
this.object.cant_procesada	[al_row] = 0.000000
this.object.cencos			[al_row] = ls_cencos_slc
this.object.cod_moneda		[al_row] = gnvo_app.is_dolares
this.object.tipo_mov			[al_row] = ls_tipo_mov
this.object.fec_registro	[al_row] = ldt_fecha_actual
this.object.fec_proyect		[al_row] = Date(ldt_fec_inicio)
this.object.estado			[al_row] = 'S'

this.SetColumn('cod_art')
end event

event ue_display;call super::ue_display;String 	ls_name,ls_prot, ls_labor, ls_nro_orden, ls_sql, ls_und, ls_cnta_prsp, ls_codigo, ls_data


CHOOSE CASE lower(as_columna)
	CASE 'cod_art'
	
		// No muestra ayuda, en caso no esta permitido modificar cod_art
		
		//IF (isnull(ls_estado) OR isnull(ls_modifica)) THEN RETURN
	
		ls_labor = idw_oper_ingresos.object.cod_labor [idw_oper_ingresos.getrow()]
		
		if ls_labor = '' or IsNull(ls_labor) then
			MessageBox('Aviso', 'Debe Indicar primeramente un codigo de labor en la operacion')
			idw_oper_ingresos.SetFocus( )
			idw_oper_ingresos.SetColumn( 'cod_labor' )
			return
		end if
		
		if of_control_ingresos( ) = -1 then
			ls_nro_orden 	= dw_master.object.nro_orden 	[dw_master.getrow()] 
			
			//Si esta amarrado a una plantilla solo debo mostrar los de esa plantilla nada mas
			ls_sql = "SELECT distinct a.cod_art as codigo_articulo, " &
					 + "a.desc_art as descripcion_articulo, "&
					 + "a.und as unidad, " &
					 + "p3.CNTA_PRSP as cuenta_prsp " &
					 + "FROM plant_prod  p1, " &
					 + "plant_prod_oper p2, "&
					 + "plant_prod_mov_ingreso  p3, " &
					 + "prod_plant_lanz ppl, " &
					 + "articulo a " &
					 + "WHERE ppl.cod_plantilla = p1.cod_plantilla " &
					 + "AND p1.cod_plantilla = p2.cod_plantilla " &
					 + "AND p2.cod_plantilla = p3.cod_plantilla " &
					 + "AND p2.nro_operacion = p3.nro_operacion " &
					 + "and p3.cod_art = a.cod_art " &
					 + "and p2.cod_labor = '" + ls_labor + "'" &   
					 + "and ppl.nro_orden = '" + ls_nro_orden + "'"
			
		else
			ls_sql = "select a.cod_art as codigo_Articulo, " &
					 + "       a.desc_art as descripcion_articulo, " &
					 + "       a.und as unidad, " &
					 + "       lp.cnta_prsp " &
					 + "from labor_produccion lp, " &
					 + "      articulo         a " &
					 + "where lp.cod_art      = a.cod_art " &
					 + "  and lp.COD_LABOR = '" + ls_labor + "'"    
		end if

		IF gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_und, '2') THEN
			
			this.object.cod_art 			[al_row] = ls_codigo
			this.object.desc_art			[al_row] = ls_data
			this.object.und				[al_row] = ls_und
			this.object.cnta_prsp		[al_row] = ls_cnta_prsp
			this.ii_update = 1
			of_set_articulo(ls_codigo, dw_oper_lista_ingreso, this)
		END IF
		
	CASE 'cnta_prsp'
		
		ls_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CNTA_PRSP, '&   
				 + 'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION '&   
				 + 'FROM  PRESUPUESTO_CUENTA '
	
		IF gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') THEN
			
			this.object.cnta_prsp [al_row] = ls_codigo
	
			this.ii_update = 1
		END IF
		
 	CASE 'almacen'
		
		ls_sql = "SELECT almacen AS codigo_almacen, "&   
				 + "desc_almacen AS DESCripcion_almacen "&   
				 + "FROM  almacen " &
				 + "where flag_estado = '1'"

		IF gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') THEN
			this.object.almacen [al_row] = ls_codigo
			this.ii_update = 1
		END IF
		
END CHOOSE


end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

type dw_oper_ingresos from u_dw_abc within tabpage_3
integer x = 1202
integer y = 8
integer width = 2423
integer height = 704
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_operaciones_ff_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;
is_mastdet = 'md'		  // 'm' = master sin detalle (default), 'd' =  detalle,
                    	  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
							   
ii_ck[1] = 21		     // columnas de lectrua de este dw
ii_dk[1] = 21          // columnas que se pasan al detalle

idw_det = tab_1.tabpage_3.dw_ingresos_ins_tbl   // dw_detail

end event

event clicked;call super::clicked;
idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type pb_actualizar from picturebutton within tabpage_3
integer x = 1019
integer y = 8
integer width = 142
integer height = 116
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\Toolbar\actualiza.png"
string disabledname = "C:\SIGRE\resources\Toolbar\actualiza.png"
alignment htextalign = left!
boolean map3dcolors = true
end type

event clicked;wf_retrieve_operaciones_ing()
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4361
integer height = 2440
long backcolor = 79741120
string text = "Costo de Orden de Trabajo"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Library!"
long picturemaskcolor = 536870912
dw_ot_distribucion dw_ot_distribucion
end type

on tabpage_5.create
this.dw_ot_distribucion=create dw_ot_distribucion
this.Control[]={this.dw_ot_distribucion}
end on

on tabpage_5.destroy
destroy(this.dw_ot_distribucion)
end on

type dw_ot_distribucion from u_dw_abc within tabpage_5
integer width = 1851
integer height = 1264
integer taborder = 20
string dataobject = "d_abc_distribucion_costo_tbl"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = dw_master
idw_det  = tab_1.tabpage_5.dw_ot_distribucion



end event

event ue_insert_pre;call super::ue_insert_pre;Long 	  ll_row
Integer li_item

ll_row = This.RowCount()

IF ll_row = 1 THEN 
	li_item = 0
ELSE
	li_item = Getitemnumber(ll_row - 1,'item')
END IF
   
	
This.object.item		[al_row] = li_item + 1
this.object.cod_usr 	[al_row] = gs_user


end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_codigo

CHOOSE CASE dwo.name
							
	CASE 'nro_ot_cargo'
		SELECT Count(*)
		  INTO :ll_count
		  FROM orden_Trabajo 
		 WHERE nro_orden   = :data 
		 	AND flag_estado = '1';
					
	  IF ll_count = 0  THEN
		  SetNull(ls_codigo)
		  This.object.nro_ot_cargo [row] = ls_codigo
		  RETURN 1
	  END IF
								
END CHOOSE

end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name, ls_prot, ls_flag_estado
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
	CASE 'nro_ot_cargo'
		ls_flag_estado='1'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT NRO_ORDEN AS NUMERO_ORDEN, "&
				      				+"TITULO AS TITULO, "&
				      				+"OT_ADM AS OT_ADM "&
							 		   +"FROM ORDEN_TRABAJO " &
										+"WHERE FLAG_ESTADO = "+"'"+ls_flag_estado+"'"
										  
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'nro_ot_cargo',lstr_seleccionar.param1[1])
			ii_update = 1
		END IF

END CHOOSE
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4361
integer height = 2440
long backcolor = 79741120
string text = "Otros gastos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ComputeSum!"
long picturemaskcolor = 536870912
dw_otros_gastos dw_otros_gastos
end type

on tabpage_4.create
this.dw_otros_gastos=create dw_otros_gastos
this.Control[]={this.dw_otros_gastos}
end on

on tabpage_4.destroy
destroy(this.dw_otros_gastos)
end on

type dw_otros_gastos from u_dw_abc within tabpage_4
integer width = 3067
integer height = 1204
integer taborder = 20
string dataobject = "d_ot_otros_gastos_tbl"
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;String	ls_nro_orden

IF dw_master.GetRow() > 0 THEN
	ls_nro_orden = dw_master.object.nro_orden[1]
	this.object.nro_orden	[al_row] = ls_nro_orden
	this.object.cod_dolares	[al_row] = is_dolares
ELSE
	messagebox('Aviso','Ingreso no permitido')
	return
END IF

end event

event doubleclicked;call super::doubleclicked;IF row < 1 then return

String ls_name, ls_prot, ls_inactivo, ls_codrel
Datawindow ldw
str_seleccionar lstr_seleccionar
dwobject   dwo1

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")
ls_inactivo = '0'

if ls_prot = '1' then return

CHOOSE CASE dwo.name
	CASE 'cod_relacion'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT vw_ope_codrel_cnta_pagar.cod_relacion AS CODIGO,'&
										+'vw_ope_codrel_cnta_pagar.nom_proveedor AS NOMBRE,'&
										+'vw_ope_codrel_cnta_pagar.ruc AS ruc '&
										+'FROM vw_ope_codrel_cnta_pagar '
	CASE 'tipo_doc'
		ls_codrel = this.object.cod_relacion[row]
		lstr_seleccionar.s_seleccion = 'S'
		
		lstr_seleccionar.s_sql = 'SELECT cntas_pagar.cod_relacion as codrel,'&
										+'cntas_pagar.tipo_doc AS tipo_doc,'&
										+'cntas_pagar.nro_doc AS nro_doc, '&
										+'cntas_pagar.cod_moneda AS moneda, '&
										+'cntas_pagar.importe_doc AS importe, '&
										+'cntas_pagar.tasa_cambio AS tasa_cambio '&
										+'FROM cntas_pagar ' &
										+'WHERE cntas_pagar.cod_relacion = '+"'"+ls_codrel+"'"
END CHOOSE			

IF lstr_seleccionar.s_seleccion = 'S' THEN
	OpenWithParm(w_seleccionar,lstr_seleccionar)	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
	IF lstr_seleccionar.s_action = "aceptar" THEN
		CHOOSE CASE dwo.name		
				 CASE	'cod_relacion'
						Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
						Setitem(row,'nom_proveedor',lstr_seleccionar.param2[1])
						this.ii_update = 1
 				 CASE	'tipo_doc'
						Setitem(row,'tipo_doc',lstr_seleccionar.param2[1])
						Setitem(row,'nro_doc',lstr_seleccionar.param3[1])
						Setitem(row,'cod_moneda',lstr_seleccionar.param4[1])
						Setitem(row,'importe_doc',lstr_seleccionar.paramdc5[1])
						Setitem(row,'tasa_cambio',lstr_seleccionar.paramdc6[1])
						
						this.ii_update = 1

		END CHOOSE			
	END IF
END IF

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
//is_tabla = 'CLIENTES'						// nombre de tabla para el Log

end event

event itemchanged;call super::itemchanged;IF row < 1 then return
String ls_codrel, ls_tipo_doc, ls_nro_doc, ls_desc, ls_null, ls_moneda
Long ll_count
Decimal ldc_tasa_cambio, ldc_importe_doc

SetNull(ls_null)

this.accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_relacion'
	
		SELECT nom_proveedor
		  INTO :ls_desc
		  FROM proveedor 
		 WHERE proveedor = :data
		   and flag_estado = '1';
		
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'Código de relación no existe o no esta activo')
			this.object.cod_relacion [row] = ls_null
			this.object.nom_proveedor[row] = ls_desc
			return 1
		END IF
		
		this.object.nom_proveedor [row] = ls_desc
		
	CASE 'tipo_doc'
	
		SELECT count(*) 
		  INTO :ll_count
		  FROM doc_tipo 
		 WHERE tipo_doc = :data;
	
		IF ll_count = 0 THEN
			MessageBox('Aviso', 'Tipo de documento no existe')
			this.object.tipo_doc [row] = ls_null
			return 1
		END IF
		
	CASE 'nro_doc'
		ls_codrel   = This.object.cod_relacion[row]
		ls_tipo_doc = This.object.tipo_doc[row]
		ls_nro_doc  = This.object.nro_doc[row]
	
		SELECT tasa_cambio, importe_doc, cod_moneda
		  INTO :ldc_tasa_cambio, :ldc_importe_doc, :ls_moneda
		  FROM cntas_pagar 
		 WHERE cod_relacion = :ls_codrel AND
				 tipo_doc		 = :ls_tipo_doc AND
				 nro_doc		 = :ls_nro_doc ;
	
		IF sQLCA.sqlcode= 100 THEN
			MessageBox('Aviso', 'Documento no existe en cuentas por pagar')
			SetNull(ldc_tasa_cambio)
			
			this.object.nro_doc 		[row] = ls_null
			this.object.cod_moneda	[row] = ls_null
			this.object.importe_doc	[row] = ldc_tasa_cambio
			this.object.tasa_cambio	[row] = ldc_tasa_cambio
			return
		END IF

		this.object.cod_moneda	[row] = ls_moneda
		this.object.importe_doc	[row] = ldc_importe_doc
		this.object.tasa_cambio	[row] = ldc_tasa_cambio
				
END CHOOSE			

end event

type tabpage_6 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 4361
integer height = 2440
long backcolor = 79741120
string text = "ASignación de Recetas / Plantillas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "AddWatch!"
long picturemaskcolor = 536870912
dw_plantilla dw_plantilla
dw_lanza_plant dw_lanza_plant
gb_1 gb_1
st_3 st_3
em_factor em_factor
end type

on tabpage_6.create
this.dw_plantilla=create dw_plantilla
this.dw_lanza_plant=create dw_lanza_plant
this.gb_1=create gb_1
this.st_3=create st_3
this.em_factor=create em_factor
this.Control[]={this.dw_plantilla,&
this.dw_lanza_plant,&
this.gb_1,&
this.st_3,&
this.em_factor}
end on

on tabpage_6.destroy
destroy(this.dw_plantilla)
destroy(this.dw_lanza_plant)
destroy(this.gb_1)
destroy(this.st_3)
destroy(this.em_factor)
end on

type dw_plantilla from datawindow within tabpage_6
integer y = 4
integer width = 2290
integer height = 1028
integer taborder = 50
string dragicon = "H:\Source\ICO\row2.ico"
boolean bringtotop = true
string dataobject = "d_plant_prod_help_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;If row = 0 then Return

This.SelectRow(0, False)
This.SelectRow(row, True)
THIS.Drag(Begin!)
is_plantilla = this.object.data.primary.current[row, 1]  // determinar llave para leer dws
end event

event dragdrop;Long 	  ll_row_lanz,ll_row_master,ll_nro_lanz
Integer li_confirma
String  ls_nro_orden,ls_flag_estado,ls_cod_origen,ls_plantilla,ls_msj_err
dwobject dwo_op

IF source <> dw_lanza_plant THEN
	Drag(End!)
	RETURN
END IF

//valida si existe operaciones nuevas o modificaciones
IF wf_check_save_oper() THEN 
	Messagebox('Mensaje al Usuario','Por Favor antes de Generar Operaciones Con la Plantilla ,Grabar')
	RETURN
END IF

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN

ls_flag_estado = dw_master.object.flag_estado [ll_row_master]
ls_cod_origen	= dw_master.object.cod_origen  [ll_row_master]
ls_nro_orden   = dw_master.object.nro_orden   [ll_row_master]



IF Not(ls_flag_estado = '1' OR ls_flag_estado = '3') THEN
	Messagebox('Aviso','No se puede Eliminar Plantilla por estado de la OT')
	Return
END IF
	//Cargo a variable local plantilla y orden de trabajo
	ll_row_lanz = dw_lanza_plant.Getrow()
	
	IF ll_row_lanz = 0 THEN 
		Messagebox('Aviso','Debe Seleccionar Plantilla a Eliminar ,Verifique!')
		RETURN
	END IF
	
   //datos de la plantilla
	ls_plantilla = dw_lanza_plant.object.cod_plantilla   [ll_row_lanz]
	ll_nro_lanz  = dw_lanza_plant.object.nro_lanzamiento [ll_row_lanz]
	

	IF ISNULL(ls_plantilla) OR Trim(ls_plantilla) = '' THEN
		Messagebox('Error','Nº de plantilla no ha sido Seleccionado')
		RETURN
	END IF
	IF Isnull(ll_nro_lanz) THEN
		Messagebox('Error','Nº de lanzamiento no ha sido Seleccionado')
		RETURN
	END IF	

	// drag source es de la ventana de plantillas
	li_confirma = Messagebox("Eliminación de Plantillas", "Usted ha seleccionado lo siguiente:~r~n"+"~r~n"+&
	                                    "Nº orden de trabajo: "+ls_nro_orden+"~r~n"+"~r~n"+&
											      "Plantilla Número   : "+ls_plantilla+"~r~n"+"~r~n"+&
													"Nº de lanzamiento  : "+String(ll_nro_lanz)+"~r~n",Exclamation!, OkCancel!) 
													
	IF li_confirma <> 1 THEN  RETURN //VERIFICA ACEPTACION
	
		
	   DECLARE PB_USP_DEL_PLANT_OPERACION PROCEDURE FOR USP_DEL_PLANT_OPERACION(  
	          :ls_plantilla,:ls_nro_orden,:ll_nro_lanz) ;
		EXECUTE PB_USP_DEL_PLANT_OPERACION;	
		
	

		IF SQLCA.sqlcode = -1 THEN
			ls_msj_err = SQLCA.SQLErrText
			ROLLBACK ;
			Messagebox('Error','Copia no se ha realizado Satisfactoriamente '+ ls_msj_err)
			Return
		END IF
		
		CLOSE PB_USP_DEL_PLANT_OPERACION ;
		
		
      tab_1.tabpage_2.dw_lista_op.Retrieve(ls_nro_orden)
		dw_lanza_plant.retrieve(ls_nro_orden)
		//cliked en operaciones para recuperar articulo
		/*Cursor*/	
		dwo_op = tab_1.tabpage_2.dw_lista_op.object.oper_sec
		
		IF tab_1.tabpage_2.dw_lista_op.Rowcount() > 0 THEN
			tab_1.tabpage_2.dw_lista_op.Trigger Event Clicked(0,0,1,dwo_op)	
			tab_1.tabpage_2.dw_lista_op.Scrolltorow(1)
		END IF
		
		

end event

type dw_lanza_plant from datawindow within tabpage_6
integer x = 2309
integer width = 1070
integer height = 1028
integer taborder = 40
string dragicon = "H:\Source\ICO\row2.ico"
boolean bringtotop = true
string dataobject = "d_prod_plant_lanz_ot_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Decimal 	ld_factor 

If row = 0 then Return
This.SelectRow(0, False)
This.SelectRow(row, True)
THIS.Drag(Begin!)

ld_factor = this.object.factor[this.GetRow()]

em_factor.text = String(ld_factor)
end event

event dragdrop;String  ls_cencos_slc  ,ls_flag_estado  ,ls_nro_orden ,ls_origen  ,&
		  ls_msj_err	  ,ls_tipo		    ,ls_cadena	 , ls_centro_benef
Long 	  ll_nro_oper
Date	  ld_fec_inicio
Integer li_confirma
Decimal ldc_factor

IF source <> idw_plantilla THEN
	Drag(End!)
	RETURN
END IF

dw_master.Accepttext()

//Cargo a variable local numero de orden de trabajo
IF dw_master.RowCount() = 0 THEN RETURN 

ls_origen		 = dw_master.object.cod_origen  		[1]
ls_nro_orden    = dw_master.object.nro_orden	 		[1]
ls_cencos_slc	 = dw_master.Object.cencos_slc  		[1]
ls_centro_benef = dw_master.Object.centro_benef 	[1]
ls_flag_estado  = dw_master.object.flag_estado 		[1]

//FECHA DE INICIO DE OPERACIONES
ld_fec_inicio 	 = Date(dw_master.object.fec_inicio [1])
ldc_factor		 = Dec(em_factor.text)


IF Not (ls_flag_estado = '1' OR ls_flag_estado = '3' ) THEN   
	Messagebox('Aviso','No se Puede Insertar Plantilla por estado de la orden de Trabajo')
	Return	
END IF	

// valida correlativo de corte 
IF Isnull(ls_nro_orden) OR Trim(ls_nro_orden) = '' THEN
	Messagebox('Aviso','Genere Orden de trabajo')
	RETURN 
END IF	
	
//valida si existe operaciones nuevas o modificaciones
IF wf_check_save_oper() = TRUE THEN 
	Messagebox('Aviso','Grabe antes de generar operaciones de Plantilla')
	RETURN
END IF
	
// valida numero de plantilla
IF Isnull(is_plantilla) OR Trim(is_plantilla) = '' THEN
	Messagebox('Mensaje al Usuario','Seleccione Nº de plantilla')
	RETURN
END IF	
	
// valida centro de Costo 
IF Isnull(ls_cencos_slc) OR Trim(ls_cencos_slc) = '' THEN
	Messagebox('Mensaje al Usuario','Ingrese Centro de Costo Solicitante')
	RETURN
END IF	

// valida centro de beneficio
IF Isnull(ls_centro_benef) OR Trim(ls_centro_benef) = '' THEN
	Messagebox('Mensaje al Usuario','Ingrese Centro de Beneficio')
	RETURN
END IF	

// valida fecha de inicio de operacion
IF Isnull(ld_fec_inicio)  OR Trim(String(ld_fec_inicio,'ddmmyyyy')) = '00000000'THEN
	Messagebox('Mensaje al Usuario','Seleccione Fecha de inicio de Operación')
	RETURN
END IF	

li_confirma = Messagebox("Mensaje", "Usted ha seleccionado lo siguiente:"+&
												"~r~nFecha de Inicio  : "+String(ld_fec_inicio) + &
												"~r~nPlantilla Número : " + is_plantilla + &
												"~r~Orden de Trabajo  : " + ls_nro_orden + &
												"~r~nCentro de Costo  : " + ls_cencos_slc + &
												"~r~nFactor           : " + string(ldc_factor, '###,##0.00') + &
												"~r~n¿Desea procesar con los datos existentes?? ",Exclamation!, YesNo!) 
												
IF li_confirma <> 1 THEN  RETURN //no desea generar operaciones

//create or replace procedure usp_mtt_copiar_plant_oper_ot(
//       asi_cod_plantilla in plant_prod.cod_plantilla%type    ,
//       asi_nro_orden     in operaciones.nro_orden%type       ,
//       adi_fecha_inicio  in operaciones.fec_inicio%type      ,
//       asi_cod_origen    in origen.cod_origen%type           ,
//       ani_factor        in number                           ,
//       asi_cod_usr       in usuario.cod_usr%TYPE   
//) as

DECLARE USP_MTT_COPIAR_PLANT_OPER_OT PROCEDURE FOR 
	USP_MTT_COPIAR_PLANT_OPER_OT( :is_plantilla	,
											:ls_nro_orden  ,
											:ld_fec_inicio ,
											:ls_origen		,
											:ldc_factor 	 ,
											:gs_user);
											
EXECUTE USP_MTT_COPIAR_PLANT_OPER_OT ;	

IF SQLCA.sqlcode = -1 THEN
	ls_msj_err =  SQLCA.SQLErrText
	Rollback ;
	Messagebox('Aviso','Error en Store Procedure USP_MTT_COPIAR_PLANT_OPER_OT: ' &
				+ ls_msj_err, StopSign!)
	Return
END IF	

CLOSE USP_MTT_COPIAR_PLANT_OPER_OT;
		
//*datos de reprogramacion*//
//////////////////////////////////////////////////////////////////////
//RECUPERO OPERACIONES
idw_lista_op.retrieve(ls_nro_orden)
if idw_lista_op.RowCount() >0 then
	idw_lista_op.Event ue_output(1)
end if

IF idw_det_op.Rowcount() > 0 THEN
	ll_nro_oper   = idw_det_op.Object.nro_operacion 	  [1]
	ld_fec_inicio = Date(idw_det_op.Object.fec_inicio    [1])
	//ll_dias_dur   = idw_det_op.Object.dias_duracion_proy [1]
	ls_tipo		  = 'P'
END IF
	
DECLARE USP_CAM_REP_OPER_PRECEDENTE PROCEDURE FOR 
		USP_CAM_REP_OPER_PRECEDENTE( :ls_nro_orden,
											  :ll_nro_oper,
											  :ld_fec_inicio,
											  0,
											  :ls_tipo);
EXECUTE USP_CAM_REP_OPER_PRECEDENTE ;

IF SQLCA.sqlcode = - 1 THEN
	ls_msj_err = Sqlca.SQLerrtext	
	ROLLBACK ;
	Messagebox('Aviso','Error en Store Procedure USP_CAM_REP_OPER_PRECEDENTE: ' &
			+ ls_msj_err)
	RETURN
END IF

FETCH USP_CAM_REP_OPER_PRECEDENTE INTO :ls_cadena ;
CLOSE USP_CAM_REP_OPER_PRECEDENTE ;


//Recuperando datos para los lanzamientos
idw_lanza_plant.Retrieve(ls_nro_orden)

MessageBox('Aviso', 'Proceso realizado satisfactoriamente')
end event

type gb_1 from groupbox within tabpage_6
integer x = 3410
integer y = 4
integer width = 919
integer height = 248
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos para Generación"
end type

type st_3 from statictext within tabpage_6
integer x = 3497
integer y = 100
integer width = 265
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Factor :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_factor from editmask within tabpage_6
integer x = 3813
integer y = 104
integer width = 311
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###.000"
string displaydata = "1~t1/"
end type

type dw_rpt from datawindow within w_ope302_orden_trabajo
boolean visible = false
integer x = 251
integer y = 560
integer width = 2437
integer height = 1188
integer taborder = 80
boolean titlebar = true
string title = "Presupuesto x OT"
string dataobject = "d_rpt_pto_ot_tbl"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;SettransObject(sqlca)
end event

type gb_2 from groupbox within w_ope302_orden_trabajo
integer x = 3031
integer width = 1147
integer height = 192
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda de OT"
end type

