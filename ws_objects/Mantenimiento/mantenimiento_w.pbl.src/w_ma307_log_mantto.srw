$PBExportHeader$w_ma307_log_mantto.srw
forward
global type w_ma307_log_mantto from w_abc
end type
type cb_1 from commandbutton within w_ma307_log_mantto
end type
type st_1 from statictext within w_ma307_log_mantto
end type
type sle_parte from singlelineedit within w_ma307_log_mantto
end type
type tab_1 from tab within w_ma307_log_mantto
end type
type tabpage_1 from userobject within tab_1
end type
type dw_material from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_material dw_material
end type
type tabpage_3 from userobject within tab_1
end type
type dw_trabajadores from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_trabajadores dw_trabajadores
end type
type tabpage_2 from userobject within tab_1
end type
type dw_servicios from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_servicios dw_servicios
end type
type tab_1 from tab within w_ma307_log_mantto
tabpage_1 tabpage_1
tabpage_3 tabpage_3
tabpage_2 tabpage_2
end type
type dw_master from u_dw_abc within w_ma307_log_mantto
end type
type gb_1 from groupbox within w_ma307_log_mantto
end type
end forward

global type w_ma307_log_mantto from w_abc
integer width = 3794
integer height = 2752
string title = "[MA307] Bitácora de mantenimiento"
string menuname = "m_abc_master_list"
boolean resizable = false
cb_1 cb_1
st_1 st_1
sle_parte sle_parte
tab_1 tab_1
dw_master dw_master
gb_1 gb_1
end type
global w_ma307_log_mantto w_ma307_log_mantto

type variables
boolean	ib_log = TRUE
u_dw_abc	idw_material, idw_trabajadores, idw_servicios

end variables

forward prototypes
public subroutine wf_insert_art_mov (string as_tipo_doc, string as_nro_doc, long al_oper_sec, long al_item)
public function boolean wf_nro_doc (ref long al_nro_ot, ref string as_mensaje)
public subroutine wf_retrieve_operaciones (string as_tipo_doc, string as_nro_doc, string as_cod_labor, string as_cod_ejecutor)
public subroutine wf_filter_dws (long al_item)
public subroutine of_asigna_dws ()
public subroutine of_retrieve (string as_nro_parte)
public function integer of_set_numera ()
public function decimal of_get_costo_promedio (string as_cod_art, string as_almacen)
public function decimal of_get_costo_mo (string as_cod_trabajador, date ad_fecha_inicio)
public function decimal of_total_horas (datetime adt_hora_inicio, datetime adt_hora_fin)
end prototypes

public subroutine wf_insert_art_mov (string as_tipo_doc, string as_nro_doc, long al_oper_sec, long al_item);//String      ls_cod_art,ls_nom_art,ls_und
//Decimal {2} ldc_costo_ult_compra
//Decimal {4} ldc_cantidad
//Long			ll_row
//
///*Declaración de Cursor*/
//DECLARE art_ope CURSOR FOR
//  SELECT am.cod_art         ,
// 			am.cant_proyect    , 
//			a.nom_articulo	    ,
//			a.und				    ,
//			a.costo_ult_compra
//  	 FROM articulo_mov_proy am,	
//			articulo          a
//	WHERE  (am.cod_art  = a.cod_art    ) AND		
//			((am.tipo_doc = :as_tipo_doc ) AND
//			 (am.nro_doc  = :as_nro_doc  ) AND
//			 (am.oper_sec = :al_oper_sec )) ;
//					
//
///*Abrir Cursor*/		  	
//OPEN art_ope ;
//
//	
//	DO 				/*Recorro Cursor*/	
//	 FETCH art_ope INTO :ls_cod_art,:ldc_cantidad,:ls_nom_art,:ls_und,:ldc_costo_ult_compra;
//	 IF sqlca.sqlcode = 100 THEN EXIT
//	 /**Inserción de Registros**/ 
//	 ll_row = tab_1.tabpage_1.dw_detart.InsertRow(0)
//	 
//	 tab_1.tabpage_1.dw_detart.ii_update = 1
//	 tab_1.tabpage_1.dw_detart.object.nro_item	  [ll_row] = al_item
//	 tab_1.tabpage_1.dw_detart.object.cod_art      [ll_row] = ls_cod_art
//	 tab_1.tabpage_1.dw_detart.object.cantidad     [ll_row] = ldc_cantidad
//	 tab_1.tabpage_1.dw_detart.object.nom_articulo [ll_row] = ls_nom_art
//	 tab_1.tabpage_1.dw_detart.object.costo_insumo [ll_row] = ldc_costo_ult_compra
//	 tab_1.tabpage_1.dw_detart.object.und			  [ll_row] = ls_und
//	 
//	 
//	LOOP WHILE TRUE
//	
//CLOSE art_ope ; /*Cierra Cursor*/
end subroutine

public function boolean wf_nro_doc (ref long al_nro_ot, ref string as_mensaje);Boolean lb_retorno =TRUE
Long ll_nro_ot
String ls_lock_table

ls_lock_table = 'LOCK TABLE NUM_PD_OT IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;

SELECT ult_nro
  INTO :al_nro_ot
  FROM num_pd_ot
 WHERE (reckey = '1') ;

	
	
IF Isnull(al_nro_ot) OR al_nro_ot = 0 THEN
	lb_retorno = FALSE
	as_mensaje = 'Numerador Para Parte Diario de OT debe Empezar en 1 Verifique Tabla de Numeración NUM_PD_OT '
	GOTO SALIDA
END IF

//****************************//
//Actualiza Tabla num_doc_tipo//
//****************************//
	
UPDATE num_pd_ot
	SET ult_nro = :al_nro_ot + 1
 WHERE (reckey = '1') ;
	
IF SQLCA.SQLCode = -1 THEN 
	as_mensaje = 'No se Pudo Actualizar Tabla num_pd_ot , Verifique!'
	lb_retorno = FALSE
	GOTO SALIDA
END IF	


SALIDA:

Return lb_retorno

end function

public subroutine wf_retrieve_operaciones (string as_tipo_doc, string as_nro_doc, string as_cod_labor, string as_cod_ejecutor);
IF Isnull(as_cod_labor) OR Trim(as_cod_labor) = '' THEN
	IF Isnull(as_nro_doc) then 
		Setnull(as_cod_labor)
	ELSE
		as_cod_labor = '%'
	END IF
ELSE
	as_cod_labor = as_cod_labor + '%'
END IF

IF Isnull(as_cod_ejecutor) OR Trim(as_cod_ejecutor) = '' THEN
	IF Isnull(as_nro_doc) then 
		Setnull(as_cod_ejecutor)
	ELSE
		as_cod_ejecutor = '%'
	END IF

ELSE
	as_cod_ejecutor = as_cod_ejecutor + '%'
END IF


//dw_operaciones.Retrieve(as_tipo_doc,as_nro_doc,as_cod_labor,as_cod_ejecutor)

end subroutine

public subroutine wf_filter_dws (long al_item);//String ls_expresion
//	
//
//ls_expresion = 'nro_item = '+Trim(String(al_item))
//
//IF Not(Isnull(ls_expresion) OR Trim(ls_expresion) = '') THEN
//	tab_1.tabpage_1.dw_detart.Setfilter(ls_expresion)
//	tab_1.tabpage_2.dw_detinc.Setfilter(ls_expresion)
//	tab_1.tabpage_3.dw_detasis.Setfilter(ls_expresion)
//	tab_1.tabpage_4.dw_causas.Setfilter(ls_expresion)
//	
//	tab_1.tabpage_1.dw_detart.filter ()
//	tab_1.tabpage_2.dw_detinc.filter ()
//	tab_1.tabpage_3.dw_detasis.filter()
//	tab_1.tabpage_4.dw_causas.filter ()
//END IF
//
end subroutine

public subroutine of_asigna_dws ();idw_material 		= tab_1.tabpage_1.dw_material
idw_trabajadores 	= tab_1.tabpage_3.dw_trabajadores
idw_servicios		= tab_1.tabpage_2.dw_servicios
end subroutine

public subroutine of_retrieve (string as_nro_parte);/*****************************************/
/*      Recuperacion de Información      */
/*****************************************/
dw_master.Retrieve(as_nro_parte)
idw_material.Retrieve(as_nro_parte)
idw_trabajadores.Retrieve(as_nro_parte)
idw_servicios.Retrieve(as_nro_parte)

dw_master.ii_update = 0
idw_material.ii_update = 0
idw_trabajadores.ii_update = 0
idw_servicios.ii_update = 0

dw_master.ResetUpdate()
idw_material.ResetUpdate()
idw_trabajadores.ResetUpdate()
idw_servicios.ResetUpdate()


dw_master.ii_protect = 0
idw_material.ii_protect = 0
idw_trabajadores.ii_protect = 0
idw_servicios.ii_protect = 0

dw_master.of_protect()
idw_material.of_protect()
idw_trabajadores.of_protect()
idw_servicios.of_protect()


is_Action = "fileopen"



end subroutine

public function integer of_set_numera (); 
//Numera documento
Long 		ll_ult_nro, ll_i
string	ls_mensaje, ls_nro, ls_tabla

if is_action = 'new' then
	
	ls_tabla = dw_master.Object.Datawindow.Table.UpdateTable
	
	if ls_tabla = '' or Isnull(ls_tabla) then
		MessageBox('Error', 'No ha especificado una tabla a actualizar para el datawindows maestro, por favor verifique!')
		return 0
	end if
	
	Select ult_nro 
		into :ll_ult_nro 
	from num_tablas 
	where origen = :gs_origen
	  and tabla	 = :ls_tabla for update;
	
	IF SQLCA.SQLCode = 100 then
		ll_ult_nro = 1
		
		Insert into num_tablas (origen, tabla, ult_nro)
			values( :gs_origen, :ls_tabla, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error al insertar registro en num_tablas', ls_mensaje)
			return 0
		end if
	end if
	
	//Asigna numero a cabecera
	ls_nro = TRIM(gs_origen) + trim(string(ll_ult_nro, '00000000'))
	
	dw_master.object.nro_parte[dw_master.getrow()] = ls_nro
	
	//Incrementa contador
	Update num_tablas 
		set ult_nro = :ll_ult_nro + 1 
	 where origen = :gs_origen
	  and tabla	 = :ls_tabla;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al actualizar num_tablas', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_parte[dw_master.getrow()] 
end if


for ll_i = 1 to idw_material.RowCount() 
	idw_material.object.nro_parte [ll_i] = ls_nro
next

for ll_i = 1 to idw_trabajadores.RowCount() 
	idw_trabajadores.object.nro_parte [ll_i] = ls_nro
next

for ll_i = 1 to idw_servicios.RowCount() 
	idw_servicios.object.nro_parte [ll_i] = ls_nro
next

return 1
end function

public function decimal of_get_costo_promedio (string as_cod_art, string as_almacen);decimal	ldc_costo_promedio

select COSTO_PROM_SOL
	into :ldc_costo_promedio
from articulo_almacen aa
where aa.cod_art 	= :as_cod_art
  and aa.almacen	= :as_almacen;

if ISNull(ldc_costo_promedio) then ldc_costo_promedio = 0

return ldc_costo_promedio
end function

public function decimal of_get_costo_mo (string as_cod_trabajador, date ad_fecha_inicio);decimal ldc_costo_hora, ldc_vacaciones, ldc_cts, ldc_gratificacion

select nvl(sum(imp_gan_desc), 0)
	into :ldc_costo_hora
from gan_desct_fijo
where cod_trabajador = :as_cod_trabajador
  and concep like '1%';

//Obtengo el costo por hora
ldc_costo_hora = ldc_costo_hora / 240

//Al costo por hora le sumo las vacaciones
ldc_vacaciones = ldc_costo_hora / 12

//Costo de Gratificacio
ldc_gratificacion = ldc_costo_hora / 6

if string(ad_fecha_inicio, 'yyyy') <= '2014' then
	//Calculo la bonificación del 9%
	ldc_gratificacion += ldc_gratificacion * 0.09
end if

//Calculo del CTS
ldc_cts = (ldc_costo_hora + ldc_gratificacion) / 12

return (ldc_costo_hora + ldc_vacaciones + ldc_gratificacion + ldc_cts)
end function

public function decimal of_total_horas (datetime adt_hora_inicio, datetime adt_hora_fin);decimal ldc_horas

select :adt_hora_fin - :adt_hora_inicio
	into :ldc_horas
from dual;

if IsNull(ldc_horas) then ldc_horas = 0

ldc_horas = ldc_horas * 24 // transformación de días a horas

return ldc_horas
end function

on w_ma307_log_mantto.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_list" then this.MenuID = create m_abc_master_list
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_parte=create sle_parte
this.tab_1=create tab_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_parte
this.Control[iCurrent+4]=this.tab_1
this.Control[iCurrent+5]=this.dw_master
this.Control[iCurrent+6]=this.gb_1
end on

on w_ma307_log_mantto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_parte)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;String ls_nro_parte
of_asigna_dws()

dw_master.SetTransObject(sqlca)
idw_material.SetTransObject(sqlca)
idw_trabajadores.SetTransObject(sqlca)
idw_servicios.SetTransObject(sqlca)


idw_1 = dw_master              				// asignar dw corriente
dw_master.setFocus()

of_position_window(0,0)       			// Posicionar la ventana en forma fija

/********************************/
/*Recuperacion de Ultimo Numero */
/********************************/
SELECT nro_parte
  INTO :ls_nro_parte
  FROM MTTO_PD
order by fec_registro desc;
 
IF Isnull(ls_nro_parte) THEN
	this.event ue_insert( )
ELSE
	//wf_retrieve (ll_nro_parte)	
END IF
 
 
ib_log = TRUE

end event

event resize;call super::resize;of_asigna_dws()
tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

dw_master.height  = newheight - dw_master.y   - 10
dw_master.width	= newwidth - dw_master.x   - 10

idw_material.height  = tab_1.tabpage_1.height - idw_material.y   - 10
idw_material.width	= tab_1.tabpage_1.width - idw_material.x   - 10

idw_trabajadores.height	= tab_1.tabpage_3.height - idw_trabajadores.y   - 10
idw_trabajadores.width	= tab_1.tabpage_3.width - idw_trabajadores.x   - 10

idw_servicios.height	= tab_1.tabpage_2.height - idw_servicios.y   - 10
idw_servicios.width	= tab_1.tabpage_2.width - idw_servicios.x   - 10

end event

event ue_insert;Long  ll_row

CHOOSE CASE idw_1
	CASE dw_master
		this.event ue_update_request( )
		is_action = 'new'
		dw_master.Reset()
		idw_material.Reset()
		idw_trabajadores.Reset()
		idw_servicios.Reset()
		
		dw_master.ii_update = 0
		idw_material.ii_update = 0
		idw_trabajadores.ii_update = 0
		idw_servicios.ii_update = 0
		
		dw_master.ResetUpdate()
		idw_material.ResetUpdate()
		idw_trabajadores.ResetUpdate()
		idw_servicios.ResetUpdate()
				
END CHOOSE

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_update_pre;
ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return
if gnvo_app.of_row_Processing( idw_material ) <> true then return
if gnvo_app.of_row_Processing( idw_trabajadores ) <> true then return
if gnvo_app.of_row_Processing( idw_servicios ) <> true then return

if idw_trabajadores.rowcount() = 0 and idw_servicios.RowCount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta indicar detalle de trabajo")
	return
end if

//of_set_total_oc()
if of_set_numera() = 0 then return	

dw_master.of_set_flag_replicacion()
idw_material.of_set_flag_replicacion()
idw_trabajadores.of_set_flag_replicacion()
idw_servicios.of_set_flag_replicacion()

ib_update_check = true
end event

event ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 			OR idw_material.ii_update = 1 OR &
	 idw_trabajadores.ii_update  = 1 OR idw_servicios.ii_update = 1 ) THEN
	 
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Hay cambios sin grabar, desea Grabalos ?", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
//	ELSE
//		dw_master.ii_update = 0
//		idw_material.ii_update  = 0
//		idw_trabajadores.ii_update  = 0
//		idw_servicios.ii_update  = 0
//		
//		dw_master.ResetUpdate()
//		idw_material.ResetUpdate()
//		idw_trabajadores.ResetUpdate()
//		idw_servicios.ResetUpdate()
	END IF
END IF
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
Long    ll_row_det_old,ll_item_old

dw_master.AcceptText()
idw_material.AcceptText()
idw_trabajadores.AcceptText()
idw_servicios.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN
	Rollback;
	RETURN
END IF

IF ib_log THEN
	dw_master.of_create_log()
	idw_material.of_create_log()
	idw_trabajadores.of_create_log()
	idw_servicios.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_material.ii_update = 1 and lbo_ok THEN
	IF idw_material.Update(true, false) = -1 then //Grabación de Detalle de Pd_ot
		lbo_ok = FALSE
		Messagebox("Error en Grabación Detalle de Material","Se ha procedido al rollback",exclamation!)		 
	END IF
END IF

IF idw_trabajadores.ii_update = 1 and lbo_ok THEN
	IF idw_trabajadores.Update(true, false) = -1 then // Grabación de Articulo
		lbo_ok = FALSE
		Messagebox("Error en Grabación Detalle de Trabajadores","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_servicios.ii_update = 1 and lbo_ok THEN
	IF idw_servicios.Update(true, false) = -1 then // Grabación de Incidencias
		lbo_ok = FALSE
		Messagebox("Error en Grabación Detalle de Servicios","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log ()
		lbo_ok = idw_material.of_save_log ()
		lbo_ok = idw_trabajadores.of_save_log ()
		lbo_ok = idw_servicios.of_save_log ()
	end if
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	
	dw_master.ii_update = 0
	idw_material.ii_update  = 0
	idw_trabajadores.ii_update = 0
	idw_servicios.ii_update  = 0
	
	dw_master.ResetUpdate()
	idw_material.ResetUpdate()
	idw_trabajadores.ResetUpdate()
	idw_servicios.ResetUpdate()
	
	if dw_master.RowCount() > 0 then
		of_retrieve(dw_master.object.nro_parte[1])
	end if
	
	f_mensaje("Cambios han sido grabados satisfactoriamente", "")

ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

this.event ue_update_request()

sl_param.dw1    = "d_abc_lista_pd_mantto_tbl"
sl_param.titulo = "Partes Diario de Mantenimiento"
sl_param.field_ret_i[1] = 1


OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	of_retrieve (sl_param.field_ret[1])	
END IF

end event

event ue_modify;if dw_master.GetRow() = 0 then return

if dw_master.object.flag_estado [dw_master.getRow()] <> '1' then
	MessageBox('Error', 'El Parte de mantenimiento no se encuentra activo para modificaciones, por favor verifique!')
	
	dw_master.ii_protect = 0
	idw_material.ii_protect = 0
	idw_trabajadores.ii_protect = 0
	idw_servicios.ii_protect = 0

	dw_master.of_protect()
	idw_material.of_protect()
	idw_trabajadores.of_protect()
	idw_servicios.of_protect()

	
	return
end if

dw_master.of_protect()
idw_material.of_protect()
idw_trabajadores.of_protect()
idw_servicios.of_protect()


end event

event ue_delete();//OVERRIDE
Long  ll_row


IF idw_1 = dw_master OR Isnull(idw_1)THEN 
	Return
END IF


ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_anular;call super::ue_anular;// Verifica que exista el detalle
IF dw_master.rowcount() = 0 then return
if idw_material.rowcount() = 0 then return
if idw_trabajadores.rowcount() = 0 then return
if idw_servicios.rowcount() = 0 then return

if dw_master.ii_update = 1 or idw_material.ii_update = 1 or &
	idw_trabajadores.ii_update = 1 or idw_servicios.ii_update = 1 then
	
	MEssageBox('Aviso', 'Existen cambios pendientes de grabación, por favor grabe antes de anular')
	return
end if

if MessageBox('Aviso', 'Deseas anular este parte de mantenimiento?', Information!, YesNo!, 2) = 2 then return

if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then
	MessageBox('Aviso', 'No puede anular esta Parte por no encontrarse activo')
	RETURN
end if

is_action = 'anu'
// Anulando Cabecera
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1


end event

type cb_1 from commandbutton within w_ma307_log_mantto
integer x = 837
integer y = 68
integer width = 343
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;if sle_parte.text = '' then
	MessageBox("Error", "Debe indicar el numero de parte de mantenimiento", StopSign!)
	sle_parte.setFocus()
	return
end if

of_retrieve (sle_parte.text)	

end event

type st_1 from statictext within w_ma307_log_mantto
integer x = 37
integer y = 68
integer width = 329
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parte diario:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_parte from singlelineedit within w_ma307_log_mantto
integer x = 389
integer y = 68
integer width = 439
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type tab_1 from tab within w_ma307_log_mantto
integer y = 908
integer width = 3657
integer height = 1364
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
tabpage_3 tabpage_3
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_3=create tabpage_3
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_3,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_3)
destroy(this.tabpage_2)
end on

event selectionchanged;//Long ll_row, ll_nro_parte, ll_item
//
//ll_row = tab_1.tabpage_1.dw_detail.Getrow()
//
//IF ll_row = 0 THEN RETURN
//
//ll_nro_parte = tab_1.tabpage_1.dw_detail.object.nro_parte [ll_row]
//ll_item = tab_1.tabpage_1.dw_detail.object.nro_item [ll_row]
//
//wf_filter_dws (ll_item)
//
//
//CHOOSE CASE newindex
//		 CASE 1
//				if oldindex = 3 then
//					setmicrohelp('tab1')	
//			   end if
//END CHOOSE
//
//
////tab_1.tabpage_2.dw_detinc.Retrieve( ll_nro_parte, ll_item )
//
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3621
integer height = 1244
long backcolor = 79741120
string text = "Material"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_material dw_material
end type

on tabpage_1.create
this.dw_material=create dw_material
this.Control[]={this.dw_material}
end on

on tabpage_1.destroy
destroy(this.dw_material)
end on

type dw_material from u_dw_abc within tabpage_1
integer width = 3616
integer height = 1108
integer taborder = 50
string dataobject = "d_abc_mtto_pd_mat_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'			// 'm' = master sin detalle (default), 'd' =  detalle,
	            			// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2


end event

event itemchanged;call super::itemchanged;String ls_data, ls_cod_art, ls_und, ls_almacen

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_art'
		
		// Verifica que codigo ingresado exista			
		Select desc_art, und
	     into :ls_data, :ls_und
		  from articulo
		 Where cod_art = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_art	[row] = gnvo_app.is_null
			this.object.desc_art	[row] = gnvo_app.is_null
			this.object.und		[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Artículo no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_art	[row] = ls_data
		this.object.und		[row] = ls_und
		
		ls_almacen = this.object.almacen [row]
		
		if ls_almacen <> '' and not IsNull(ls_almacen) then
			this.object.precio_unit	[row] = of_get_costo_promedio(data, ls_almacen)
		end if

	CASE 'almacen'
		
		ls_cod_art = this.object.cod_art [row]
		
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			this.object.almacen	[row] = gnvo_app.is_null
			MessageBox('Error', 'Debe Ingresar primero un código de Articulo, por favor verifique!')
			this.SetColumn('cod_art')
			return 1
		end if
		
		// Verifica que codigo ingresado exista			
		Select desc_almacen
	     into :ls_data
		  from almacen
		 Where almacen = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.almacen	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de Almacen no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.precio_unit	[row] = of_get_costo_promedio(ls_Cod_art, data)

END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 		[al_row] = this.of_nro_item( )
this.object.cantidad 		[al_row] = 0.0000
this.object.fec_registro	[al_row] = gnvo_app.of_fecha_Actual()
this.object.cod_usr			[al_row] = gs_user
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_und, ls_cod_art, ls_almacen, ls_nro_vale, ls_cod_origen
Long		ll_nro_mov
Decimal	ldc_precio_unit

choose case lower(as_columna)
	case "cod_art"
		ls_sql = "SELECT cod_art AS codigo_articulo, " &
				  + "desc_art AS descripcion_articulo, " &
				  + "und as unidad " &
				  + "FROM articulo a " &
				  + "WHERE a.FLAG_ESTADO = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_und, '2')

		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.object.und		[al_row] = ls_und
			this.ii_update = 1
			
			ls_almacen = this.object.almacen [al_row]
			
			if ls_almacen <> '' and not IsNull(ls_almacen) then
				this.object.precio_unit	[al_row] = of_get_costo_promedio(ls_codigo, ls_codigo)
			end if
		end if

	case "almacen"
		
		ls_cod_art = this.object.cod_art [al_row]
		
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			MessageBox('Error', 'Debe Ingresar primero un codigo de articulo', StopSign!)
			this.SetColumn('cod_art')
			return
		end if
		
		ls_sql = "SELECT almacen AS codigo_almacen, " &
				  + "desc_almacen AS descripcion_almacen " &
				  + "FROM almacen a " &
				  + "WHERE a.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.almacen		[al_row] = ls_codigo
			this.object.precio_unit	[al_row] = of_get_costo_promedio(ls_Cod_art, ls_codigo)
			
			this.ii_update = 1
		end if	

	case "nro_vale"
		
		ls_cod_art = this.object.cod_art [al_row]
		
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			MessageBox('Error', 'Debe Ingresar primero un codigo de articulo, por favor verifique!', StopSign!)
			this.SetColumn('cod_art')
			return
		end if
		
		ls_almacen = this.object.almacen [al_row]
		
		if ls_almacen = '' or IsNull(ls_almacen) then
			MessageBox('Error', 'Debe Ingresar un almacen primero, por favor verifique!', StopSign!)
			this.SetColumn('almacen')
			return
		end if
		
		ls_sql = "select vm.nro_vale as numero_vale, " &
				 + "am.cod_origen as cod_origen, " &
				 + "am.nro_mov as nro_mov, " &
				 + "vm.fec_registro as fecha_registro, " &
				 + "am.cant_procesada as cantidad_despachada, " &
				 + "am.precio_unit as precio_unit " &
				 + "from vale_mov vm, " &
				 + "     articulo_mov am " &
				 + "where vm.nro_vale = am.nro_vale " &
				 + "  and vm.tipo_mov = 'S01' " &
				 + "  and vm.almacen  = '" + ls_almacen + "' " &
				 + "  and am.cod_art	 = '" + ls_cod_Art + "' " &
				 + "order by vm.fec_registro desc "

		lb_ret = f_lista_3ret(ls_sql, ls_nro_Vale, ls_cod_origen, ls_data, '2')

		if ls_nro_Vale <> '' then
			ll_nro_mov = Long(ls_data)
			
			select precio_unit
				into :ldc_precio_unit
			from articulo_mov
			where cod_origen 	= :ls_cod_origen
			  and nro_mov		= :ll_nro_mov;
			
			this.object.nro_vale		[al_row] = ls_nro_vale
			this.object.org_am		[al_row] = ls_cod_origen
			this.object.nro_am		[al_row] = ll_nro_mov
			this.object.precio_unit	[al_row] = ldc_precio_unit
			
			this.ii_update = 1
		end if		
end choose
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3621
integer height = 1244
long backcolor = 79741120
string text = "Trabajadores"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_trabajadores dw_trabajadores
end type

on tabpage_3.create
this.dw_trabajadores=create dw_trabajadores
this.Control[]={this.dw_trabajadores}
end on

on tabpage_3.destroy
destroy(this.dw_trabajadores)
end on

type dw_trabajadores from u_dw_abc within tabpage_3
integer y = 12
integer width = 3584
integer height = 1224
integer taborder = 20
string dataobject = "d_abc_pd_ot_asistencia_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2


end event

event itemchanged;call super::itemchanged;String 	ls_data, ls_cod_trabajador
Date		ld_fecha_inicio
datetime	ldt_inicio, ldt_fin

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_trabajador'
		
		// Verifica que codigo ingresado exista			
		Select nom_trabajador
	     into :ls_data
		  from vw_pr_trabajador
		 Where cod_trabajador = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_trabajador	[row] = gnvo_app.is_null
			this.object.nom_trabajador	[row] = gnvo_app.is_null
			this.object.costo_hora		[row] = 0
			MessageBox('Error', 'Codigo de Trabajador no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		ld_fecha_inicio = Date(this.object.hora_inicio [row])

		this.object.nom_trabajador	[row] = ls_data
		this.object.costo_hora		[row] = of_get_costo_mo(data, ld_fecha_inicio)

	CASE 'hora_inicio'
		
		// Verifica que codigo ingresado exista			
		ls_cod_trabajador = this.object.cod_trabajador [row]
		
		if ls_cod_trabajador = '' or IsNull(ls_cod_trabajador) then
			MessageBox('Error', 'Debe especificar primero un codigo de trabajador, por favor verifique!')
			this.SetColumn('cod_trabajador')
			return 1
		end if
		
		ld_fecha_inicio = date(this.object.hora_inicio [row])
		this.object.costo_hora		[row] = of_get_costo_mo(ls_cod_trabajador, ld_fecha_inicio)	
		
		ldt_inicio 	= dateTime(this.object.hora_inicio 	[row])
		ldt_fin		= dateTime(this.object.hora_fin 		[row])
		
		this.object.horas [row] = of_total_horas(ldt_inicio, ldt_fin)

	CASE 'hora_fin'
		
		// Verifica que codigo ingresado exista			
		ls_cod_trabajador = this.object.cod_trabajador [row]
		
		if ls_cod_trabajador = '' or IsNull(ls_cod_trabajador) then
			MessageBox('Error', 'Debe especificar primero un codigo de trabajador, por favor verifique!')
			this.SetColumn('cod_trabajador')
			return 1
		end if
		
		ldt_inicio 	= dateTime(this.object.hora_inicio 	[row])
		ldt_fin		= dateTime(this.object.hora_fin 		[row])
		
		this.object.horas [row] = of_total_horas(ldt_inicio, ldt_fin)		

END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;DateTime ldt_fecha1, ldt_fecha2

ldt_fecha1 = DateTime(Date(dw_master.object.fec_parte [dw_master.getRow()]), now() )

select :ldt_fecha1 + 8/24
  into :ldt_fecha2
  from dual;

this.object.nro_item 	[al_row] = this.of_nro_item( )
this.object.hora_inicio	[al_row] = ldt_fecha1
this.object.hora_fin		[al_row] = ldt_fecha2
this.object.horas			[al_row] = 8
this.object.costo_hora	[al_row] = 8
this.object.fec_registro[al_row] = gnvo_app.of_fecha_actual()
this.object.cod_usr		[al_row] = gs_user

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
date		ld_fecha_inicio

choose case lower(as_columna)
	case "cod_trabajador"
		ls_sql = "SELECT cod_trabajador AS codigo_trabajador, " &
				  + "nom_trabajador AS nombre_trabajador " &
				  + "FROM vw_pr_trabajador " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_trabajador	[al_row] = ls_codigo
			this.object.nom_trabajador	[al_row] = ls_data
			
			ld_fecha_inicio = date(this.object.hora_inicio [al_row])
			this.object.costo_hora [al_row] = of_get_costo_mo(ls_codigo, ld_fecha_inicio)
			this.ii_update = 1
		end if
		
end choose
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3621
integer height = 1244
long backcolor = 79741120
string text = "Servicios de Terceros"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_servicios dw_servicios
end type

on tabpage_2.create
this.dw_servicios=create dw_servicios
this.Control[]={this.dw_servicios}
end on

on tabpage_2.destroy
destroy(this.dw_servicios)
end on

type dw_servicios from u_dw_abc within tabpage_2
integer width = 3072
integer height = 920
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_mantto_pd_serv_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

end event

event itemchanged;call super::itemchanged;String 	ls_org_os, ls_proveedor, ls_nom_proveedor, ls_ruc_dni
decimal 	ldc_monto_total

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'nro_os'
		
		// Verifica que codigo ingresado exista			
		select os.cod_origen, os.proveedor, p.nom_proveedor, decode(p.ruc, null, p.nro_doc_ident, p.ruc), os.monto_total
				into :ls_org_os, :ls_proveedor, :ls_nom_proveedor, :ls_ruc_dni, :ldc_monto_total
			from 	orden_servicio os,
     				proveedor      p
			where os.proveedor = p.proveedor     
			  and os.nro_os	 = :data
			  and os.flag_estado <> '0';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.nro_os			[row] = gnvo_app.is_null
			this.object.org_os			[row] = gnvo_app.is_null
			this.object.proveedor		[row] = gnvo_app.is_null
			this.object.nom_proveedor	[row] = gnvo_app.is_null
			this.object.ruc_dni			[row] = gnvo_app.is_null
			this.object.monto_total		[row] = 0.00
			this.object.porc_avance		[row] = 0.00
			
			MessageBox('Error', 'Numero de Orden de Servicio no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.org_os			[row] = ls_org_os
		this.object.proveedor		[row] = ls_proveedor
		this.object.nom_proveedor	[row] = ls_nom_proveedor
		this.object.ruc_dni			[row] = ls_ruc_dni
		this.object.monto_total		[row] = ldc_monto_total
		this.object.porc_avance		[row] = 100


END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item [al_row] = this.of_nro_item( )

this.object.fec_registro	[al_row] = gnvo_app.of_fecha_Actual()
this.object.fec_incidencia	[al_row] = DateTime(date(dw_master.object.fec_parte [dw_master.getRow()]), Now())
this.object.cod_usr			[al_row] = gs_user
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_org_os, ls_proveedor, ls_nom_proveedor, ls_ruc_dni
decimal	ldc_monto_total

choose case lower(as_columna)
	case "nro_os"
		ls_sql = "select os.nro_os as numero_os, " &
				 + "os.fec_registro as fecha_registro, " &
				 + "os.descripcion as descripcion_os, " &
				 + "os.proveedor as codigo_proveedor, " &
				 + "p.nom_proveedor as razon_social, " &
				 + "decode(p.ruc, null, p.nro_doc_ident, p.ruc) as ruc_dni, " &
				 + "os.monto_total as monto_total " &
				 + "from orden_servicio os, " &
				 + "     proveedor      p " &
				 + "where os.proveedor = p.proveedor " &
				 + "order by os.fec_registro desc"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.nro_os	[al_row] = ls_codigo
			
			select os.cod_origen, os.proveedor, p.nom_proveedor, decode(p.ruc, null, p.nro_doc_ident, p.ruc), os.monto_total
				into :ls_org_os, :ls_proveedor, :ls_nom_proveedor, :ls_ruc_dni, :ldc_monto_total
			from 	orden_servicio os,
     				proveedor      p
			where os.proveedor = p.proveedor     
			  and os.nro_os	 = :ls_codigo;
			
			this.object.org_os			[al_row] = ls_org_os
			this.object.proveedor		[al_row] = ls_proveedor
			this.object.nom_proveedor	[al_row] = ls_nom_proveedor
			this.object.ruc_dni			[al_row] = ls_ruc_dni
			this.object.monto_total		[al_row] = ldc_monto_total
			this.object.porc_avance		[al_row] = 0.00
			
			this.ii_update = 1
		end if
		
end choose
end event

type dw_master from u_dw_abc within w_ma307_log_mantto
integer y = 172
integer width = 3465
integer height = 716
string dataobject = "d_abc_mtto_pd_ff"
end type

event constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master						 // dw_master

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;DateTime	ldt_now

ldt_now = gnvo_app.of_fecha_actual( )

This.Object.cod_origen 		[al_row] = gs_origen
This.Object.fec_registro 	[al_row] = ldt_now
This.Object.fec_parte 		[al_row] = Date(ldt_now)
This.Object.flag_estado		[al_row] = '1'
This.Object.cod_usr			[al_row] = gs_user

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cod_maquina"
		ls_sql = "SELECT cod_maquina AS codigo_maquina, " &
				  + "desc_maq AS descripcion_maquina " &
				  + "FROM maquina m " &
				  + "WHERE m.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_maquina	[al_row] = ls_codigo
			this.object.desc_maq		[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "supervisor"
		ls_sql = "SELECT cod_trabajador AS codigo_trabajador, " &
				  + "nom_trabajador AS nombre_trabajador " &
				  + "FROM vw_pr_trabajador m " &
				  + "WHERE m.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.supervisor		[al_row] = ls_codigo
			this.object.nom_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "tipo_incidencia"
		ls_sql = "SELECT tipo_incidencia AS tipo_incidencia, " &
				  + "desc_incidencia AS descripcion_incidencia " &
				  + "FROM mtto_tipo_incidencia m " &
				  + "WHERE m.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_incidencia	[al_row] = ls_codigo
			this.object.desc_incidencia	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "nro_orden"
		ls_sql = "select ot.nro_orden as numero_ot, " &
				 + "ot.fec_inicio as fecha_inicio, " &
				 + "ot.titulo as titulo_ot " &
				 + "from orden_trabajo ot, " &
			    + "     ot_adm_usuario otu " &
				 + "where ot.ot_adm = otu.ot_adm " &
				 + "  and otu.cod_usr = '" + gs_user + "' " &
				 + "  and ot.flag_estado = '1' "

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.nro_orden	[al_row] = ls_codigo
			this.ii_update = 1
		end if

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

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_maquina'
		
		// Verifica que codigo ingresado exista			
		Select desc_maq
	     into :ls_data
		  from maquina
		 Where cod_maquina = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_maquina	[row] = gnvo_app.is_null
			this.object.desc_maq		[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Maquina no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_maq			[row] = ls_data

	CASE 'tipo_incidencia'
		
		// Verifica que codigo ingresado exista			
		Select desc_incidencia
	     into :ls_data
		  from mtto_tipo_incidencia
		 Where tipo_incidencia = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.tipo_incidencia	[row] = gnvo_app.is_null
			this.object.desc_incidencia	[row] = gnvo_app.is_null
			MessageBox('Error', 'Tipo de incidencia no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_incidencia			[row] = ls_data

	CASE 'supervisor'
		
		// Verifica que codigo ingresado exista			
		Select nom_trabajador
	     into :ls_data
		  from vw_pr_trabajador
		 Where cod_trabajador = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.supervisor		[row] = gnvo_app.is_null
			this.object.nom_trabajador	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de trabajador no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.nom_trabajador			[row] = ls_data

	CASE 'nro_orden'
		
		// Verifica que codigo ingresado exista			
		select ot.titulo 
			into :ls_data
		from 	orden_trabajo ot, 
				ot_adm_usuario otu 
		where ot.ot_adm = otu.ot_adm 
		  and otu.cod_usr = :gs_user
		  and ot.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.nro_orden		[row] = gnvo_app.is_null
			MessageBox('Error', 'Numero de OT no existe o no esta activo o tiene acceso a la OT_ADM, por favor verifique')
			return 1
		end if

END CHOOSE
end event

type gb_1 from groupbox within w_ma307_log_mantto
integer width = 1230
integer height = 164
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

