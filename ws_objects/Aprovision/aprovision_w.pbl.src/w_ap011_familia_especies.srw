$PBExportHeader$w_ap011_familia_especies.srw
forward
global type w_ap011_familia_especies from w_abc_master
end type
end forward

global type w_ap011_familia_especies from w_abc_master
integer width = 1801
integer height = 1540
string title = "Familia de especies (AP011)"
string menuname = "m_mantto_smpl"
end type
global w_ap011_familia_especies w_ap011_familia_especies

on w_ap011_familia_especies.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap011_familia_especies.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_dw_share;call super::ue_dw_share;idw_1.retrieve()
end event

event ue_query_retrieve;this.event ue_update_request()
idw_1.retrieve()
end event

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	//in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_1.Retrieve()
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_open_pre;call super::ue_open_pre;

//Desactiva la opcion buscar del menu de tablas  //
this.MenuId.item[1].item[1].item[1].enabled = false
this.MenuId.item[1].item[1].item[1].visible = false
this.MenuId.item[1].item[1].item[1].ToolbarItemvisible = false
end event

type dw_master from w_abc_master`dw_master within w_ap011_familia_especies
integer width = 1742
integer height = 1328
string dataobject = "d_tg_familia_especi_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		
is_dwform = 'tabular'
ii_ss = 1
ii_ck[1] = 1
idw_mst  = dw_master
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

