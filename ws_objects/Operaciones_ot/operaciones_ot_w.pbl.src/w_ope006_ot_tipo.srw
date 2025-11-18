$PBExportHeader$w_ope006_ot_tipo.srw
forward
global type w_ope006_ot_tipo from w_abc
end type
type dw_master from u_dw_abc within w_ope006_ot_tipo
end type
end forward

global type w_ope006_ot_tipo from w_abc
integer width = 2085
integer height = 1952
string title = "Tipo de OT (ope006)"
string menuname = "m_master_sin_lista"
dw_master dw_master
end type
global w_ope006_ot_tipo w_ope006_ot_tipo

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master 
dw_master.retrieve()
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

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

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

on w_ope006_ot_tipo.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_ope006_ot_tipo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_insert;call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event resize;call super::resize;dw_master.height = newheight - dw_master.y - 10
dw_master.width  = newwidth  - dw_master.x - 10

end event

type dw_master from u_dw_abc within w_ope006_ot_tipo
integer x = 18
integer y = 8
integer width = 1952
integer height = 1564
string dataobject = "d_abc_adm_tipo_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw



//idw_mst = dw_master 

end event

event itemchanged;call super::itemchanged;accepttext()
end event

event itemerror;call super::itemerror;return 1
end event

