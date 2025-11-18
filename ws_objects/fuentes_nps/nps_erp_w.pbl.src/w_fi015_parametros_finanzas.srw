$PBExportHeader$w_fi015_parametros_finanzas.srw
forward
global type w_fi015_parametros_finanzas from w_abc
end type
type dw_master from u_dw_abc within w_fi015_parametros_finanzas
end type
end forward

global type w_fi015_parametros_finanzas from w_abc
integer width = 3351
integer height = 1740
string title = "[FI015] Parametros del Financiamiento"
string menuname = "m_save_exit"
dw_master dw_master
end type
global w_fi015_parametros_finanzas w_fi015_parametros_finanzas

on w_fi015_parametros_finanzas.create
int iCurrent
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
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

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	
ELSE 
	ROLLBACK USING SQLCA;
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

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type ole_skin from w_abc`ole_skin within w_fi015_parametros_finanzas
end type

type dw_master from u_dw_abc within w_fi015_parametros_finanzas
integer width = 3282
integer height = 1524
string dataobject = "d_abc_finparam_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
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

