$PBExportHeader$w_fi004_grupo_financiero.srw
forward
global type w_fi004_grupo_financiero from w_abc
end type
type dw_master from u_dw_abc within w_fi004_grupo_financiero
end type
end forward

global type w_fi004_grupo_financiero from w_abc
integer width = 1568
integer height = 1852
string title = "Grupo Financiero (FI004)"
string menuname = "m_mantenimiento_sl"
dw_master dw_master
end type
global w_fi004_grupo_financiero w_fi004_grupo_financiero

on w_fi004_grupo_financiero.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fi004_grupo_financiero.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)	// Relacionar el dw con la base de datos
dw_master.retrieve()
idw_1 = dw_master              	// asignar dw corriente
dw_master.of_protect()         	// bloquear modificaciones 
//of_position_window(0,0)       	// Posicionar la ventana en forma fija
//ii_help = 001

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

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION 
IF f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

dw_master.of_set_flag_replicacion()

end event

event ue_modify();call super::ue_modify;Int li_protect

dw_master.of_protect()

li_protect = integer(dw_master.Object.grupo.Protect)

IF li_protect = 0 THEN
   dw_master.Object.grupo.Protect = 1
END IF 


end event

event ue_insert();call super::ue_insert;Long  ll_row


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type dw_master from u_dw_abc within w_fi004_grupo_financiero
integer width = 1490
integer height = 1632
string dataobject = "d_abc_grupos_financieros_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ss     = 1  			// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1]  = 1				// columnas de lectrua de este dw
idw_mst   = dw_master 	// dw_master

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("grupo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

