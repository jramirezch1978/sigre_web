$PBExportHeader$w_ope313_orden_trabajo_simplif.srw
forward
global type w_ope313_orden_trabajo_simplif from w_abc
end type
type st_2 from statictext within w_ope313_orden_trabajo_simplif
end type
type st_1 from statictext within w_ope313_orden_trabajo_simplif
end type
type pb_1 from picturebutton within w_ope313_orden_trabajo_simplif
end type
type tab_1 from tab within w_ope313_orden_trabajo_simplif
end type
type tabpage_1 from userobject within tab_1
end type
type dw_operaciones from u_dw_abc within tabpage_1
end type
type dw_articulos from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_operaciones dw_operaciones
dw_articulos dw_articulos
end type
type tab_1 from tab within w_ope313_orden_trabajo_simplif
tabpage_1 tabpage_1
end type
type cb_genera from commandbutton within w_ope313_orden_trabajo_simplif
end type
type dw_master from u_dw_abc within w_ope313_orden_trabajo_simplif
end type
end forward

global type w_ope313_orden_trabajo_simplif from w_abc
integer width = 3899
integer height = 2236
string title = "Orden de Trabajo Simplificada (OPE313)"
string menuname = "m_master_lista_anular"
event ue_anular ( )
event ue_print_rango ( )
st_2 st_2
st_1 st_1
pb_1 pb_1
tab_1 tab_1
cb_genera cb_genera
dw_master dw_master
end type
global w_ope313_orden_trabajo_simplif w_ope313_orden_trabajo_simplif

type variables
String is_doc_ot,is_accion
end variables

forward prototypes
public subroutine wf_art_x_labor (string as_cod_labor)
public subroutine wf_updt_art_finicio (datetime adt_fec_inicio)
public function boolean of_set_articulo (string as_cod_art)
public function boolean of_set_saldo_total (string as_cod_art, string as_almacen)
public subroutine of_modify_art ()
end prototypes

public subroutine wf_art_x_labor (string as_cod_labor);//String ls_cod_art,ls_nom_articulo,ls_und
//Long   ll_row,ll_count
//
//
//SELECT Count(*)
//  INTO :ll_count
//  FROM labor_insumo lb ,articulo art
// WHERE (lb.cod_art = art.cod_art  ) AND
//		 (cod_labor  = :as_cod_labor) ;
//
///*Declaración de Cursor*/
//DECLARE Mat_labor CURSOR FOR
//		  SELECT lb.cod_art,art.nom_articulo,art.und
//		  	 FROM labor_insumo lb ,articulo art
//			WHERE (lb.cod_art = art.cod_art  ) AND
//			      (cod_labor  = :as_cod_labor) ;
//
//
///*Abrir Cursor*/		  	
//OPEN Mat_labor ;
//	
//DO 				/*Recorro Cursor*/	
//FETCH Mat_labor INTO :ls_cod_art,:ls_nom_articulo,:ls_und ;
//IF sqlca.sqlcode = 100 THEN EXIT
///**Inserción de Registros**/ 
//	 idw_det_art.TriggerEvent('ue_insert')
//	 ll_row = idw_det_art.il_row
//	 idw_det_art.object.cod_art      [ll_row] = ls_cod_art
//	 idw_det_art.object.nom_articulo [ll_row] = ls_nom_articulo
//	 idw_det_art.object.und          [ll_row] = ls_und
//	 idw_det_art.object.cant_proyect [ll_row] = 1.00
//
//	 
//LOOP WHILE TRUE
//	
//CLOSE Mat_labor ; /*Cierra Cursor*/
//
//
//
end subroutine

public subroutine wf_updt_art_finicio (datetime adt_fec_inicio);//dwItemStatus ldis_status
//Long   ll_inicio 
//
//
//FOR ll_inicio = 1 TO idw_det_art.Rowcount()
//	 
//    ldis_status = idw_det_art.GetitemStatus(ll_inicio,0,primary!)
//	 
//	 IF ldis_status = NewModified! THEN
//	    // Modifica solo los que estan planeados
//	 	 IF ((idw_det_art.object.flag_estado[ll_inicio]='1') OR &
//	 	 	  (idw_det_art.object.flag_estado[ll_inicio]='3') )THEN
//	 		  idw_det_art.object.fec_proyect  [ll_inicio] = adt_fec_inicio
//	 		  idw_det_art.ii_update = 1
//	 	 END IF
//	 END IF		 
//	 
//NEXT
//
end subroutine

public function boolean of_set_articulo (string as_cod_art);String 	ls_almacen, ls_cod_clase, ls_flag_reposicion,ls_null,ls_flag_estado
Decimal	ldc_saldo_total, ld_costo_unit


setnull(ls_null)

// Setea las variables x defecto de acuerdo al codigo de articulo
// x ejemplo el almacen tácito y el precio en articulo_precio_pactado

if tab_1.tabpage_1.dw_operaciones.GetRow() = 0 then return false

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

select almacen into :ls_almacen from almacen_tacito where cod_origen = :gs_origen
																		and cod_clase  = :ls_cod_clase;

if SQLCA.SQLCode = 100 then SetNull(ls_almacen)

tab_1.tabpage_1.dw_articulos.object.almacen 			 [tab_1.tabpage_1.dw_articulos.GetRow()] = ls_almacen
tab_1.tabpage_1.dw_articulos.object.flag_reposicion [tab_1.tabpage_1.dw_articulos.GetRow()] = ls_flag_reposicion

ls_flag_estado = tab_1.tabpage_1.dw_articulos.object.flag_estado [tab_1.tabpage_1.dw_articulos.GetRow()]

// Todos los articulos tipo de reposicion de stock entran como activos
IF ls_flag_reposicion = '1' THEN
	tab_1.tabpage_1.dw_articulos.object.flag_estado[tab_1.tabpage_1.dw_articulos.GetRow()] = '1'
	tab_1.tabpage_1.dw_articulos.object.flag		  [tab_1.tabpage_1.dw_articulos.GetRow()] = 'S'
ELSE
	if ls_flag_estado <> '3' then
		tab_1.tabpage_1.dw_articulos.object.flag		  [tab_1.tabpage_1.dw_articulos.GetRow()] = ls_null
	else
		tab_1.tabpage_1.dw_articulos.object.flag		  [tab_1.tabpage_1.dw_articulos.GetRow()] = 'S'
	end if
END IF

if Not IsNull(ls_almacen) then
	select sldo_total
		into :ldc_saldo_total
	from articulo_almacen
	where cod_art = :as_cod_art
	  and almacen = :ls_almacen;
	
	if SQLCA.SQLCode = 100 then ldc_saldo_total = 0
else
	ldc_saldo_total = 0
end if

tab_1.tabpage_1.dw_articulos.object.saldo_total [tab_1.tabpage_1.dw_articulos.GetRow()] = ldc_saldo_Total

SELECT usf_cmp_prec_ult_compra(:as_cod_art, :ls_almacen ) 
  INTO :ld_costo_unit 
  FROM dual ;

tab_1.tabpage_1.dw_articulos.object.precio_unit[tab_1.tabpage_1.dw_articulos.GetRow()] = ld_costo_unit

return true
end function

public function boolean of_set_saldo_total (string as_cod_art, string as_almacen);Decimal	ldc_saldo_total, ldc_costo_unit

if tab_1.tabpage_1.dw_operaciones.GetRow() = 0 then return false

select sldo_total into :ldc_saldo_total
  from articulo_almacen
  where cod_art = :as_cod_art
    and almacen = :as_almacen ;

if SQLCA.SQLCode = 100 then ldc_saldo_total = 0

tab_1.tabpage_1.dw_articulos.object.saldo_total [tab_1.tabpage_1.dw_articulos.GetRow()] = ldc_saldo_Total

SELECT usf_cmp_prec_ult_compra(:as_cod_art, :as_almacen ) 
  INTO :ldc_costo_unit 
  FROM dual ;

tab_1.tabpage_1.dw_articulos.object.precio_unit[tab_1.tabpage_1.dw_articulos.GetRow()] = ldc_costo_unit

//
return true
end function

public subroutine of_modify_art ();
//VERIFICAR SI ES REPOSICION
tab_1.tabpage_1.dw_articulos.Modify("cod_art.Protect='1~tIf(IsNull(flag),1,0)'")			
tab_1.tabpage_1.dw_articulos.Modify("almacen.Protect='1~tIf(IsNull(flag),1,0)'")			
tab_1.tabpage_1.dw_articulos.Modify("cant_proyect.Protect='1~tIf(IsNull(flag),1,0)'")	
tab_1.tabpage_1.dw_articulos.Modify("cnta_prsp.Protect='1~tIf(IsNull(flag),1,0)'")	
tab_1.tabpage_1.dw_articulos.Modify("fec_proyect.Protect='1~tIf(IsNull(flag),1,0)'")	



end subroutine

on w_ope313_orden_trabajo_simplif.create
int iCurrent
call super::create
if this.MenuName = "m_master_lista_anular" then this.MenuID = create m_master_lista_anular
this.st_2=create st_2
this.st_1=create st_1
this.pb_1=create pb_1
this.tab_1=create tab_1
this.cb_genera=create cb_genera
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.tab_1
this.Control[iCurrent+5]=this.cb_genera
this.Control[iCurrent+6]=this.dw_master
end on

on w_ope313_orden_trabajo_simplif.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.tab_1)
destroy(this.cb_genera)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.settransobject(sqlca)
tab_1.tabpage_1.dw_operaciones.settransobject(sqlca)
tab_1.tabpage_1.dw_articulos.settransobject(sqlca)


idw_1 = dw_master

//recupero parametros
select doc_ot into :is_doc_ot from logparam where reckey = '1' ;


IF Isnull(is_doc_ot) or Trim(is_doc_ot) = '' THEN
	Messagebox('Aviso','Revise Parametros LOGPARAM -> DOC_OT')
	
END IF





end event

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 50

tab_1.tabpage_1.dw_operaciones.width  = newwidth  - tab_1.tabpage_1.dw_operaciones.x - 100
tab_1.tabpage_1.dw_articulos.width    = newwidth  - tab_1.tabpage_1.dw_articulos.x	 - 100
tab_1.tabpage_1.dw_articulos.height   = newheight - tab_1.tabpage_1.dw_articulos.y   - 1000

end event

event ue_insert;call super::ue_insert;String ls_flag_estado,ls_cencos_slc,ls_flag_estado_ope
Long   ll_row,ll_count,ll_mov_atrazados,ll_row_master,ll_row_op
n_cst_diaz_retrazo lnvo_amp_retr

ib_update_check = true


ll_row_master = dw_master.Getrow()

IF ll_row_master > 0 THEN
	ls_flag_estado = dw_master.object.flag_estado [ll_row_master]	//estado de la orden de trabajo
	ls_cencos_slc  = dw_master.object.cencos_slc  [ll_row_master]
END IF


choose case idw_1
		 case dw_master
			
			   // Los dias de retrazo los toma de LogParam y el usuario de gs_user
			   lnvo_amp_retr = CREATE n_cst_diaz_retrazo
			   ll_mov_atrazados = lnvo_amp_retr.of_amp_retrazados( is_doc_ot )
				
			   DESTROY lnvo_amp_retr
		
//			   if ll_mov_atrazados > 0 then
//				   MessageBox('Aviso', 'Usted tiene pendientes ' + string(ll_mov_atrazados) &
//					  	               + ' articulos proyectados en orden de trabajo. Reprograma previamente')
//				   Return
//			   end if
//			 
			
			 	TriggerEvent('ue_update_request')
			 	
				if ib_update_check = FALSE THEN RETURN
				
				is_accion = 'new'
				
				dw_master.reset()
				tab_1.tabpage_1.dw_articulos.reset()
				tab_1.tabpage_1.dw_operaciones.reset()
				
				select count (*) into :ll_count 
				  from vw_cam_usr_adm
				 where (cod_usr = :gs_user  ) ;
						  
				
				if ll_count = 0 then
					Messagebox('Aviso','No Tiene Acceso para Realizar Compras Administrativas ,Verifique!')
					Return
				end if
				
				
		 case tab_1.tabpage_1.dw_operaciones	
			
				IF Not(ls_flag_estado = '1' OR ls_flag_estado = '3') THEN 	
				  Messagebox('Aviso','No puede Insertar Articulos por el estado en que se Encuentra la Orden de Trabajo')
			  	  RETURN	
			  END IF
			
				IF dw_master.Getrow() = 0 THEN
					Messagebox('Aviso','Debe Ingresar Registro En la Cabecera , Verifique!')
					Return
				END IF
				
				
			   
		 case tab_1.tabpage_1.dw_articulos	
			
				IF Not(ls_flag_estado = '1' OR ls_flag_estado = '3') THEN 	
				  Messagebox('Aviso','No puede Insertar Articulos por el estado en que se Encuentra la Orden de Trabajo')
			  	  RETURN	
			  END IF
			  
			  //VERIFICAR datos de operacion
			  ll_row_op  			= tab_1.tabpage_1.dw_operaciones.Getrow()
			  ls_flag_estado_ope = tab_1.tabpage_1.dw_operaciones.object.flag_estado [ll_row_op]
			  
			  IF Not(ls_flag_estado_ope = '1' OR ls_flag_estado_ope = '3') THEN 	
				  Messagebox('Aviso','No puede Insertar Articulos por el estado en que se Encuentra la Operación')
			  	  RETURN	
			  END IF
				
			  IF tab_1.tabpage_1.dw_operaciones.Getrow() = 0 THEN
				  Messagebox('Aviso','Debe Ingresar Registro En la Cabecera de Operaciones , Verifique!')
				  Return
			  END IF
			  
end choose







ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_articulos.ii_update = 1 OR &
	 tab_1.tabpage_1.dw_operaciones.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update 							  = 0
		tab_1.tabpage_1.dw_articulos.ii_update   = 0
		tab_1.tabpage_1.dw_operaciones.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;Long      ll_row_det,ll_inicio,ll_row_master,ll_nro_operacion,ll_found ,ll_row_ope
String    ls_cod_origen, ls_nro_ord_t, ls_oper_sec ,ls_expresion
Decimal   ldc_cant_proy, ld_precio_unit
Boolean	 lb_result
dwItemStatus ldis_status
//
//
ib_update_check = True

//invocar objeto de numeracion de parte
nvo_numeradores_varios lnvo_numeradores_varios
lnvo_numeradores_varios    = CREATE nvo_numeradores_varios
//

ll_row_master = dw_master.Getrow()


IF dw_master.Rowcount() = 0 THEN
	Messagebox('Aviso','No existe Orden de Trabajo No Existe , Verifique!')
	ib_update_check = False
	RETURN
END IF

//--VERIFICACION Y ASIGNACION DE DATOS DE ORDEN DE TRABAJO
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
end if


//--VERIFICACION Y ASIGNACION DE DATA EN DETALLE DE OPERACIONES
if f_row_Processing(tab_1.tabpage_1.dw_articulos, "form") <> true then	
	ib_update_check = False	
	return
end if

//--VERIFICACION Y ASIGNACION DE DATA EN DETALLE DE OPERACIONES
if f_row_Processing( tab_1.tabpage_1.dw_operaciones, "form") <> true then	
	ib_update_check = False	
	return
end if


ls_cod_origen = dw_master.object.cod_origen [1]
ls_nro_ord_t  = dw_master.object.nro_orden  [1] 

IF is_accion = 'new' THEN
	IF lnvo_numeradores_varios.uf_num_ot(ls_cod_origen,ls_nro_ord_t) = FALSE THEN
		ib_update_check = False	
		RETURN
	ELSE
		dw_master.Object.nro_orden [ll_row_master] = ls_nro_ord_t
	END IF
END IF

 
FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_operaciones.Rowcount() //detalle de operaciones
	 //verifica si es un nuevo registro
	 ldis_status = tab_1.tabpage_1.dw_operaciones.GetitemStatus(ll_inicio,0,primary!)
	 ls_oper_sec = tab_1.tabpage_1.dw_operaciones.object.oper_sec [ll_inicio]
	 
	 IF ldis_status = NewModified! THEN
		 //genera oper_sec
		 IF lnvo_numeradores_varios.uf_num_oper_sec (gs_origen,ls_oper_sec) = FALSE THEN
			 ib_update_check = False	
			 RETURN
		 ELSE
			 tab_1.tabpage_1.dw_operaciones.object.oper_sec [ll_inicio] = ls_oper_sec
		 END IF	

		 //actualiza datos de la orden de trabajo	
		 tab_1.tabpage_1.dw_operaciones.Object.tipo_orden [ll_inicio] = is_doc_ot
		 tab_1.tabpage_1.dw_operaciones.Object.nro_orden  [ll_inicio] = ls_nro_ord_t				 
	 END IF
NEXT


//retirar filtro y colocarlo nuevamente

ll_row_ope = tab_1.tabpage_1.dw_operaciones.GetRow()

lb_result = tab_1.tabpage_1.dw_operaciones.IsSelected(ll_row_ope)


//quito filtro
tab_1.tabpage_1.dw_articulos.SetFilter('')
tab_1.tabpage_1.dw_articulos.Filter()



FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_articulos.Rowcount()  //SALIDA DE articulo x operaciones
	 //verifica si es un nuevo registro
	 ldis_status = tab_1.tabpage_1.dw_articulos.GetitemStatus(ll_inicio,0,primary!)
	 
	 ldc_cant_proy    = tab_1.tabpage_1.dw_articulos.Object.cant_proyect  [ll_inicio]
	 ld_precio_unit   = tab_1.tabpage_1.dw_articulos.Object.precio_unit   [ll_inicio]
	 ll_nro_operacion = tab_1.tabpage_1.dw_articulos.Object.nro_operacion [ll_inicio]

	 IF isnull(ld_precio_unit) THEN
		ld_precio_unit =0.1
	 END IF
	 
	 IF ldc_cant_proy = 0.0000 OR Isnull(ldc_cant_proy) THEN
		 Messagebox('Aviso','Debe Ingresar Alguna cantidad en articulo ')	
		 ib_update_check = False
		 Return
	 END IF
	 
	 IF ldis_status = NewModified! THEN
		 ///buscar nro de operacion	
		 ls_expresion = 'nro_operacion = '+Trim(String(ll_nro_operacion))
		 ll_found = tab_1.tabpage_1.dw_operaciones.find(ls_expresion,1,tab_1.tabpage_1.dw_operaciones.Rowcount())
		 
		 if ll_found > 0 then
			 ls_oper_sec = tab_1.tabpage_1.dw_operaciones.object.oper_sec[ll_found]			 
		 else
			 Messagebox('Aviso','No se Encuentra Operacion ,Verifique!')
			 ib_update_check = False
			 RETURN
		 end if

		 
		 tab_1.tabpage_1.dw_articulos.object.oper_sec [ll_inicio] = ls_oper_sec
		 tab_1.tabpage_1.dw_articulos.object.tipo_doc [ll_inicio] = is_doc_ot
		 tab_1.tabpage_1.dw_articulos.object.nro_doc  [ll_inicio] = ls_nro_ord_t
	 END IF	
	 
NEXT


//selecciono fila nuevamente
tab_1.tabpage_1.dw_operaciones.Event rowfocuschanged (ll_row_ope)
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
tab_1.tabpage_1.dw_operaciones.AcceptText()
tab_1.tabpage_1.dw_articulos.AcceptText()

ib_update_check = TRUE

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_1.dw_operaciones.ii_update = 1 THEN
	IF tab_1.tabpage_1.dw_operaciones.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		Messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF tab_1.tabpage_1.dw_articulos.ii_update = 1 THEN
	IF tab_1.tabpage_1.dw_articulos.Update() = -1 then
		lbo_ok = FALSE
    	Rollback ;
		Messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)	
	END IF
END IF





IF lbo_ok THEN
	
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_operaciones.ii_update = 0
	tab_1.tabpage_1.dw_articulos.ii_update = 0
	is_accion = 'fileopen'
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

sl_param.dw1     = 'd_abc_lista_orden_trabajo_x_usr_tbl'
sl_param.titulo  = 'Orden de Trabajo'
sl_param.tipo    = '1SQL'
sl_param.string1 =  ' WHERE ("VW_OPE_OT_X_ADM_TOD"."USUARIO" = '+"'"+gs_user+"'"+')    '&
						 +'ORDER BY "VW_OPE_OT_X_ADM_TOD"."FEC_SOLICITUD" DESC  '


sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN

	dw_master.retrieve(sl_param.field_ret[2])
	tab_1.tabpage_1.dw_articulos.Retrieve(is_doc_ot, sl_param.field_ret[2])
	tab_1.tabpage_1.dw_operaciones.Retrieve(is_doc_ot, sl_param.field_ret[2])
	TriggerEvent ('ue_modify')
	is_accion = 'fileopen'	
	
END IF


end event

event close;call super::close;Close(w_ope507_labor_x_art)
end event

event ue_delete;Long   ll_row ,ll_row_det
String ls_flag_estado
Decimal {4} ldc_cant_procesada

if dw_master.Getrow() = 0 then return

if idw_1 = dw_master then
	
	ls_flag_estado = dw_master.object.flag_estado [1]
	
	if ls_flag_estado <> '3' then
		Messagebox('Aviso','Orden de Trabajo Tiene Operaciones Vinculados Verifique!')
		Return
	end if
	
	if tab_1.tabpage_1.dw_operaciones.rowcount() > 0 then
		Messagebox('Aviso','Orden de Trabajo Tiene Operaciones Vinculados Verifique!')
		Return
	end if	
	
elseif idw_1 = tab_1.tabpage_1.dw_operaciones then
	ll_row_det  = idw_1.Getrow()
	
	ls_flag_estado = idw_1.object.flag_estado [ll_row_det]
				
	IF Not (ls_flag_estado = '3') THEN //NO PROYECTADO
		Messagebox('Aviso','No se puede Eliminar Operación por el estado en que se Encuentra')
		RETURN
	END IF
	
	if tab_1.tabpage_1.dw_articulos.rowcount() > 0 then
		Messagebox('Aviso','Operaciones Tiene Articulos Vinculados Verifique!')
		Return 
	end if
	
elseif idw_1 = tab_1.tabpage_1.dw_articulos then		
	
	ll_row_det = idw_1.getrow()			
				
	IF ll_row_det = 0 THEN 
		Messagebox('Aviso','Seleccione Articulo a Eliminar')
		Return
	END IF
				
	IF ls_flag_estado = '2' THEN //articulo cerrado
		Messagebox('Aviso','No se puede Eliminar Operación por el estado en que se Encuentra')
		RETURN
	ELSEIF ls_flag_estado = '1' THEN
		//VERIFICAR SI ESTA PROCESADO
		ldc_cant_procesada = idw_1.Object.cant_procesada [ll_row_det]					
					
		IF Not( Isnull(ldc_cant_procesada) OR ldc_cant_procesada = 0 ) THEN
			Messagebox('Aviso','Cantidad de Articulo ha sido procesada ,Verifique!')
			RETURN
		END IF
					
					
	END IF
	
	
end if




ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_modify;call super::ue_modify;Integer li_protect
String  ls_flag_estado 


if dw_master.Getrow() = 0 then return

dw_master.of_protect ()
tab_1.tabpage_1.dw_operaciones.of_protect ()
tab_1.tabpage_1.dw_articulos.of_protect   ()

ls_flag_estado = dw_master.object.flag_estado [1]

IF ls_flag_estado <> '3'  THEN
	dw_master.ii_protect = 0
	dw_master.of_protect()
END IF

//bolqueos sobre articulos
li_protect = tab_1.tabpage_1.dw_articulos.ii_protect
	
IF li_protect = 0 THEN
	of_modify_art ()
END IF 



end event

type st_2 from statictext within w_ope313_orden_trabajo_simplif
integer x = 3410
integer y = 632
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Articulo"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ope313_orden_trabajo_simplif
integer x = 3410
integer y = 556
integer width = 320
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ope313_orden_trabajo_simplif
integer x = 3470
integer y = 384
integer width = 174
integer height = 152
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\busqueda_comercializacion.bmp"
alignment htextalign = left!
end type

event clicked;String ls_ot_adm,ls_flag_estado

if dw_master.Getrow() = 0  then return 

ls_ot_adm      = dw_master.object.ot_adm 		 [1]
ls_flag_estado = dw_master.object.flag_estado [1]

IF Not(ls_flag_estado = '1' OR ls_flag_estado = '3') THEN 	
   Messagebox('Aviso','No puede Insertar Articulos por el estado en que se Encuentra la Orden de Trabajo')
   RETURN	
END IF


OpenWithParm(w_ope507_labor_x_art,ls_ot_adm)

end event

type tab_1 from tab within w_ope313_orden_trabajo_simplif
event create ( )
event destroy ( )
integer x = 14
integer y = 824
integer width = 3717
integer height = 1200
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.Control[]={this.tabpage_1}
end on

on tab_1.destroy
destroy(this.tabpage_1)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 3680
integer height = 1080
long backcolor = 79741120
string text = "Articulos x Comprar"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_operaciones dw_operaciones
dw_articulos dw_articulos
end type

on tabpage_1.create
this.dw_operaciones=create dw_operaciones
this.dw_articulos=create dw_articulos
this.Control[]={this.dw_operaciones,&
this.dw_articulos}
end on

on tabpage_1.destroy
destroy(this.dw_operaciones)
destroy(this.dw_articulos)
end on

type dw_operaciones from u_dw_abc within tabpage_1
integer x = 14
integer y = 12
integer width = 3643
integer height = 316
integer taborder = 40
string dataobject = "d_abc_operaciones_simple_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;String ls_oper_sec,ls_expresion
Long   ll_nro_operacion

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

if row = 0 then return


//filtrar por operaciones
ll_nro_operacion = this.object.nro_operacion [row]
ls_expresion 	  = 'nro_operacion = '+ Trim(String(ll_nro_operacion))

tab_1.tabpage_1.dw_articulos.SetFilter(ls_expresion)
tab_1.tabpage_1.dw_articulos.Filter()
end event

event constructor;call super::constructor;
is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 16				// columnas de lectrua de este dw


idw_mst = tab_1.tabpage_1.dw_operaciones
end event

event itemchanged;call super::itemchanged;String ls_null,ls_data,ls_ot_adm,ls_cod_ejecutor,ls_desc_labor
Long   ll_count
Decimal ld_costo_unitario




SetNull(ls_null)

This.Accepttext()



CHOOSE CASE dwo.name
	    CASE 'cod_labor'
			
				//buscar ot_adm
				
				IF tab_1.tabpage_1.dw_articulos.rowcount() > 0 THEN
					Messagebox('Aviso','No puede Cambiar Codigo de Labor tiene Articulo , Verifique!')
					RETURN 
				END IF
				
				ls_ot_adm = dw_master.object.ot_adm [1]
				
				select v.desc_labor into :ls_desc_labor
				  from vw_ope_labor_x_ot_adm v ,labor l
			    where (v.cod_labor   = l.cod_labor ) and
				 		 (v.ot_adm		 = :ls_ot_adm	) and
				 		 (l.cod_labor   = :data 		) and
					    (l.flag_estado = '1'   		) and
						 (l.flag_maq_mo = 'A'   		) ;
				

				
				if sqlca.sqlcode = 100 then
					This.Object.cod_labor    [row] =  ls_null
					This.Object.cod_ejecutor [row] =  ls_null
					Messagebox('Aviso','Codigo de Labor No Existe ,Verifique! ')
					Return 1
				else
					this.object.desc_operacion [row] = ls_desc_labor
					/*Recupero Ejecutor*/
					SELECT Count(*)
					  INTO :ll_count
					  FROM labor_ejecutor
					 WHERE (cod_labor = :data) ;
					
					IF ll_count > 0 THEN
						SELECT MIN(cod_ejecutor)
					     INTO :ls_cod_ejecutor
					     FROM labor_ejecutor
					    WHERE (cod_labor = :data) ;
						 
						This.object.cod_ejecutor [row] = ls_cod_ejecutor
						
					   /* Asignando costo unitario */
					   SELECT NVL(costo_unitario,0)
				        INTO :ld_costo_unitario
				        FROM labor_ejecutor le
				       WHERE ((le.cod_labor    = :data             ) AND
				              (le.cod_ejecutor = :ls_cod_ejecutor  )) ;
				      
				      This.object.costo_unit [row] = ld_costo_unitario
					   					   
					END IF
				end if
				
 		 CASE 'cod_ejecutor'
				ls_data = this.object.cod_labor [row]
				
				
				select Count(*) Into :ll_count
				  from labor_ejecutor e
				 where (e.cod_labor    = :ls_data )  and
				       (e.cod_ejecutor = :data    )  ;
						 
				if ll_count = 0 then
					This.Object.cod_ejecutor [row] =  ls_null
					Messagebox('Aviso','Codigo de Ejecutor No Existe ,Verifique! ')
					Return 1
				end if
				
	   CASE	'cencos'	

				select Count(*) Into :ll_count from centros_costo cc
				 where (cc.cencos      = :data) and
      				 (cc.flag_estado = '1'  ) ;
						 
				if ll_count = 0 then
					This.Object.cencos [row] =  ls_null
					Messagebox('Aviso','Centro de Costo No Existe ,Verifique! ')
					Return 1
				end if
				

END CHOOSE
end event

event itemerror;call super::itemerror;return 1
end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN Return

String   ls_name, ls_prot,ls_ot_adm,ls_cod_labor,ls_cod_ejecutor
Long     ll_count
Decimal {2} ld_costo_unitario
str_seleccionar lstr_seleccionar


ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if



CHOOSE CASE dwo.name
		 CASE 'cod_labor'
				
				ls_ot_adm = dw_master.object.ot_adm [1]
				
				IF Isnull(ls_ot_adm) or Trim(ls_ot_adm) = '' then
					Messagebox('Aviso','Debe Ingresar Alguna Administración , Verifique!')
					RETURN 
				END IF
				
				IF tab_1.tabpage_1.dw_articulos.rowcount() > 0 THEN
					Messagebox('Aviso','No puede Cambiar Codigo de Labor tiene Articulo , Verifique!')
					RETURN 
				END IF
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_OPE_LABOR_X_OT_ADM_CMP.COD_LABOR AS CODIGO, '&   
										      +'VW_OPE_LABOR_X_OT_ADM_CMP.DESC_LABOR AS DESCRIPCION, '&
												+'VW_OPE_LABOR_X_OT_ADM_CMP.UND AS UNIDAD '&
												+'FROM VW_OPE_LABOR_X_OT_ADM_CMP '&
												+'WHERE VW_OPE_LABOR_X_OT_ADM_CMP.OT_ADM = '+"'"+ls_ot_adm+"'"				

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					ls_cod_labor = lstr_seleccionar.param1[1]
					Setitem(row,'cod_labor',lstr_seleccionar.param1[1])
					Setitem(row,'desc_operacion',lstr_seleccionar.param2[1])
					
					/*Recupero Ejecutor*/
					SELECT Count(*)
					  INTO :ll_count
					  FROM labor_ejecutor
					 WHERE (cod_labor = :ls_cod_labor) ;
					
					IF ll_count > 0 THEN
						SELECT MIN(cod_ejecutor)
					     INTO :ls_cod_ejecutor
					     FROM labor_ejecutor
					    WHERE (cod_labor = :ls_cod_labor) ;
						 
						This.object.cod_ejecutor [row] = ls_cod_ejecutor
						
					   /* Asignando costo unitario */
					   SELECT NVL(costo_unitario,0)
				        INTO :ld_costo_unitario
				        FROM labor_ejecutor le
				       WHERE ((le.cod_labor    = :ls_cod_labor     ) AND
				              (le.cod_ejecutor = :ls_cod_ejecutor  )) ;
				      
				      This.object.costo_unit [row] = ld_costo_unitario
					   					   
					END IF
					ii_update = 1
				END IF
		CASE 'cod_ejecutor'
			  
			   ls_cod_labor = this.object.cod_labor [row]
				
				IF Isnull(ls_cod_labor) or Trim(ls_cod_labor) = '' then
					Messagebox('Aviso','Debe Seleccionar Alguna Labor , Verifique!')
					RETURN 
				END IF
				
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT LABOR_EJECUTOR.COD_EJECUTOR AS COD_EJECUTOR ,'&
														 +'LABOR_EJECUTOR.COD_LABOR    AS COD_LABOR     '&
														 +'FROM LABOR_EJECUTOR ' &
														 +'WHERE LABOR_EJECUTOR.COD_LABOR = '+"'"+ls_cod_labor+"'"
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_ejecutor',lstr_seleccionar.param1[1])
					ls_cod_ejecutor = lstr_seleccionar.param1[1]

					// Asignando costo unitario
					SELECT NVL(costo_unitario,0)
				     INTO :ld_costo_unitario
				     FROM labor_ejecutor le
				    WHERE ((le.cod_labor    = :ls_cod_labor ) AND
				           (le.cod_ejecutor = :ls_cod_ejecutor)) ;
				
				   This.object.costo_unit [row] = ld_costo_unitario
				
					ii_update = 1
				END IF
				

		CASE 'cencos'

				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&   
										      +'CENTROS_COSTO.DESC_CENCOS AS DESC_CENCOS '&
												+'FROM CENTROS_COSTO '&
												+'WHERE CENTROS_COSTO.FLAG_ESTADO = '+"'"+'1'+"'"
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos',lstr_seleccionar.param1[1])
					this.ii_update = 1
				END IF
				
	
END CHOOSE


end event

event ue_insert_pre;call super::ue_insert_pre;String ls_cencos,ls_nro_orden
Long   ll_nro_operacion 

IF This.Rowcount() > 1 THEN
	ll_nro_operacion = this.object.nro_operacion [al_row - 1] + 10
ELSE
	ll_nro_operacion = 10
END IF

ls_nro_orden = dw_master.object.nro_orden  [1] 
ls_cencos    = dw_master.object.cencos_slc [1]

// Asignando datos de dw_master
This.SetItem( al_row, 'nro_operacion'		,ll_nro_operacion )
This.SetItem( al_row, 'tipo_orden'			, is_doc_ot 		)
This.SetItem( al_row, 'nro_orden'			, ls_nro_orden 	)
This.SetItem( al_row, 'flag_estado'			, '3' 				)
This.SetItem( al_row, 'fec_inicio'			, today() 			)
This.SetItem( al_row, 'fec_inicio_est'		, today()			)
This.SetItem( al_row, 'dias_para_inicio'  , 0.00 				)
This.SetItem( al_row, 'dias_duracion_proy', 0.00 				)
This.SetItem( al_row, 'cant_proyect'      , 0.00 				)
This.SetItem( al_row, 'cencos'            , ls_cencos 		)
This.SetItem( al_row, 'nro_personas'      , 1 					)
This.SetItem( al_row, 'cod_usr'           , gs_user 			)

end event

event rowfocuschanged;call super::rowfocuschanged;Long   ll_nro_operacion
String ls_expresion

This.SelectRow(0, False)
This.SelectRow(currentrow, True)

This.Setrow(currentrow)


//filtrar por operaciones
ll_nro_operacion = this.object.nro_operacion [currentrow]

IF Isnull(ll_nro_operacion) then return 
ls_expresion 	  = 'nro_operacion = '+ Trim(String(ll_nro_operacion))

tab_1.tabpage_1.dw_articulos.SetFilter(ls_expresion)
tab_1.tabpage_1.dw_articulos.Filter()
end event

event dragdrop;call super::dragdrop;DataWindow ldw_Source
Long       ll_row ,ll_row_ins ,ll_found
String     ls_cod_art,ls_cod_labor ,ls_expresion ,ls_flag_estado ,ls_flag_estado_ope
dwobject   dwo_1


IF source.TypeOf() = DataWindow! THEN
   ldw_Source = source
	
	ll_row = ldw_Source.GetRow()
	
	ls_cod_art     = ldw_source.object.cod_art    [ll_row]
	ls_cod_labor   = ldw_source.object.cod_labor  [ll_row]
	ls_flag_estado = dw_master.object.flag_estado [dw_master.Getrow()]
	
		
	IF Not(ls_flag_estado = '1' OR ls_flag_estado = '3') THEN 	
	   Messagebox('Aviso','No puede Insertar Articulos por el estado en que se Encuentra la Orden de Trabajo')
	   RETURN	
   END IF

	
	
	//verificar que labor
	ls_expresion = 'cod_labor = '+"'"+ls_cod_labor+"'"
	
	ll_found = this.find(ls_expresion,1,this.rowcount())
	
	if ll_found = 0 then
		//Inserta Labor
		TriggerEvent('ue_insert')
		
		ll_row_ins = this.rowcount()
		

		this.object.cod_labor [ll_row_ins] = ls_cod_labor
		
		dwo_1 = this.object.cod_labor
		
		this.Event itemchanged(ll_row_ins,dwo_1,ls_cod_labor)
	else
		this.Event rowfocuschanged (ll_found)
		
		//VERIFICAR datos de operacion
 	   ls_flag_estado_ope = tab_1.tabpage_1.dw_operaciones.object.flag_estado [ll_found]
			  
	   IF Not(ls_flag_estado_ope = '1' OR ls_flag_estado_ope = '3') THEN 	
		   Messagebox('Aviso','No puede Insertar Articulos por el estado en que se Encuentra la Operación')
			RETURN	
	   END IF
				
		

		
	end if

	
	
	
	
	//ARTICULOS
	
	tab_1.tabpage_1.dw_articulos.TriggerEvent('ue_insert')
	
	ll_row_ins = tab_1.tabpage_1.dw_articulos.rowcount()
	
	tab_1.tabpage_1.dw_articulos.object.cod_art [ll_row_ins] = ls_cod_art
	
 	dwo_1 = tab_1.tabpage_1.dw_articulos.object.cod_art
	 
	tab_1.tabpage_1.dw_articulos.Event itemchanged(ll_row_ins,dwo_1,ls_cod_art)

END IF	


ldw_Source.Drag(End!)
end event

type dw_articulos from u_dw_abc within tabpage_1
integer x = 14
integer y = 352
integer width = 3639
integer height = 720
integer taborder = 50
string dataobject = "d_insumo_ot_simplif"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = tab_1.tabpage_1.dw_articulos

end event

event itemchanged;call super::itemchanged;String   ls_null ,ls_cod_labor ,ls_cod_art ,ls_desc_art ,ls_uni_art ,ls_cnta_prsp ,&
			ls_desc
DateTime ldt_fec_inicio_ope, ldt_fec_inicio_mat

this.acceptText()

ldt_fec_inicio_ope = tab_1.tabpage_1.dw_operaciones.object.fec_inicio [tab_1.tabpage_1.dw_operaciones.Getrow()] //fecha der inicio de operaciones
ldt_fec_inicio_mat = tab_1.tabpage_1.dw_articulos.object.fec_proyect  [row] 					//fecha del material

IF ldt_fec_inicio_mat < ldt_fec_inicio_ope then
	messagebox('Aviso','Fecha de material no puede ser menor que fecha de operación')
   THIS.object.fec_proyect [row] = ldt_fec_inicio_ope
	RETURN 1
END IF


SetNull(ls_null)


choose case dwo.name
		 case 'cod_art'
				ls_cod_labor = tab_1.tabpage_1.dw_operaciones.object.cod_labor [tab_1.tabpage_1.dw_operaciones.getrow()]
				ls_cod_art   = data

				w_ope313_orden_trabajo_simplif.SetMicroHelp(LS_COD_LABOR)

				SELECT a.desc_art, a.und, l.cnta_prsp_insm
				  INTO :ls_desc_art, :ls_uni_art, :ls_cnta_prsp
				  FROM articulo a,
				  		 labor_insumo l
				 WHERE a.cod_art     = l.cod_art     
				   AND a.flag_estado = '1'           
					AND l.cod_labor   = :ls_cod_labor 
					AND a.cod_art	   = :ls_cod_art;
	
				IF SQLCA.SQLCode = 100 then
					Messagebox('Aviso','Verifique Codigo de Articulo')
					This.object.cod_art 		 	 [row] = ls_null
					This.object.nom_articulo 	 [row] = ls_null
					This.object.und 			 	 [row] = ls_null
					This.object.cnta_prsp	 	 [row] = ls_null
					Return 1
				end if
	
			   THIS.object.nom_articulo	[row] = ls_desc_art
				THIS.object.und				[row] = ls_uni_art
				THIS.object.cnta_prsp		[row] = ls_cnta_prsp
	
				of_set_articulo(ls_cod_art)
				
				
				/*DATOS DE REPOSICION*/
				
				
		case	'cnta_prsp'	
			
				select descripcion
				  into :ls_desc
			     from presupuesto_cuenta
				 where cnta_prsp = :data ;
	
				IF SQLCA.SQLCode = 100 then
					MessageBox('Aviso', 'Cuenta Presupuestal no existe')
					this.object.cnta_prsp [row] = ls_null
					Return 1
				end if

		case	'almacen'
			   select desc_almacen
			     into :ls_desc
			     from almacen
				 where almacen     = :data
				   and flag_estado = '1'   ;
	
				IF SQLCA.SQLCode = 100 then
					MessageBox('Aviso', 'El codigo de almacen no existe o no esta activo')
					this.object.almacen [row] = ls_null
					RETURN 1
				END IF
	
	of_set_saldo_total(this.object.cod_art[this.GetRow()], data)
				
end choose




	  

end event

event itemerror;call super::itemerror;return 1
end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN Return

String ls_name,ls_prot,ls_cod_labor,ls_flag
Decimal{4} ld_cant_procesada

str_seleccionar lstr_seleccionar

ls_name = dwo.name


ls_flag = this.object.flag[row]

if Isnull(ls_flag) OR TRIM(ls_flag) = '' then
	ls_flag = 'X'
end if

if this.Describe( lower(dwo.name) + ".Protect") = '1' then return

if not(ls_flag = 'S') then return


CHOOSE CASE dwo.name
		
		 CASE 'cod_art'

				ls_cod_labor = tab_1.tabpage_1.dw_operaciones.object.cod_labor [tab_1.tabpage_1.dw_operaciones.getrow()]
				
				
				
				IF Isnull(ls_cod_labor) OR Trim(ls_cod_labor) = '' THEN
					Messagebox('Aviso','No ha Ingresado Codigo de Labor ,Verifique!')
					Return
				END IF
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = "SELECT COD_ART AS CODIGO, "&   
											  + "DESC_ART AS DESCRIPCION, "&   
											  + "UND AS UNIDAD, "&   
											  + "CNTA_PRSP_INSM AS CUENTA_PRESUPUESTAL "&
											  + "FROM  VW_MTT_ART_X_LABOR "&
									  		  + "WHERE COD_LABOR = '" + ls_cod_labor + "'"    



				OpenWithParm(w_seleccionar,lstr_seleccionar)
		
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					this.object.cod_art 			[row] = lstr_seleccionar.param1[1]
					this.object.nom_articulo 	[row] = lstr_seleccionar.param2[1]
					this.object.und				[row] = lstr_seleccionar.param3[1]
					this.object.cnta_prsp		[row] = lstr_seleccionar.param4[1]
					this.ii_update = 1
					of_set_articulo(lstr_seleccionar.param1[1])
				END IF

       CASE 'cnta_prsp'
				// No muestra ayuda, en caso no esta permitido modificar cnta_prsp
			
		
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTA_PRSP AS CNTA_PRSP, '&   
											  + 'DESCRIPCION AS DESCRIPCION '&   
											  + 'FROM  PRESUPUESTO_CUENTA '

				OpenWithParm(w_seleccionar,lstr_seleccionar)
		
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					this.object.cnta_prsp	[row] = lstr_seleccionar.param1[1]
					this.ii_update = 1
				END IF

		 CASE 'almacen'
				// No muestra ayuda, en caso no esta permitido modificar almacen
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = "SELECT almacen AS codigo_almacen, "&   
												 +"desc_almacen AS DESCripcion_almacen "&   
												 +"FROM  almacen " &
												 +"where flag_estado = '1'"
		
				OpenWithParm(w_seleccionar,lstr_seleccionar)
		
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					this.object.almacen [row] = lstr_seleccionar.param1[1]
					of_set_saldo_total(this.object.cod_art[this.GetRow()], lstr_seleccionar.param1[1])
					this.ii_update = 1
				END IF
					

END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;Long     ll_nro_operac
String   ls_cencos, ls_cencos_slc, ls_cod_dolar, ls_tipo_mov, ls_cod_origen, &
			ls_flag_estado, ls_ot_adm, ls_flag_ctrl_aprt_ot
Datetime ldt_fec_inicio, ldt_fecha_actual


dw_master.accepttext()

ls_cencos_slc  = dw_master.object.cencos_slc    [dw_master.Getrow()] //centro de costo solicitante
ls_cod_origen	= dw_master.object.cod_origen    [dw_master.Getrow()] //origen de ot
ls_ot_adm		= dw_master.object.ot_adm			[dw_master.Getrow()] //ot adm
ls_cencos      = tab_1.tabpage_1.dw_operaciones.object.cencos		   [tab_1.tabpage_1.dw_operaciones.Getrow()] //centros de costo
ls_flag_estado	= tab_1.tabpage_1.dw_operaciones.object.flag_estado   [tab_1.tabpage_1.dw_operaciones.Getrow()] //flag de estado de operacion
ldt_fec_inicio = tab_1.tabpage_1.dw_operaciones.object.fec_inicio    [tab_1.tabpage_1.dw_operaciones.Getrow()] //fecha der inicio de operaciones
ll_nro_operac  = tab_1.tabpage_1.dw_operaciones.object.nro_operacion [tab_1.tabpage_1.dw_operaciones.Getrow()] //nro de operacion

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
SELECT cod_dolares, oper_cons_interno  INTO :ls_cod_dolar,:ls_tipo_mov  FROM logparam WHERE (reckey = '1');

ldt_fecha_actual = f_fecha_actual()



//// Asignando datos a dw_detail
This.SetItem( al_row, 'nro_operacion' ,ll_nro_operac    )
This.SetItem( al_row, 'cod_origen'    ,ls_cod_origen    )
This.SetItem( al_row, 'flag_estado'   ,ls_flag_estado   ) 
This.SetItem( al_row, 'cant_proyect'  , 0.0000          )
This.SetItem( al_row, 'cant_procesada', 0.0000          )
This.SetItem( al_row, 'precio_unit'	  , 0.0001          )
This.SetItem( al_row, 'cencos'        , ls_cencos_slc   )
This.SetItem( al_row, 'cod_moneda'	  , ls_cod_dolar    )
This.SetItem( al_row, 'tipo_mov'      , ls_tipo_mov     )
This.SetItem( al_row, 'fec_registro'  , ldt_fecha_actual)
This.SetItem( al_row, 'fec_proyect'   , ldt_fec_inicio  )
This.SetItem( al_row, 'flag_modificacion', '1' 			  )
This.SetItem( al_row, 'cod_usr'   	  , gs_user			  )

This.SetItem( al_row, 'flag'      	  , 'S'             ) //POR DEFECTO




of_modify_art()
end event

event retrieverow;call super::retrieverow;String ls_flag_reposicion
Decimal {4} ldc_cant_procesada

ls_flag_reposicion = this.object.flag_reposicion [row]
ldc_cant_procesada = this.object.cant_procesada  [row]

IF ls_flag_reposicion = '1' and ldc_cant_procesada = 0 then
	this.object.flag [row] = 'S'
END IF

end event

type cb_genera from commandbutton within w_ope313_orden_trabajo_simplif
integer x = 2871
integer y = 668
integer width = 480
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Genera Operac."
end type

event clicked;//String  ls_cencos_slc  ,ls_flag_estado  ,ls_nro_orden ,ls_origen  ,&
//		  ls_msj_err	  ,ls_tipo		    ,ls_cadena	 ,ls_seccion ,&
//		  ls_tip_seccion ,ls_desc_seccion 
//Long 	  ll_master_row,ll_nro_oper,ll_dias_dur
//Date	  ld_fec_inicio
//Integer li_confirma
//Decimal {2} ldc_factor
//
//
//dw_master.Accepttext()
//
////Cargo a variable local numero de orden de trabajo
//ll_master_row  = dw_master.GetRow()
//
//IF ll_master_row = 0 THEN RETURN 
//
//ls_origen		 = dw_master.object.cod_origen  [ll_master_row]
//ls_nro_orden    = dw_master.object.nro_orden	 [ll_master_row]
//ls_cencos_slc	 = dw_master.Object.cencos_slc  [ll_master_row]
//ls_flag_estado  = dw_master.object.flag_estado [ll_master_row]
//ls_seccion		 = is_seccion_def
//ls_tip_seccion	 = is_tip_seccion
//ls_desc_seccion = 'SECCION'
//ldc_factor		 = 1
//
///*IF Not (ls_flag_estado = '1' OR ls_flag_estado = '3' ) THEN   
//	Messagebox('Aviso','No se Puede Insertar Plantilla por estado de la orden de Trabajo')
//	Return	
//END IF*/
//
//// valida nro_orden
//IF Isnull(ls_nro_orden) OR Trim(ls_nro_orden) = '' THEN
//	Messagebox('Aviso','Genere Orden de trabajo')
//	RETURN 
//END IF	
//	
////valida si existe operaciones nuevas o modificaciones
//IF wf_check_save_oper() = TRUE THEN 
//	Messagebox('Aviso','Grabe antes de generar operaciones de Plantilla')
//	RETURN
//END IF
//	
//// valida numero de plantilla
//IF Isnull(is_plantilla) OR Trim(is_plantilla) = '' THEN
//	Messagebox('Mensaje al Usuario','Seleccione Nº de plantilla')
//	RETURN
//END IF	
//	
//// valida centro de Costo 
//IF Isnull(ls_cencos_slc) OR Trim(ls_cencos_slc) = '' THEN
//	Messagebox('Mensaje al Usuario','Ingrese Centro de Costo Solicitante')
//	RETURN
//END IF	
//
////FECHA DE INICIO DE OPERACIONES
//ld_fec_inicio = Date(dw_master.GetItemDateTime(ll_master_row,'fec_registro'))
//
//// valida fecha de inicio de operacion
//IF Isnull(ld_fec_inicio)  OR Trim(String(ld_fec_inicio,'ddmmyyyy')) = '00000000'THEN
//	Messagebox('Mensaje al Usuario','Seleccione Fecha de inicio de Operación')
//	RETURN
//END IF	
//
//li_confirma = Messagebox("Mensaje", "Usted ha seleccionado lo siguiente:~r~n"+"~r~n"+&
//												"Fecha de Inicio  : "+String(ld_fec_inicio)+"~r~n"+"~r~n"+&
//												"Plantilla Número : "+is_plantilla+"~r~n"+"~r~n"+&
//												"Orden de Trabajo : "+ls_nro_orden+"~r~n"+"~r~n"+&
//												"Centro de Costo  : "+ls_cencos_slc+"~r~n" +&
//												"Desea procesar con los datos existentes?? ",Exclamation!, YesNo!) 
//												
//IF li_confirma <> 1 THEN  RETURN //no desea generar operaciones
//
//
//DECLARE USP_MTT_COPIAR_PLANT_OPER_OT PROCEDURE FOR 
//	USP_MTT_COPIAR_PLANT_OPER_OT( :is_plantilla	,
//											:ls_nro_orden  ,
//											:ld_fec_inicio ,
//											:ls_cencos_slc ,
//											:ls_origen		,
//											:ls_seccion		,
//											:ls_tip_seccion,
//											:ls_desc_seccion,
//											:ldc_factor );
//											
//EXECUTE USP_MTT_COPIAR_PLANT_OPER_OT ;	
//
//IF SQLCA.sqlcode = -1 THEN
//	ls_msj_err =  SQLCA.SQLErrText
//	Rollback ;
//	Messagebox('Aviso','Error en Store Procedure USP_MTT_COPIAR_PLANT_OPER_OT: ' &
//				+ ls_msj_err)
//	Return
//END IF	
//
//CLOSE USP_MTT_COPIAR_PLANT_OPER_OT;
//		
////*datos de reprogramacion*//
////////////////////////////////////////////////////////////////////////
////RECUPERO OPERACIONES
//idw_det_op.InsertRow(0)
//idw_lista_op.retrieve(ls_nro_orden)
//if idw_lista_op.RowCount() >0 then
//	idw_lista_op.Event ue_output(1)
//end if
//
//IF idw_det_op.Rowcount() > 0 THEN
//	ll_nro_oper   = idw_det_op.Object.nro_operacion 	  [1]
//	ld_fec_inicio = Date(idw_det_op.Object.fec_inicio    [1])
//	ll_dias_dur   = idw_det_op.Object.dias_duracion_proy [1]
//	ls_tipo		  = 'P'
//END IF
//	
//DECLARE USP_CAM_REP_OPER_PRECEDENTE PROCEDURE FOR 
//		USP_CAM_REP_OPER_PRECEDENTE( :ls_nro_orden,
//											  :ll_nro_oper,
//											  :ld_fec_inicio,
//											  :ll_dias_dur,
//											  :ls_tipo);
//EXECUTE USP_CAM_REP_OPER_PRECEDENTE ;
//
//IF SQLCA.sqlcode = - 1 THEN
//	ls_msj_err = Sqlca.SQLerrtext	
//	ROLLBACK ;
//	Messagebox('Aviso','Error en Store Procedure USP_CAM_REP_OPER_PRECEDENTE: ' &
//			+ ls_msj_err)
//	RETURN
//END IF
//
//FETCH USP_CAM_REP_OPER_PRECEDENTE INTO :ls_cadena ;
//CLOSE USP_CAM_REP_OPER_PRECEDENTE ;
//
////// Recuperando datos para los secuenciales
////idw_oper_dep.Retrieve(ls_nro_orden, ll_nro_oper)
//////Recuperando datos para los lanzamientos
////idw_lanza_plant.Retrieve(ls_nro_orden)
//cb_genera.Enabled = False
//
//MessageBox('Aviso', 'Proceso realizado satisfactoriamente')
end event

type dw_master from u_dw_abc within w_ope313_orden_trabajo_simplif
integer x = 9
integer y = 16
integer width = 3383
integer height = 772
integer taborder = 30
string dataobject = "d_ot_simplif_ff"
end type

event constructor;call super::constructor;
is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez



ii_ck[1] = 2



idw_mst = dw_master


end event

event itemchanged;call super::itemchanged;String 	ls_name, ls_prot, ls_grupo, &
			ls_descripcion, ls_null
Long ll_count

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then return

SetNull(ls_null)

this.accepttext()

CHOOSE CASE dwo.name
	CASE 'cencos_rsp'
		SELECT count(*) INTO :ll_count
		FROM centros_costo
		WHERE cencos = :data ;
		
		IF ll_count > 0 THEN
			
			SELECT desc_cencos
			INTO :ls_descripcion
			FROM centros_costo
			WHERE cencos = :data ;
	
			this.SetItem( row, 'desc_cencos_rsp', ls_descripcion)
			this.ii_update = 1
		ELSE
			MessageBox('Aviso','Centro de Costo Responsable no existe')
			SetColumn("cencos_rsp")
			SetItem(1,"cencos_rsp","")
			SetItem(1,"desc_cencos_rsp","")
			return 1
		END IF
	CASE 'cencos_slc'
		SELECT count(*) INTO :ll_count
		FROM centros_costo
		WHERE cencos = :data ;
		
		IF ll_count > 0 THEN
			
			SELECT desc_cencos
			INTO :ls_descripcion
			FROM centros_costo
			WHERE cencos = :data ;
	
			this.SetItem( row, 'desc_cencos_slc', ls_descripcion)
			this.ii_update = 1
		ELSE
			MessageBox('Aviso','Centro de Costo Solicitante no existe')
			SetColumn("cencos_slc")
			SetItem(1,"cencos_slc","")
			SetItem(1,"desc_cencos_slc","")
			return 1
		END IF
	CASE 'ot_adm'
		SELECT count(*) INTO :ll_count
		FROM ot_administracion
		WHERE ot_adm = :data ;
		
		IF ll_count > 0 THEN
			
			SELECT descripcion
			INTO :ls_descripcion
			FROM ot_administracion
			WHERE ot_adm = :data ;
	
			this.SetItem( row, 'desc_ot_adm', ls_descripcion)
			this.ii_update = 1
		ELSE
			MessageBox('Aviso','OT Adm no existe')
			SetColumn("ot_adm")
			SetItem(1,"ot_adm","")
			SetItem(1,"desc_ot_adm","")
			return 1
		END IF
	CASE 'ot_tipo'
		SELECT count(*) INTO :ll_count
		FROM ot_tipo
		WHERE ot_tipo = :data ;
		
		IF ll_count > 0 THEN
			
			SELECT descripcion
			INTO :ls_descripcion
			FROM ot_tipo
			WHERE ot_tipo = :data ;
	
			this.SetItem( row, 'desc_ot_tipo', ls_descripcion)
			this.ii_update = 1
		ELSE
			MessageBox('Aviso','Tipo OT no existe')
			SetColumn("ot_tipo")
			SetItem(1,"ot_tipo","")
			SetItem(1,"desc_ot_tipo","")
			return 1
		END IF
	
	CASE 'responsable'
		SELECT count(*) INTO :ll_count
		FROM maestro m, proveedor p
		WHERE m.cod_trabajador = p.proveedor and p.flag_estado = '1' and
		m.cod_trabajador = :data ;
		
		IF ll_count > 0 THEN			
			SELECT p.nom_proveedor INTO :ls_descripcion
			FROM maestro m, proveedor p
			WHERE m.cod_trabajador = p.proveedor and p.flag_estado = '1' and
			m.cod_trabajador = :data ;
	
			this.SetItem( row, 'nom_responsable', ls_descripcion)
			this.ii_update = 1
		ELSE
			MessageBox('Aviso','Responsable no existe')
			SetColumn("responsable")
			SetItem(1,"responsable","")
			SetItem(1,"nom_responsable","")
			return 1
		END IF

	CASE 'centro_benef'
		SELECT count(*) 
		  INTO :ll_count
		  FROM centro_beneficio c, 
		  		 centro_benef_usuario cb
		 WHERE c.centro_benef = cb.centro_benef 
		   AND c.flag_estado  = '1' 
			AND c.centro_benef = :data 
			AND cb.cod_usr = :gs_user ; 
		
		IF ll_count = 0 THEN			
			SetNull(ls_null)
			this.object.centro_benef [row] = ls_null
			MessageBox('Aviso','Centro de beneficio no existe')
			SetColumn("centro_benef")
			SetItem(1,"centro_benef","")
			return 1
		END IF
		
		this.ii_update = 1

END CHOOSE

end event

event clicked;call super::clicked;This.BorderStyle = StyleRaised!
idw_1 = THIS
This.BorderStyle = StyleLowered!

end event

event ue_insert_pre;call super::ue_insert_pre;String ls_cencos,ls_tipo


select cencos_almacen into :ls_cencos from logparam where reckey = '1' ;

select ot_tipo_adm into :ls_tipo from prod_param where reckey = '1' ;

dw_master.object.flag_estado  	 [al_row] = '3'      //estado de la ot
dw_master.object.cod_origen   	 [al_row] = gs_origen
dw_master.object.cod_usr      	 [al_row] = gs_user
dw_master.object.fec_registro 	 [al_row] = today()
dw_master.object.fec_inicio   	 [al_row] = today()
dw_master.object.fec_estimada 	 [al_row] = today()
dw_master.object.cencos_rsp		 [al_row] = ls_cencos
dw_master.object.ot_tipo    		 [al_row] = ls_tipo
dw_master.object.flag_programado	 [al_row] = '0'
dw_master.object.flag_estructura  [al_row] = '0'      // Ot simple
dw_master.object.flag_costo_tipo  [al_row] = 'F'		// Costo Fijo
dw_master.object.titulo 			 [al_row] = '?'      // Ot simple

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String 	ls_adm,ls_name,ls_prot, ls_cencos, ls_sql, &
			ls_codigo, ls_data
str_seleccionar lstr_seleccionar


ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then return

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
		END IF
	CASE 'cencos_slc'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT CENCOS 	  AS CENCOS, " &
			 + "DESC_CENCOS AS DESCRIPCION "		&     	
			 + "FROM CENTROS_COSTO " &
			 + "WHERE CENTROS_COSTO.FLAG_ESTADO = '1' "
		
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'cencos_slc',lstr_seleccionar.param1[1])
			Setitem(row,'desc_cencos_slc',lstr_seleccionar.param2[1])
			this.ii_update = 1
		END IF
	
	CASE 'cencos_rsp'
		
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT CENCOS 	  AS CENCOS, " &
			 + "DESC_CENCOS AS DESCRIPCION "		&     	
			 + "FROM CENTROS_COSTO " &
			 + "WHERE CENTROS_COSTO.FLAG_ESTADO = '1' "
		
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'cencos_rsp',lstr_seleccionar.param1[1])
			Setitem(row,'desc_cencos_rsp',lstr_seleccionar.param2[1])
			this.ii_update = 1
		END IF
	
	CASE 'responsable'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT M.COD_TRABAJADOR AS CODIGO, "&
			 + "P.NOM_PROVEEDOR AS NOMBRE " 	&
			 + "FROM MAESTRO M, PROVEEDOR P "					&	
			 + "WHERE M.COD_TRABAJADOR = P.PROVEEDOR AND P.FLAG_ESTADO = '1'"
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'responsable',lstr_seleccionar.param1[1])
			Setitem(row,'nom_responsable',lstr_seleccionar.param2[1])
			this.ii_update = 1
		END IF
	
	CASE 'centro_benef'
		ls_cencos = this.object.cencos_slc[row]
		if ls_cencos = '' or IsNull(ls_cencos) then
			MessageBox('Aviso', 'Debe ingresar un Centro de costo Solicitante')
			return
		end if
		
		ls_sql   = "SELECT distinct a.CENTRO_BENEF AS centro_beneficio, "&
				   + "a.DESC_centro AS DESCRIPCION_centro,u.cod_usr "&
				   + "FROM centro_beneficio a, centro_benef_usuario u " &
				   + "WHERE a.FLAG_ESTADO = '1' " &
					+ "AND A.CENTRO_BENEF = U.CENTRO_BENEF "&
					+ "and u.cod_usr = '" + gs_user + "'"

		f_lista(ls_sql, ls_codigo, ls_data, '1')
		if ls_codigo = '' then return 
		this.object.centro_benef		[row] = ls_codigo
		this.ii_update = 1
		
END CHOOSE
end event

