$PBExportHeader$w_fi015_parametros_finanzas.srw
forward
global type w_fi015_parametros_finanzas from w_abc
end type
type dw_master from u_dw_abc within w_fi015_parametros_finanzas
end type
end forward

global type w_fi015_parametros_finanzas from w_abc
integer width = 4032
integer height = 2664
string title = "Parametros del Financiamiento (FI015)"
string menuname = "m_logparam"
dw_master dw_master
end type
global w_fi015_parametros_finanzas w_fi015_parametros_finanzas

on w_fi015_parametros_finanzas.create
int iCurrent
call super::create
if this.MenuName = "m_logparam" then this.MenuID = create m_logparam
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fi015_parametros_finanzas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_master.Retrieve()
idw_1 = dw_master              				// asignar dw corriente


of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0

	END IF
END IF

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	
	dw_master.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_modify();call super::ue_modify;dw_master.of_protect()

end event

event ue_insert();call super::ue_insert;Long  ll_row


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update_pre;call super::ue_update_pre;IF not gnvo_app.of_row_Processing( dw_master ) then return 
dw_master.of_set_flag_replicacion()
end event

type dw_master from u_dw_abc within w_fi015_parametros_finanzas
integer x = 9
integer y = 16
integer width = 3918
integer height = 2432
string dataobject = "d_abc_finparam_tbl"
boolean livescroll = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		



ii_ck[1] = 1	// columnas de lectrua de este dw

idw_mst  = dw_master

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;This.Object.reckey [al_row] = '1'
end event

