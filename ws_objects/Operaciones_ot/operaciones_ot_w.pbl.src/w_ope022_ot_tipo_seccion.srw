$PBExportHeader$w_ope022_ot_tipo_seccion.srw
forward
global type w_ope022_ot_tipo_seccion from w_abc
end type
type dw_master from u_dw_abc within w_ope022_ot_tipo_seccion
end type
end forward

global type w_ope022_ot_tipo_seccion from w_abc
integer width = 1339
integer height = 880
string title = "Tipo de Secciones (OPE022)"
string menuname = "m_master_sin_lista"
dw_master dw_master
end type
global w_ope022_ot_tipo_seccion w_ope022_ot_tipo_seccion

on w_ope022_ot_tipo_seccion.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_ope022_ot_tipo_seccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_master.Retrieve()
idw_1 = dw_master              				// asignar dw corriente



end event

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION DE seccion
IF f_row_Processing( dw_master, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF
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

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

type dw_master from u_dw_abc within w_ope022_ot_tipo_seccion
integer x = 14
integer y = 12
integer width = 1257
integer height = 660
string dataobject = "d_abc_seccion_tipo_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event constructor;call super::constructor;is_mastdet = 'm'		
is_dwform = 'tabular'


ii_ck[1] = 1				// columnas de lectrua de este dw


idw_mst = dw_master

end event

event itemerror;call super::itemerror;Return 1
end event

