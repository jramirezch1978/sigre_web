$PBExportHeader$w_rh079_maestro_tarjetas.srw
forward
global type w_rh079_maestro_tarjetas from w_abc
end type
type dw_master from u_dw_abc within w_rh079_maestro_tarjetas
end type
end forward

global type w_rh079_maestro_tarjetas from w_abc
integer width = 2011
integer height = 1680
string title = "Maestro de Tarjetas (RH079)"
string menuname = "m_master_simple"
dw_master dw_master
end type
global w_rh079_maestro_tarjetas w_rh079_maestro_tarjetas

on w_rh079_maestro_tarjetas.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_rh079_maestro_tarjetas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;
dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos


idw_1 = dw_master              				// asignar dw corriente

of_position_window(0,0)       			// Posicionar la ventana en forma fija
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

event ue_update_pre;call super::ue_update_pre;
ib_update_check = true
//Verificación de Data en Detalle de Documento
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

end event

event ue_insert;call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

type dw_master from u_dw_abc within w_rh079_maestro_tarjetas
integer width = 1947
integer height = 1480
string dataobject = "d_abc_maestro_tarjreta_tbl"
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


idw_mst  = dw_master

end event

event itemchanged;call super::itemchanged;accepttext()
end event

event itemerror;call super::itemerror;return 1
end event

event doubleclicked;call super::doubleclicked;String  ls_null ,ls_return1 , ls_return2 ,ls_sql 

if this.ii_protect = 1 or row = 0 then return


Setnull(ls_null)


choose case dwo.name
		 case 'cod_usr'

				ls_sql = "select usuario.cod_usr as codigo,usuario.nombre as descripcion from usuario where usuario.flag_estado = " +"'"+'1'+"'"
				f_lista(ls_sql, ls_return1, ls_return2, '2')
				
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				
				this.object.cod_usr	   [row] = ls_return1

				this.ii_update = 1

end choose

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr [al_row] = gs_user
end event

