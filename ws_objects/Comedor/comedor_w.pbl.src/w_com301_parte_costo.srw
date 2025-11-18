$PBExportHeader$w_com301_parte_costo.srw
forward
global type w_com301_parte_costo from w_abc
end type
type dw_text from datawindow within w_com301_parte_costo
end type
type st_campo from statictext within w_com301_parte_costo
end type
type cb_2 from commandbutton within w_com301_parte_costo
end type
type uo_fecha from u_ingreso_rango_fechas within w_com301_parte_costo
end type
type dw_cntas_pagar from u_dw_abc within w_com301_parte_costo
end type
type st_detail from statictext within w_com301_parte_costo
end type
type st_master from statictext within w_com301_parte_costo
end type
type dw_detail from u_dw_abc within w_com301_parte_costo
end type
type dw_master from u_dw_abc within w_com301_parte_costo
end type
type cb_1 from commandbutton within w_com301_parte_costo
end type
type st_1 from statictext within w_com301_parte_costo
end type
type sle_parte from singlelineedit within w_com301_parte_costo
end type
type gb_1 from groupbox within w_com301_parte_costo
end type
type r_1 from rectangle within w_com301_parte_costo
end type
end forward

global type w_com301_parte_costo from w_abc
integer width = 3328
integer height = 1768
string title = "Parte de Costos - Compr. Pago (COM301)"
string menuname = "m_mantto_consulta"
windowstate windowstate = maximized!
event ue_retrieve_cntas_pagar ( )
event ue_open_paste ( )
dw_text dw_text
st_campo st_campo
cb_2 cb_2
uo_fecha uo_fecha
dw_cntas_pagar dw_cntas_pagar
st_detail st_detail
st_master st_master
dw_detail dw_detail
dw_master dw_master
cb_1 cb_1
st_1 st_1
sle_parte sle_parte
gb_1 gb_1
r_1 r_1
end type
global w_com301_parte_costo w_com301_parte_costo

type variables
string is_nro_parte, is_col, is_action
StaticText ist_1

Long			il_st_color, il_nro_parte

		 
// Para el registro del Log
string 	is_tabla_m, is_colname_m[], is_coltype_m[], &
			is_tabla_d, is_colname_d[], is_coltype_d[]
			
n_cst_log_diario	in_log
boolean 				ib_log = true
end variables

forward prototypes
public subroutine of_retrieve (string as_nro_parte)
public function boolean of_nro_parte (string as_origen, ref string as_ult_nro)
public subroutine of_nro_doc (string as_cod_rel, string as_tipo_doc, ref string as_nro_doc, ref decimal adc_total)
public function boolean of_current_nro (ref long al_current_nro)
public function decimal of_total_pagar_doc (string as_cod_rel, string as_tipo_doc, string as_nro_doc, string as_cod_moneda)
public subroutine of_conv_importe ()
end prototypes

event ue_retrieve_cntas_pagar();Date 		ld_fecha1, ld_fecha2
//En este arreglo voy a guardar los documentos que han sido 
//ingresados en el parte diario segun el siguiente formato
//COD_RELACION + TIPO_DOC + NRO_DOC
string	ls_doc_ing[], ls_cod_rel, ls_tipo_doc, ls_nro_doc
Long 		ll_x, ll_index

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

ll_index = 1
for ll_x = 1 to dw_detail.RowCount()
	ls_cod_rel 	= dw_detail.object.cod_relacion	[ll_x]
	ls_tipo_doc	= dw_detail.object.tipo_doc		[ll_x]
	ls_nro_doc	= dw_detail.object.nro_doc			[ll_x]
	
	if ls_cod_rel 	<> '' and not IsNull(ls_cod_rel) and &
		ls_tipo_doc <> '' and not IsNull(ls_tipo_doc) and &
		ls_nro_doc	<> '' and not IsNull(ls_nro_doc) then
		
		ls_doc_ing[ll_index] = ls_cod_rel + ls_tipo_doc + ls_nro_doc
		ll_index ++
		
	end if
next

// En caso de que el array este vacio ingreso aunque sea
// un elemento, teniendo cuidado que no exista 

if UpperBound(ls_doc_ing) = 0 then
	ls_doc_ing[1] = '1x2z3c4v5b6n7m8m9'
end if

dw_cntas_pagar.Retrieve(ld_fecha1, ld_fecha2, ls_doc_ing)
end event

event ue_open_paste();IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(idw_1, is_colname_m, is_coltype_m)
	in_log.of_dw_map(dw_detail, is_colname_d, is_coltype_d)
END IF
end event

public subroutine of_retrieve (string as_nro_parte);dw_master.Retrieve(as_nro_parte)
dw_master.ii_protect = 0
dw_master.of_protect()
dw_master.ii_update = 0

dw_detail.Retrieve(as_nro_parte)
dw_detail.ii_protect = 0
dw_detail.of_protect()
dw_detail.ii_update = 0

end subroutine

public function boolean of_nro_parte (string as_origen, ref string as_ult_nro);String	ls_mensaje

//create or replace function USF_COM_NUM_PARTE_COSTO
//(asi_cod_origen origen.cod_origen%type)
// return varchar2 is

DECLARE USF_COM_NUM_PARTE_COSTO PROCEDURE FOR
	USF_COM_NUM_PARTE_COSTO( :gs_origen );

EXECUTE USF_COM_NUM_PARTE_COSTO;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION USF_COM_NUM_PARTE_COSTO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetNull(as_ult_nro)
	return FALSE
END IF

FETCH USF_COM_NUM_PARTE_COSTO INTO :as_ult_nro;
CLOSE USF_COM_NUM_PARTE_COSTO;

return TRUE
end function

public subroutine of_nro_doc (string as_cod_rel, string as_tipo_doc, ref string as_nro_doc, ref decimal adc_total);Long		ll_count

select Count(*)
	into :ll_count
from cntas_pagar
where cod_relacion = :as_cod_rel
  and tipo_doc		 = :as_tipo_doc;

if ll_count = 1 then
	
	select nro_doc, total_pagar
		into :as_nro_doc, :adc_total
	from cntas_pagar
	where cod_relacion = :as_cod_rel
	  and tipo_doc		 = :as_tipo_doc;

else
	
	SetNull(as_nro_doc)
	SetNull(adc_total)
	
end if



end subroutine

public function boolean of_current_nro (ref long al_current_nro);String	ls_mensaje

//create or replace function USF_COM_CUR_NRO_PARTE_COSTO
//(asi_cod_origen origen.cod_origen%type)
// return number is

DECLARE USF_COM_CUR_NRO_PARTE_COSTO PROCEDURE FOR
	USF_COM_CUR_NRO_PARTE_COSTO( :gs_origen );

EXECUTE USF_COM_CUR_NRO_PARTE_COSTO;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION USF_COM_CUR_NRO_PARTE_COSTO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetNull(al_current_nro)
	return FALSE
END IF

FETCH USF_COM_CUR_NRO_PARTE_COSTO INTO :al_current_nro;
CLOSE USF_COM_CUR_NRO_PARTE_COSTO;

return TRUE

end function

public function decimal of_total_pagar_doc (string as_cod_rel, string as_tipo_doc, string as_nro_doc, string as_cod_moneda);decimal	ldc_total
string	ls_mon_comp
Date		ld_fecha

ldc_total = 0
select Total_pagar, cod_moneda, Trunc(fecha_emision)
	into :ldc_total, :ls_mon_comp, :ld_fecha
from cntas_pagar
where cod_relacion 	= :as_cod_rel
  and tipo_doc		 	= :as_tipo_doc
  and nro_doc			= :as_nro_doc;

if IsNull(ldc_total) then ldc_total = 0

select usf_fl_conv_mon( :ldc_total, :ls_mon_comp, :as_cod_moneda, :ld_fecha)
	into :ldc_total
from dual;

f_commit(SQLCA)

return ldc_total

end function

public subroutine of_conv_importe ();long 		ll_row, ll_i
decimal	ldc_importe
string	ls_mon_parte, ls_mon_doc
date		ld_fec_emi

ll_row = dw_master.GetRow()
if ll_row <= 0 then return

if dw_detail.RowCount() = 0 then return

dw_master.AcceptText()

ls_mon_parte = dw_master.object.cod_moneda[ll_row]
if ls_mon_parte = '' or IsNull(ls_mon_parte) then return

If MessageBox('Aviso', 'HA CAMBIADO DE TIPO DE MONEDA, ¿DESEA QUE EL PROGRAMA LE RECALCULE LOS IMPORTE?' &
		+ "~r~nSI ELIGE <NO> NO SE PREOCUPE EL SISTEMA LOS RECALCULARA DE INMEDIATO LA " &
		+ "PROXIMA VEZ QUE HABRA ESTE PARTE DIARIO", Information!, YesNo!, 2) = 2 then

	return
	
end if

this.SetRedraw(false)
for ll_i = 1 to dw_detail.RowCount()
	ldc_importe = dec(dw_detail.object.imp_original		[ll_i])
	ls_mon_doc  = dw_detail.object.mon_original			[ll_i]
	ld_fec_emi	= Date(dw_detail.object.fecha_emision	[ll_i])
	
	select usf_fl_conv_mon(:ldc_importe, :ls_mon_doc, :ls_mon_parte, :ld_fec_emi) 
		into :ldc_importe
	from dual;
	
	if IsNull(ldc_importe) then ldc_importe = 0
	
	dw_detail.object.total_pagar[ll_i] = ldc_importe
next
this.SetRedraw(true)

end subroutine

on w_com301_parte_costo.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.dw_text=create dw_text
this.st_campo=create st_campo
this.cb_2=create cb_2
this.uo_fecha=create uo_fecha
this.dw_cntas_pagar=create dw_cntas_pagar
this.st_detail=create st_detail
this.st_master=create st_master
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_parte=create sle_parte
this.gb_1=create gb_1
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_text
this.Control[iCurrent+2]=this.st_campo
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.dw_cntas_pagar
this.Control[iCurrent+6]=this.st_detail
this.Control[iCurrent+7]=this.st_master
this.Control[iCurrent+8]=this.dw_detail
this.Control[iCurrent+9]=this.dw_master
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.sle_parte
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.r_1
end on

on w_com301_parte_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_text)
destroy(this.st_campo)
destroy(this.cb_2)
destroy(this.uo_fecha)
destroy(this.dw_cntas_pagar)
destroy(this.st_detail)
destroy(this.st_master)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_parte)
destroy(this.gb_1)
destroy(this.r_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)
dw_cntas_pagar.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
ist_1 = st_master
il_st_color = st_master.backcolor

ib_log = TRUE
is_tabla_m = 'COM_COMPR_PAGO'
is_tabla_d = 'COM_COMPR_PAGO_DET'

of_current_nro(il_nro_parte)

f_commit(SQLCA)

if IsNull(il_nro_parte) then il_nro_parte = 0

//il_nro_parte ++

idw_1.Setfocus()
end event

event ue_insert;call super::ue_insert;Long  	ll_row
string	ls_nro_parte

if idw_1 = dw_master THEN
    dw_master.Reset()
end if

CHOOSE CASE idw_1
	CASE dw_master
		TriggerEvent('ue_update_request')
		dw_master.Reset()
		dw_detail.Reset()
		
	CASE ELSE
		
		ll_row = dw_master.GetRow()
		
		if ll_row <= 0 then
			MessageBox('COMEDORES', 'NO EXISTE CABECERA DEL PARTE, POR FAVOR VERIFIQUE',StopSign!)
			return
		end if
		
		ls_nro_parte = Trim(dw_master.object.nro_parte[ll_row])
		if ls_nro_parte = '' or IsNull(ls_nro_parte) then
			MessageBox('COMEDORES', 'NO ESTA DEFINIDO NUMERO DEL PARTE, POR FAVOR VERIFIQUE',StopSign!)
			return
		end if

END CHOOSE

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event resize;call super::resize;This.SetRedraw(false)

st_master.x = dw_master.X
st_master.width = dw_master.width

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
st_detail.x = dw_detail.X
st_detail.width = dw_detail.width

dw_cntas_pagar.width  = newwidth  - dw_cntas_pagar.x - 10
gb_1.width  = newwidth  - gb_1.x - 10


This.SetRedraw(true)
end event

event ue_update_pre;Long 		ll_row_det, ll_row_mas
Boolean	lb_ret
string	ls_cod_rel, ls_tipo_doc, ls_nro_doc
dwItemStatus ldis_status

ib_update_check = TRUE
dw_master.AcceptText()
dw_detail.AcceptText()

If dw_master.RowCount() = 0 then
	return
end if

if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
end if

FOR ll_row_det = 1 TO dw_detail.Rowcount()
	//asignar nro de parte cuando registro sea nuevo
	ls_tipo_doc	= dw_detail.object.tipo_doc[ll_row_det]
	ls_cod_rel	= dw_detail.object.cod_relacion[ll_row_det]
	ls_nro_doc	= dw_detail.object.nro_doc[ll_row_det]
	
	if ls_cod_rel = '' or IsNull(ls_cod_rel) then
		MessageBox('COMEDORES', 'CODIGO DE RELACION ESTA EN BLANCO',StopSign!)
		dw_detail.SetRow( ll_row_det )
		f_select_current_row( dw_detail )
		dw_detail.SetColumn( "cod_relacion" )
		ib_update_check = False	
		return 
	end if

	if ls_tipo_doc = '' or IsNull(ls_tipo_doc) then
		MessageBox('COMEDORES', 'TIPO DE DOCUMENTO ESTA EN BLANCO',StopSign!)
		dw_detail.SetRow( ll_row_det )
		f_select_current_row( dw_detail )
		dw_detail.SetColumn( "tipo_doc" )		
		ib_update_check = False	
		return 
	end if

	if ls_nro_doc = '' or IsNull(ls_nro_doc) then
		MessageBox('COMEDORES', 'NUMERO DE DOCUMENTO ESTA EN BLANCO',StopSign!)
		dw_detail.SetRow( ll_row_det )
		f_select_current_row( dw_detail )
		dw_detail.SetColumn( "nro_doc" )
		ib_update_check = False	
		return 
	end if

NEXT

//Colocar Numeradores
ll_row_mas = dw_master.GetRow()
if ll_row_mas <= 0 then 
	ib_update_check = FALSE
	return
end if

is_nro_parte 	= dw_master.object.nro_parte[ll_row_mas]
ldis_status 	= dw_master.GetItemStatus(ll_row_mas, 0, Primary!)
IF ldis_status = NewModified! THEN
	lb_ret = this.of_nro_parte( gs_origen, is_nro_parte )
	if lb_ret = TRUE then
		dw_master.object.nro_parte[ll_row_mas] = is_nro_parte
	else
		ib_update_check = FALSE
		return
	end if
end if

FOR ll_row_det = 1 TO dw_detail.Rowcount()
	//asignar nro de parte cuando registro sea nuevo
	ldis_status = dw_detail.GetItemStatus(ll_row_det, 0, Primary!)
   IF ldis_status = NewModified! THEN
		dw_detail.object.nro_parte[ll_row_det] = is_nro_parte
   END IF
NEXT

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

// Grabo el Log de la Cabecera
IF ib_log THEN
	u_ds_base		lds_log
	lds_log = Create u_ds_base
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log, is_colname_m, is_coltype_m, gs_user, is_tabla_m)
END IF

// Grabo el Log de detalle de parte de costos
IF ib_log THEN
	u_ds_base		lds_log_d
	lds_log_d = Create u_ds_base
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_d.SetTransObject(SQLCA)
	in_log.of_create_log(dw_detail, lds_log_d, is_colname_d, is_coltype_d, gs_user, is_tabla_d)
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log_d
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	This.Event Dynamic ue_retrieve_cntas_pagar()
END IF

of_current_nro(il_nro_parte)

f_commit(SQLCA)

if IsNull(il_nro_parte) then il_nro_parte = 0

//il_nro_parte ++


end event

event ue_modify;call super::ue_modify;idw_1.of_protect()
end event

event ue_query_retrieve;// Ancestor Script has been Override
This.of_retrieve( is_nro_parte )
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
sg_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'ds_parte_costos_grid'
sl_param.titulo = "Parte Diario de Comprobantes"
sl_param.field_ret_i[1] = 1

sl_param.tipo    = '1SQL'
sl_param.string1 =  " AND COM_COMPR_PAGO.ORIGEN = '"+ gs_origen + "'" 

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	is_nro_parte = sl_param.field_ret[1]
	This.of_retrieve (is_nro_parte)	
END IF
end event

event ue_update_request;Integer li_msg_result

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

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(idw_1, is_colname_m, is_coltype_m)
	in_log.of_dw_map(dw_detail, is_colname_d, is_coltype_d)
END IF
end event

event ue_close_pre;call super::ue_close_pre;If ib_log THEN
	DESTROY n_cst_log_diario
End If
end event

event ue_anular;call super::ue_anular;Long ll_row

IF dw_master.GetRow() = 0 THEN RETURN

IF MessageBox('Aviso', 'Deseas anular El Parte Diario de Comedores', Information!, YesNo!, 2) = 2 THEN RETURN

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso', 'EL Parte de Raciones ya esta anulada, no puedes anularla')
	RETURN
END IF

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

dw_master.object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1

is_action = 'anular'


end event

type dw_text from datawindow within w_com301_parte_costo
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 2226
integer y = 176
integer width = 1042
integer height = 72
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;dw_cntas_pagar.triggerevent(doubleclicked!)
return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_cntas_pagar.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_cntas_pagar.scrollnextrow()	
end if
ll_row = dw_text.Getrow()
end event

event constructor;Long ll_reg
ll_reg = this.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer 	li_longitud
string 	ls_item, ls_ordenado_por, ls_comando
Long 		ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_cntas_pagar.find(ls_comando, 1, dw_cntas_pagar.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_cntas_pagar.selectrow(0, false)
			dw_cntas_pagar.selectrow(ll_fila,true)
			dw_cntas_pagar.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)

end event

type st_campo from statictext within w_com301_parte_costo
integer x = 1403
integer y = 180
integer width = 791
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "CAMPO:"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_com301_parte_costo
integer x = 2930
integer y = 52
integer width = 274
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "buscar"
end type

event clicked;parent.event dynamic ue_retrieve_cntas_pagar()
end event

type uo_fecha from u_ingreso_rango_fechas within w_com301_parte_costo
integer x = 1417
integer y = 56
integer taborder = 30
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999')) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
	+ '/' + string(li_ano, '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )


end event

type dw_cntas_pagar from u_dw_abc within w_com301_parte_costo
integer x = 1399
integer y = 256
integer width = 1865
integer height = 460
integer taborder = 40
string dragicon = "H:\Source\ICO\row.ico"
string dataobject = "d_cntas_pagar_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF

end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event clicked;call super::clicked;if this.RowCount() > 0 then
	This.Drag(Begin!)
else
	This.Drag(Cancel!)
end if
end event

event dragleave;call super::dragleave;if source = dw_cntas_pagar then
	source.DragIcon = "Error!"
end if
end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col 		= dw_cntas_pagar.GetColumn()
ls_column 	= THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	st_campo.text = "Parte: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

type st_detail from statictext within w_com301_parte_costo
integer y = 716
integer width = 3264
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Detalles de los comprobantes de Pago"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_master from statictext within w_com301_parte_costo
integer y = 116
integer width = 1390
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Cabecera del Parte de Costo"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_detail from u_dw_abc within w_com301_parte_costo
event ue_display ( string as_columna,  long al_row )
integer y = 796
integer width = 3264
integer height = 736
integer taborder = 40
string dataobject = "d_parte_costos_detalle_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cod_rel, ls_nro_doc, ls_tipo_doc, &
			ls_mon_parte
decimal	ldc_total
Long		ll_count, ll_row_mas
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "COD_RELACION"
		
		ls_sql = "SELECT COD_RELACION AS CODIGO, " &
				  + "NOMBRE AS DESCRIPCION " &
				  + "FROM VW_COM_COD_RELACION " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_relacion	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			SetNull(ls_tipo_doc)
			this.object.tipo_doc			[al_row] = ls_tipo_doc
			this.object.nro_doc			[al_row]	= ls_tipo_doc
			
			SetNull(ls_nro_doc)
			this.object.nro_doc			[al_row]	= ls_nro_doc
			
			ldc_total = 0
			this.object.total_pagar		[al_row] = ldc_total
			
			this.ii_update = 1
		end if

	case "TIPO_DOC"
		
		ls_cod_rel = this.object.cod_relacion[al_row]
		if ls_cod_rel = '' or IsNUll(ls_cod_rel) then
			MessageBox('COMEDORES', 'NO ESTA DEFINIDO EL CODIGO DE RELACION',StopSign!)
			return
		end if
		
		ls_sql = "SELECT TIPO_DOC AS CODIGO, " &
				  + "DESC_TIPO_DOC AS DESCRIPCION " &
				  + "FROM VW_COM_TIPO_DOC " &
				  + "WHERE COD_RELACION = '" + ls_cod_rel + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc			[al_row] = ls_codigo
			this.object.desc_tipo_doc	[al_row] = ls_data
			
			of_nro_doc(ls_cod_rel, ls_codigo, ls_nro_doc, ldc_total )
			this.object.nro_doc			[al_row] = ls_nro_doc
			this.object.total_pagar		[al_row]	= ldc_total
			
			this.ii_update = 1
			
		end if
		
	Case "NRO_DOC"
		ls_cod_rel = this.object.cod_relacion[al_row]
		if ls_cod_rel = '' or IsNUll(ls_cod_rel) then
			MessageBox('COMEDORES', 'NO ESTA DEFINIDO EL CODIGO DE RELACION',StopSign!)
			return
		end if
		
		ls_tipo_doc = this.object.tipo_doc[al_row]
		if ls_tipo_doc = '' or IsNUll(ls_tipo_doc) then
			MessageBox('COMEDORES', 'NO ESTA DEFINIDO EL TIPO DE DOCUMENTO',StopSign!)
			return
		end if
		
		ll_row_mas = dw_master.GetRow()
		if ll_row_mas <= 0 then return
		
		ls_mon_parte = dw_master.object.cod_moneda[ll_row_mas]
		if ls_mon_parte = '' or IsNUll(ls_mon_parte) then
			MessageBox('COMEDORES', 'CODIGO DE MONEDA NO ESTA DEFINIDO',StopSign!)
			return
		end if
		
		ls_sql = "SELECT TIPO_DOC AS CODIGO, " 	&
			  	 + "DESC_TIPO_DOC AS DESCRIPCION, " &
				 + "NRO_DOC AS NUMERO_DOCUMENTO, " 	&
				 + "TO_CHAR(FECHA_REGISTRO, 'dd/mm/yyyy') AS FEC_REGISTRO, " &
				 + "TO_CHAR(FECHA_EMISION, 'dd/mm/yyyy') AS FEC_EMISION " 	&
				 + "FROM vw_com_cntas_pagar " &
				 + "WHERE COD_RELACION = '" + ls_cod_rel + "' " &
				 + "AND TIPO_DOC = '" + ls_tipo_doc + "'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, &
					ls_data, ls_nro_doc, '1')
		
		if ls_codigo <> '' then
			this.object.nro_doc			[al_row] = ls_nro_doc
			
			ldc_total = of_total_pagar_doc( ls_cod_rel, ls_tipo_doc, ls_nro_doc, ls_mon_parte )
			this.object.total_pagar		[al_row]	= ldc_total
			
			this.ii_update = 1
			
		end if
		
end choose

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_detail
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true
end event

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF

end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event itemerror;call super::itemerror;return 1
end event

event doubleclicked;call super::doubleclicked;string ls_columna
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

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
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

event dragenter;call super::dragenter;if source = dw_cntas_pagar then
	source.DragIcon = "H:\Source\ICO\row.ico"
end if
end event

event dragdrop;call super::dragdrop;string 	ls_cod_rel, ls_tipo_doc, ls_nro_doc, ls_nro_parte, &
			ls_mon_parte, ls_mon_comp
long 		ll_row_cnt, ll_row_find, ll_row, ll_row_mas
Date		ld_fec_emision
Decimal	ldc_total_pagar
u_dw_abc	ldw_1

ll_row_mas = dw_master.GetRow()
if ll_row_mas <= 0 then
	MessageBox('COMEDORES', 'NO SE HA DENIFIDO LA CABECERA DEL PARTE, POR FAVOR VERIFIQUE',StopSign!)
	return
end if

ls_nro_parte = dw_master.object.nro_parte[ll_row_mas]
if ls_nro_parte = '' or IsNull(ls_nro_parte) then
	MessageBox('COMEDORES', 'NO SE HA DENIFIDO NUMERO DEL PARTE, POR FAVOR VERIFIQUE',StopSign!)
	return
end if

ls_mon_parte = dw_master.object.cod_moneda[ll_row_mas]
if ls_mon_parte = '' or IsNull(ls_mon_parte) then
	MessageBox('COMEDORES', 'NO SE HA DENIFIDO CODIGO DE MONEDA EN EL PARTE, POR FAVOR VERIFIQUE',StopSign!)
	return
end if

if source = dw_cntas_pagar then
	ll_row_cnt = dw_cntas_pagar.GetRow()
	if ll_row_cnt = 0 then return
	
	ls_cod_rel			= dw_cntas_pagar.object.cod_relacion	[ll_row_cnt]
	ls_tipo_doc			= dw_cntas_pagar.object.tipo_doc			[ll_row_cnt]
	ls_nro_doc			= dw_cntas_pagar.object.nro_doc			[ll_row_cnt]	
	ld_fec_emision 	= Date(dw_cntas_pagar.object.fecha_emision	[ll_row_cnt])
	ls_mon_comp			= dw_cntas_pagar.object.cod_moneda		[ll_row_cnt]	
	
	ll_row_find = This.Find("cod_relacion = '" &
		+ ls_cod_rel + "' and tipo_doc = '" + ls_tipo_doc &
		+ "' and nro_doc = '" + ls_nro_doc + "'", 1, 	  &
		This.RowCount() )
	
	if ll_row_find = 0 then
		ll_row = This.event ue_insert()
		This.ii_protect = 0
		This.of_protect()
		
		// Asignar a dw_cntas_pagar
		ldw_1	 = source
		if ll_row > 0 then
			ldc_total_pagar	= ldw_1.object.total_pagar		[ll_row_cnt]	
			
			this.object.cod_relacion	[ll_row] = ldw_1.object.cod_relacion	[ll_row_cnt]
			this.object.nom_proveedor	[ll_row] = ldw_1.object.nom_proveedor	[ll_row_cnt]
			this.object.tipo_doc			[ll_row] = ldw_1.object.tipo_doc			[ll_row_cnt]
			this.object.desc_tipo_doc	[ll_row] = ldw_1.object.desc_tipo_doc	[ll_row_cnt]
			this.object.nro_doc			[ll_row] = ldw_1.object.nro_doc			[ll_row_cnt]	
			this.object.imp_original	[ll_row] = ldc_total_pagar
			this.object.mon_original	[ll_row] = ls_mon_comp
			
			select usf_fl_conv_mon( :ldc_total_pagar, :ls_mon_comp, :ls_mon_parte, :ld_fec_emision )
				into :ldc_total_pagar
			from dual;
			
			this.object.total_pagar		[ll_row]	= ldc_total_pagar
			
		end if
	else
		MessageBox('COMEDORES', 'COMPROBANTE DE PAGO YA HA SIDO INGRESADO, POR FAVOR VERIFIQUE',StopSign!)
		This.SetRow(ll_row_find)
		f_select_current_row(This)
		return
	end if
end if
end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_cod_rel, ls_nro_doc, ls_tipo_doc, ls_mon_parte
decimal	ldc_total
date		ld_fec_emision
Long 		ll_count, ll_row_mas

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	case "COD_RELACION"
		
		ls_codigo = this.object.cod_relacion[row]

		SetNull(ls_data)
		select nombre
			into :ls_data
		from vw_com_cod_relacion
		where cod_relacion = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "CODIGO DE RELACION NO EXISTE O NO TIENE NINGUNA CUENTA PENDIENTE DE PAGO", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_relacion	[row] = ls_codigo
			this.object.nom_proveedor	[row] = ls_codigo
			return 1
		end if

		this.object.nom_proveedor		[row] = ls_data

	case "TIPO_DOC"
		
		ls_cod_rel 	= this.object.cod_relacion	[row]
		if ls_cod_rel = '' or IsNUll(ls_cod_rel) then
			MessageBox('COMEDORES', 'NO ESTA DEFINIDO EL CODIGO DE RELACION',StopSign!)
			return
		end if
		
		ls_tipo_doc	= this.object.tipo_doc		[row]
		
		SetNull(ls_data)
		select desc_tipo_doc
			into :ls_data
		from VW_COM_TIPO_DOC
		where cod_relacion = :ls_cod_rel
		  and tipo_doc		 = :ls_tipo_doc;
		  
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "TIPO DE DOCUMENTO NO EXISTE O NO PERTENECE A UNA CUENTA PENDIENTE DE PAGO", StopSign!)
			SetNull(ls_tipo_doc)
			this.object.tipo_doc			[row] = ls_tipo_doc
			this.object.desc_tipo_doc	[row] = ls_tipo_doc
			return 1
		end if

		this.object.desc_tipo_doc		[row] = ls_data
		
		of_nro_doc(ls_cod_rel, ls_tipo_doc, ls_nro_doc, ldc_total )
		this.object.nro_doc			[row] = ls_nro_doc
		this.object.total_pagar		[row]	= ldc_total
		
	Case "NRO_DOC"
		ls_cod_rel = this.object.cod_relacion[row]
		if ls_cod_rel = '' or IsNUll(ls_cod_rel) then
			MessageBox('COMEDORES', 'NO ESTA DEFINIDO EL CODIGO DE RELACION',StopSign!)
			return
		end if
		
		ls_tipo_doc = this.object.tipo_doc[row]
		if ls_tipo_doc = '' or IsNUll(ls_tipo_doc) then
			MessageBox('COMEDORES', 'NO ESTA DEFINIDO EL TIPO DE DOCUMENTO',StopSign!)
			return
		end if
		
		ll_row_mas = dw_master.GetRow()
		if ll_row_mas <= 0 then return
		
		ls_mon_parte = dw_master.object.cod_moneda[ll_row_mas]
		if ls_mon_parte = '' or IsNUll(ls_mon_parte) then
			MessageBox('COMEDORES', 'CODIGO DE MONEDA NO ESTA DEFINIDO',StopSign!)
			return
		end if

		
		ls_nro_doc	= this.object.nro_doc[row]
		
		select count(*)
			into :ll_count
		from vw_com_full_cntas_pagar
		where cod_relacion = :ls_cod_rel
		  and tipo_doc		 = :ls_tipo_doc
		  and nro_doc		 = :ls_nro_doc;
			
		if ll_count = 0 then
			Messagebox('COMEDORES', "NUMERO DE DOCUMENTO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_nro_doc)
			this.object.nro_doc		[row] = ls_nro_doc
			ldc_total = 0
			this.object.total_pagar	[row] = ldc_total
			return 1
		end if
		
		ldc_total = of_total_pagar_doc( ls_cod_rel, ls_tipo_doc, ls_nro_doc, ls_mon_parte )
		this.object.total_pagar		[row]	= ldc_total
		
end choose



end event

event ue_insert;call super::ue_insert;this.setColumn("cod_relacion")
return this.GetRow()
end event

type dw_master from u_dw_abc within w_com301_parte_costo
event ue_display ( string as_columna,  long al_row )
integer y = 196
integer width = 1390
integer height = 512
integer taborder = 30
string dataobject = "d_parte_costos_ff"
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "COD_MONEDA"
		
		ls_sql = "SELECT COD_MONEDA AS CODIGO, " &
				  + "DESCRIPCION AS DESCR_MONEDA " &
				  + "FROM MONEDA " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.object.desc_moneda	[al_row] = ls_data
			parent.of_conv_importe( )
			this.ii_update = 1
			
		end if
		
end choose

end event

event doubleclicked;call super::doubleclicked;string ls_columna
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

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
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

event ue_insert_pre;call super::ue_insert_pre;string 	ls_desc_origen, ls_nro_parte
Date 		ld_fecha

select nombre
	into :ls_desc_origen
from origen
where cod_origen = :gs_origen;

ld_fecha = Today()
ls_nro_parte	= gs_origen + string(il_nro_parte, '00000000')
//il_nro_parte ++

this.object.nro_parte		[al_row]	= ls_nro_parte
this.object.origen			[al_row] = gs_origen
this.object.nom_origen		[al_row] = ls_desc_origen
this.object.fecha_registro [al_row] = f_fecha_actual()
this.object.fecha_parte 	[al_row] = f_fecha_actual()
this.object.flag_estado		[al_row] = '1'

dw_detail.Reset()
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_master
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true

end event

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data
this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	case "COD_MONEDA"
		
		ls_codigo = this.object.cod_moneda[row]

		SetNull(ls_data)
		select descripcion
			into :ls_data
		from moneda
		where cod_moneda = :ls_codigo;

		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "CODIGO DE MONEDA NO EXISTE", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_moneda	[row] = ls_codigo
			this.object.desc_moneda	[row] = ls_codigo
			return 1
		end if

		this.object.desc_moneda[row] = ls_data
		parent.of_conv_importe( )
		
end choose
end event

event ue_delete;// Ancestor Script has been Override
long ll_row 

ib_insert_mode = False

dw_detail.event ue_delete_all( )

ll_row = THIS.DeleteRow (0)
IF ll_row = -1 then
	messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
ELSE
	il_totdel ++
	ii_update = 1								// indicador de actualizacion pendiente
	//THIS.Event Post ue_delete_pos()
END IF

RETURN ll_row
end event

event ue_insert;// Ancestor Script has been Override
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
END IF

RETURN ll_row
end event

type cb_1 from commandbutton within w_com301_parte_costo
integer x = 727
integer y = 20
integer width = 306
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;is_nro_parte = sle_parte.text

parent.of_retrieve (is_nro_parte)	

end event

type st_1 from statictext within w_com301_parte_costo
integer x = 46
integer y = 32
integer width = 306
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Parte :"
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type sle_parte from singlelineedit within w_com301_parte_costo
event ue_tecla pbm_keydown
integer x = 361
integer y = 20
integer width = 357
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;IF key = KeyEnter! THEN
	cb_1.triggerevent(clicked!)
END IF
end event

type gb_1 from groupbox within w_com301_parte_costo
integer x = 1399
integer y = 4
integer width = 1865
integer height = 168
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Comprobantes de Pago"
end type

type r_1 from rectangle within w_com301_parte_costo
integer linethickness = 1
long fillcolor = 12632256
integer y = 12
integer width = 1390
integer height = 100
end type

