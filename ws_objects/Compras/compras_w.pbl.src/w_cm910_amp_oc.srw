$PBExportHeader$w_cm910_amp_oc.srw
forward
global type w_cm910_amp_oc from w_report_smpl
end type
type cbx_solo_mayor from checkbox within w_cm910_amp_oc
end type
type cb_lectura from commandbutton within w_cm910_amp_oc
end type
end forward

global type w_cm910_amp_oc from w_report_smpl
integer width = 1723
integer height = 1520
string title = "Relacion AMP con OC (CM910)"
string menuname = "m_impresion"
long backcolor = 12632256
event ue_proceso ( )
event ue_update ( )
event ue_borrado ( )
event ue_dividir ( )
cbx_solo_mayor cbx_solo_mayor
cb_lectura cb_lectura
end type
global w_cm910_amp_oc w_cm910_amp_oc

type variables
String is_doc_ot, is_doc_oc
Datastore	ids_oc
end variables

forward prototypes
public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc)
end prototypes

event ue_proceso();IF cbx_solo_mayor.checked THEN RETURN

Long		ll_rc, ll_x, ll_msg_result
String	ls_origen
Decimal	ldc_nro

ll_msg_result = MessageBox("Asignacion Referencias", "Procedemos a Referenciar ?", Question!, YesNo!, 1)
IF ll_msg_result = 1 THEN
	FOR ll_x	= 1 TO idw_1.Rowcount()
		ls_origen = idw_1.GetItemString(ll_x, 'cod_origen')
		ldc_nro   = idw_1.GetItemDecimal(ll_x, 'nro_mov')
		ll_rc = idw_1.SetItem(ll_x, 'oc_org_amp_ref', ls_origen)
		ll_rc = idw_1.SetItem(ll_x, 'oc_nro_amp_ref', ldc_nro)
	NEXT
END IF

MessageBox('Proceso Concluido','Fin de Proceso')
end event

event ue_update();Long		ll_rc, ll_x, ll_msg_result
String	ls_origen, ls_org_oc
Decimal	ldc_nro, ldc_nro_oc
DebugBreak()
ll_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
IF ll_msg_result = 1 THEN
	FOR ll_x	= 1 TO idw_1.Rowcount()
		ls_org_oc  = idw_1.GetItemString(ll_x, 'oc_cod_origen')
		ldc_nro_oc = idw_1.GetItemDecimal(ll_x, 'oc_nro_mov')
		ls_origen  = idw_1.GetItemString(ll_x, 'oc_org_amp_ref')
		ldc_nro    = idw_1.GetItemDecimal(ll_x, 'oc_nro_amp_ref')
	
		UPDATE ARTICULO_MOV_PROY
	   	SET ORG_AMP_REF = :ls_origen,
		   	 NRO_AMP_REF = :ldc_nro
	 	 WHERE COD_ORIGEN  = :ls_org_oc and
	          NRO_MOV     = :ldc_nro_oc ;
			 
		IF SQLCA.SQLCODE <> 0 THEN EXIT		 
	NEXT

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox(SQLCA.SQLErrText, 'Error al Momento de Grabar')
		ROLLBACK ;
	ELSE
		COMMIT ;
		MessageBox('AVISO DE CONFIRMACION', 'Proceso Terminado')
	END IF
END IF
end event

event ue_borrado();IF cbx_solo_mayor.checked THEN RETURN

Long		ll_rc, ll_x, ll_msg_result
String	ls_origen, ls_org_oc
Decimal	ldc_nro, ldc_nro_oc

ll_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
IF ll_msg_result = 1 THEN
	FOR ll_x	= 1 TO idw_1.Rowcount()
		ls_org_oc  = idw_1.GetItemString(ll_x, 'oc_cod_origen')
		ldc_nro_oc = idw_1.GetItemDecimal(ll_x, 'oc_nro_mov')

		UPDATE ARTICULO_MOV_PROY
	   	SET ORG_AMP_REF = NULL,
		   	 NRO_AMP_REF = NULL
	 	 WHERE COD_ORIGEN  = :ls_org_oc and
	          NRO_MOV     = :ldc_nro_oc ;
			 
		IF SQLCA.SQLCODE <> 0 THEN EXIT		 
	NEXT

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox(SQLCA.SQLErrText, 'Error al Momento de Grabar')
		ROLLBACK ;
	ELSE
		COMMIT ;
		MessageBox('AVISO DE CONFIRMACION', 'Proceso Terminado')
		THIS.EVENT ue_retrieve()
	END IF
END IF
end event

event ue_dividir();IF cbx_solo_mayor.checked = FALSE THEN RETURN

Long		ll_rc, ll_x, ll_oc, ll_msg_result, ll_row, ll_source, ll_y, ll_nro_col
String	ls_oper_sec, ls_cod_art, ls_null, ls_almacen
Decimal	ldc_cant_req, ldc_sum_oc, ldc_difer, ldc_ing_alm, ldc_null, ldc_reg_pd
Any  		la_id

ll_msg_result = MessageBox("Dividir OC", "Procedemos a Dividir ?", Question!, YesNo!, 1)

SetNull(ls_null)
SetNull(ldc_null)
ll_nro_col = Long(ids_oc.Object.DataWindow.Column.Count)

IF ll_msg_result = 1 THEN
	FOR ll_x	= 1 TO idw_1.Rowcount()
		ls_oper_sec  = idw_1.GetItemString(ll_x, 'oper_sec')
		ls_cod_art   = idw_1.GetItemString(ll_x, 'cod_art')
		ls_almacen   = idw_1.GetItemString(ll_x, 'almacen')
		ldc_cant_req = idw_1.GetItemDecimal(ll_x, 'cant_proyect')
		ldc_sum_oc   = idw_1.GetItemDecimal(ll_x, 'oc_cnt_pry')
		ldc_difer    = ldc_sum_oc - ldc_cant_req
		ll_oc = ids_oc.Retrieve(is_doc_oc, ls_oper_sec, ls_cod_art, ls_almacen) // Lectura de OC Detalle
		IF ll_oc = 1 THEN // Solamente los Requerimientos con un solo OC Detalle
			//DebugBreak()
			ll_row = ids_oc.InsertRow(0) // Duplicar fila
			ll_source = ll_oc
			FOR ll_y = 1 TO ll_nro_col // Duplicar Campos
				 la_id = ids_oc.object.data.primary.current[ll_source, ll_y]
				 ids_oc.SetItem(ll_row, ll_y, la_id)
			NEXT
			// Corregir OC Detalle Original
			ldc_ing_alm = ids_oc.GetItemDecimal(ll_source, 'cant_procesada')
			ldc_reg_pd = ids_oc.GetItemDecimal(ll_source, 'cant_parte_diario')
			ll_rc = ids_oc.SetItem( ll_source,'cant_proyect',ldc_cant_req)
			IF ldc_ing_alm > ldc_cant_req THEN // Correccion Cant Procesada en Almacen
				ll_rc = ids_oc.SetItem( ll_source,'cant_procesada',ldc_cant_req)
			END IF
			IF ldc_reg_pd > ldc_cant_req THEN // Correccion Cant Parte Diario
				ll_rc = ids_oc.SetItem( ll_source,'cant_parte_diario',ldc_cant_req)
			END IF
			// Corregir OC Detalle Duplicado
			ll_rc = ids_oc.SetItem( ll_row,'cant_proyect',ldc_difer)
			IF ldc_ing_alm > ldc_cant_req THEN // Correccion Cant Procesada en Almacen
				ll_rc = ids_oc.SetItem( ll_row,'cant_procesada',ldc_ing_alm - ldc_cant_req)
			END IF
			IF ldc_reg_pd > ldc_cant_req THEN // Correccion Cant Parte Diario
				ll_rc = ids_oc.SetItem( ll_row,'cant_parte_diario',ldc_reg_pd - ldc_cant_req)
			END IF
			ids_oc.Object.org_amp_ref[ll_row] = ls_null
			ids_oc.Object.nro_amp_ref[ll_row] = ldc_null
			ids_oc.Object.oper_sec[ll_row]    = ls_null
			// grabar
 			//f_view_ds(ids_oc)
			IF ids_oc.Update() = -1 THEN
   			Rollback ;
				messagebox("Error en Grabacion Nuevas OC","Se ha procedido al rollback",exclamation!)
			ELSE
				COMMIT using SQLCA;
			END IF
		END IF
	NEXT
	MessageBox('Proceso Concluido', 'Fin de Proceso')
END IF





end event

public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OT", "LOGPARAM"."DOC_OC"
    INTO :as_doc_ot, :as_doc_oc
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_cm910_amp_oc.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cbx_solo_mayor=create cbx_solo_mayor
this.cb_lectura=create cb_lectura
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_solo_mayor
this.Control[iCurrent+2]=this.cb_lectura
end on

on w_cm910_amp_oc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_solo_mayor)
destroy(this.cb_lectura)
end on

event ue_retrieve;call super::ue_retrieve;IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

String	ls_doc_ot, ls_doc_oc

IF cbx_solo_mayor.checked THEN
	idw_1.DataObject = 'd_amp_oc_solo_mayor'
	idw_1.SetTransObject(SQLCA)
ELSE
	idw_1.DataObject = 'd_amp_oc'
	idw_1.SetTransObject(SQLCA)
END IF

idw_1.Retrieve(is_doc_ot, is_doc_oc)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM910'
//idw_1.object.t_subtitulo.text = 'Hasta:  ' + String(uo_fecha.of_get_fecha(), 'dd/mm/yy')
end event

event ue_open_pre;call super::ue_open_pre;Long		ls_rc

ls_rc = of_get_parametros(is_doc_ot, is_doc_oc)

ids_oc = CREATE Datastore
ids_oc.Dataobject = 'd_articulo_mov_proy_ds'
ids_oc.SetTransObject(SQLCA)
end event

type dw_report from w_report_smpl`dw_report within w_cm910_amp_oc
integer x = 9
integer y = 84
string dataobject = "d_amp_oc"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1


CHOOSE CASE dwo.Name
	CASE "oper_sec" 
		lstr_1.DataObject = 'd_oc_x_req_art_oper_sec_tbl'
		lstr_1.Width = 3950
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_oc
		lstr_1.Arg[2] = GetItemString(row,'oper_sec')
		lstr_1.Arg[3] = GetItemString(row,'cod_art')
		lstr_1.Arg[4] = GetItemString(row,'almacen')
		lstr_1.Title = 'OC Asociadas a este Requerimiento'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "nro_oc"
		lstr_1.DataObject = 'd_articulo_mov_proy_ds'
		lstr_1.Width = 3950
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_oc
		lstr_1.Arg[2] = GetItemString(row,'oper_sec')
		lstr_1.Arg[3]  = GetItemString(row,'cod_art')
		lstr_1.Arg[4] = GetItemString(row,'almacen')
		lstr_1.Title = 'ABC de OC Relacionadas'
		lstr_1.Tipo_Cascada = 'A'
		of_new_sheet(lstr_1)	
	CASE "oc_cnt_doc"
		lstr_1.DataObject = 'd_articulo_mov_proy_ds'
		lstr_1.Width = 3950
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_oc
		lstr_1.Arg[2] = GetItemString(row,'oper_sec')
		lstr_1.Arg[3]  = GetItemString(row,'cod_art')
		lstr_1.Arg[4] = GetItemString(row,'almacen')
		lstr_1.Title = 'ABC de OC Relacionadas'
		lstr_1.Tipo_Cascada = 'A'
		of_new_sheet(lstr_1)
END CHOOSE

end event

type cbx_solo_mayor from checkbox within w_cm910_amp_oc
integer x = 14
integer y = 8
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Solo OC > Req"
end type

event clicked;//d_amp_oc_solo_mayor
end event

type cb_lectura from commandbutton within w_cm910_amp_oc
integer x = 553
integer y = 8
integer width = 261
integer height = 64
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.EVENT ue_retrieve()
end event

