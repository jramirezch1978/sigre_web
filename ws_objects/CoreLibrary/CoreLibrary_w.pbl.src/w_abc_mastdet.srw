$PBExportHeader$w_abc_mastdet.srw
$PBExportComments$abc Maestro detalle con pop window para la busqueda del maestro, ff para el Maestro, tbl para el detalle
forward
global type w_abc_mastdet from w_abc
end type
type dw_master from u_dw_abc within w_abc_mastdet
end type
type dw_detail from u_dw_abc within w_abc_mastdet
end type
end forward

global type w_abc_mastdet from w_abc
integer width = 1294
integer height = 1068
dw_master dw_master
dw_detail dw_detail
end type
global w_abc_mastdet w_abc_mastdet

type variables


end variables

on w_abc_mastdet.create
int iCurrent
call super::create
this.dw_master=create dw_master
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.dw_detail
end on

on w_abc_mastdet.destroy
call super::destroy
destroy(this.dw_master)
destroy(this.dw_detail)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row

//IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
//	MessageBox("Error", "No ha seleccionado registro Maestro")
//	RETURN
//END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
dw_detail.of_protect()
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
idw_1 = dw_master              			// asignar dw corriente
dw_detail.BorderStyle = StyleRaised! 	// indicar dw_detail como no activado
dw_master.of_protect()         			// bloquear modificaciones 
dw_detail.of_protect()

// ii_help = 101           // help topic
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
ib_log = TRUE
//idw_query = dw_master

end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)

RETURN ll_rc
end event

event ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
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
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
		
		ib_update_check = true
		
	END IF
END IF

end event

event ue_duplicar;call super::ue_duplicar;idw_1.Event ue_duplicar()
end event

type dw_master from u_dw_abc within w_abc_mastdet
integer x = 5
integer y = 8
integer width = 1042
integer height = 520
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;is_mastdet = 'md'
idw_det  = dw_detail
end event

type dw_detail from u_dw_abc within w_abc_mastdet
integer x = 5
integer y = 544
integer width = 1042
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor; is_mastdet = 'd'      // 'm' = master sin detalle (default), 'd' =  detalle,
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
 is_dwform = 'tabular' // tabular, grid, form
 
 idw_mst  = dw_master
end event

event ue_insert_pre;call super::ue_insert_pre;Any  la_id
Integer li_x

FOR li_x = 1 TO UpperBound(dw_master.ii_dk)
	la_id = dw_master.object.data.primary.current[dw_master.il_row, dw_master.ii_dk[li_x]]
	THIS.SetItem(al_row, ii_rk[li_x], la_id)
NEXT


end event

