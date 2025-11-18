$PBExportHeader$w_abc_mid.srw
$PBExportComments$Mantenimiento de 3 niveles, dw_master, dw_demast, dw_detail
forward
global type w_abc_mid from w_abc
end type
type dw_master from u_dw_abc within w_abc_mid
end type
type dw_detail from u_dw_abc within w_abc_mid
end type
type dw_detmast from u_dw_abc within w_abc_mid
end type
end forward

global type w_abc_mid from w_abc
integer width = 603
integer height = 832
dw_master dw_master
dw_detail dw_detail
dw_detmast dw_detmast
end type
global w_abc_mid w_abc_mid

type variables
String      		is_tabla_m, is_tabla_dm, is_tabla_d
String				is_colname_m[], is_colname_dm[], is_colname_d[]
String				is_coltype_m[], is_coltype_dm[], is_coltype_d[]
n_cst_log_diario	in_log
end variables

on w_abc_mid.create
int iCurrent
call super::create
this.dw_master=create dw_master
this.dw_detail=create dw_detail
this.dw_detmast=create dw_detmast
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_detmast
end on

on w_abc_mid.destroy
call super::destroy
destroy(this.dw_master)
destroy(this.dw_detail)
destroy(this.dw_detmast)
end on

event resize;call super::resize;dw_master.width   = newwidth  - dw_master.x - 10
dw_detmast.width  = newwidth  - dw_detmast.x - 10
dw_detail.width   = newwidth  - dw_detail.x - 10
dw_detail.height  = newheight - dw_detail.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = dw_detmast AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
ELSE
	IF idw_1 = dw_detail AND dw_detmast.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Intermedio")
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
dw_detmast.of_protect()
dw_detail.of_protect()
end event

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)
dw_detmast.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)

idw_1 = dw_master              			// asignar dw corriente
dw_detail.BorderStyle = StyleRaised! 	// indicar dw_detail como no activado
dw_master.of_protect()         			// bloquear modificaciones 
dw_detmast.of_protect()
dw_detail.of_protect()

// ii_help = 101           // help topic
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
//ib_log = TRUE
//is_tabla_m = 'Master'
//is_tabla_dm = 'detmast'
//is_tabla_d = 'detail'

end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)

RETURN ll_rc
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detmast.of_create_log()
	dw_detail.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		Rollback ;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detmast.ii_update = 1 THEN
	IF dw_detmast.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		Rollback ;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion DetMast", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		Rollback ;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log( )
		lbo_ok = dw_detmast.of_save_log( )
		lbo_ok = dw_detail.of_save_log( )
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	dw_master.ii_update = 0
	dw_detmast.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.ResetUpdate()
	dw_detmast.ResetUpdate()
	dw_detail.ResetUpdate()
	
	f_mensaje("Datos Grabados satisfactoriamente", "")

END IF

end event

event ue_update_request;call super::ue_update_request;Integer 	li_msg_result, li_update

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar

li_update = dw_master.ii_update + dw_detmast.ii_update + dw_detail.ii_update

IF li_update > 0 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	END IF
END IF

end event

event ue_open_pos();call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_m, is_coltype_m)
	in_log.of_dw_map(dw_detmast, is_colname_dm, is_coltype_dm)
	in_log.of_dw_map(dw_detail, is_colname_d, is_coltype_d)
END IF
end event

type dw_master from u_dw_abc within w_abc_mid
integer x = 32
integer y = 16
integer height = 248
boolean bringtotop = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;is_mastdet = 'md'
idw_det  = dw_detmast
end event

type dw_detail from u_dw_abc within w_abc_mid
integer x = 27
integer y = 492
integer height = 176
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event constructor;call super::constructor;is_mastdet = 'd' 
is_dwform = 'tabular' 
idw_mst  = dw_detmast
end event

event ue_insert_pre;call super::ue_insert_pre;Any  la_id
Integer li_x

FOR li_x = 1 TO UpperBound(dw_master.ii_dk)
	la_id = dw_master.object.data.primary.current[dw_master.il_row, dw_master.ii_dk[li_x]]
	THIS.SetItem(al_row, ii_rk[li_x], la_id)
NEXT


end event

type dw_detmast from u_dw_abc within w_abc_mid
integer x = 32
integer y = 284
integer height = 176
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;is_mastdet = 'dd'
is_dwform = 'tabular'
idw_mst = dw_master
idw_det = dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

