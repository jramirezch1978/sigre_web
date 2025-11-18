$PBExportHeader$w_rh221_doc_acredita_pater_rtps.srw
forward
global type w_rh221_doc_acredita_pater_rtps from w_abc
end type
type dw_master from u_dw_abc within w_rh221_doc_acredita_pater_rtps
end type
end forward

global type w_rh221_doc_acredita_pater_rtps from w_abc
integer width = 2011
integer height = 1340
string title = "Documentos que Acreditan Paternidad(RH221)"
string menuname = "m_master_simple"
dw_master dw_master
end type
global w_rh221_doc_acredita_pater_rtps w_rh221_doc_acredita_pater_rtps

on w_rh221_doc_acredita_pater_rtps.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_rh221_doc_acredita_pater_rtps.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  // Relacionar el dw con la base de datos

dw_master.Retrieve()
idw_1 = dw_master              	// asignar dw corriente
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

type dw_master from u_dw_abc within w_rh221_doc_acredita_pater_rtps
integer x = 18
integer y = 20
integer width = 1915
integer height = 1104
string dataobject = "d_rrhh_doc_acred_pater_rtps"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectrua de este dw

idw_mst = dw_master

end event

event itemerror;call super::itemerror;Return 1
end event

