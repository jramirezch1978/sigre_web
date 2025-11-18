$PBExportHeader$w_ma016_caract_tec.srw
forward
global type w_ma016_caract_tec from w_abc
end type
type dw_master from u_dw_abc within w_ma016_caract_tec
end type
end forward

global type w_ma016_caract_tec from w_abc
integer width = 2313
integer height = 1000
string title = "[MA016] Caracteristicas Tecnicas"
string menuname = "m_abc_master_smpl"
dw_master dw_master
end type
global w_ma016_caract_tec w_ma016_caract_tec

on w_ma016_caract_tec.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_ma016_caract_tec.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_insert();Long  ll_row


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
dw_master.Retrieve()


end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update_pre;call super::ue_update_pre;if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if
dw_master.of_set_flag_replicacion( )
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

event ue_modify();call super::ue_modify;Int li_protect

dw_master.of_protect()

li_protect = integer(dw_master.Object.cod_caract.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_caract.Protect = 1
END IF 


end event

type dw_master from u_dw_abc within w_ma016_caract_tec
integer width = 2231
integer height = 780
string dataobject = "d_abc_caract_tec_tbl"
end type

event itemchanged;call super::itemchanged;Accepttext()


end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master				// dw_master

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("cod_caract.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_caract.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_valor.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event itemerror;call super::itemerror;return 1
end event

