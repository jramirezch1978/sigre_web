$PBExportHeader$w_cn211_abc_cv_plantilla.srw
forward
global type w_cn211_abc_cv_plantilla from w_abc_mid
end type
end forward

global type w_cn211_abc_cv_plantilla from w_abc_mid
integer width = 3278
integer height = 1924
string title = "(CN211) Plantillas de Costos de Ventas"
string menuname = "m_abc_master_smpl"
end type
global w_cn211_abc_cv_plantilla w_cn211_abc_cv_plantilla

on w_cn211_abc_cv_plantilla.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn211_abc_cv_plantilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_master.Retrieve()
idw_1 = dw_master              				// asignar dw corriente
dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado
//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//Log de Seguridad
//ib_log = TRUE
is_tabla_m  = 'cntbl_cp_formato_reportes'
is_tabla_dm = 'cntbl_cv_plantilla'
is_tabla_d  = 'cntbl_cv_plantilla_det'

end event

event ue_modify;call super::ue_modify;String ls_protect

//  Master
   ls_protect=dw_master.Describe("tipo_operacion.protect")
	IF ls_protect='0' THEN
   	dw_master.of_column_protect("tipo_operacion")
	END IF
	ls_protect=dw_master.Describe("cod_frmt.protect")
	IF ls_protect='0' THEN
   	dw_master.of_column_protect("cod_frmt")
	END IF

//  Detalle del Master
	ls_protect=dw_detmast.Describe("tipo_operacion.protect")
	IF ls_protect='0' THEN
   	dw_detmast.of_column_protect("tipo_operacion")
	END IF
	ls_protect=dw_detmast.Describe("cod_frmt.protect")
	IF ls_protect='0' THEN
   	dw_detmast.of_column_protect("cod_frmt")
	END IF
	ls_protect=dw_detmast.Describe("linea.protect")
	IF ls_protect='0' THEN
   	dw_detmast.of_column_protect("linea")
	END IF

//  Detalle del Master Detalle
	ls_protect=dw_detail.Describe("tipo_operacion.protect")
	IF ls_protect='0' THEN
   	dw_detail.of_column_protect("tipo_operacion")
	END IF
	ls_protect=dw_detail.Describe("cod_frmt.protect")
	IF ls_protect='0' THEN
   	dw_detail.of_column_protect("cod_frmt")
	END IF
	ls_protect=dw_detail.Describe("linea.protect")
	IF ls_protect='0' THEN
   	dw_detail.of_column_protect("linea")
	END IF
	ls_protect=dw_detail.Describe("columna.protect")
	IF ls_protect='0' THEN
   	dw_detail.of_column_protect("columna")
	END IF

end event

event resize;// Override
end event

event ue_update;// Override

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detmast.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log_m, lds_log_dm, lds_log_d
	lds_log_m = Create DataStore
	lds_log_dm = Create DataStore
	lds_log_d = Create DataStore
	lds_log_m.DataObject  = 'd_log_diario_tbl'
	lds_log_dm.DataObject = 'd_log_diario_tbl'
	lds_log_d.DataObject  = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	lds_log_dm.SetTransObject(SQLCA)
	lds_log_d.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gs_user, is_tabla_m)
	in_log.of_create_log(dw_detmast, lds_log_dm, is_colname_dm, is_coltype_dm, gs_user, is_tabla_dm)
	in_log.of_create_log(dw_detail, lds_log_d, is_colname_d, is_coltype_d, gs_user, is_tabla_d)
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		Rollback ;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detmast.ii_update = 1 THEN
	IF dw_detmast.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		Rollback ;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion DetMast", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		Rollback ;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update() = -1 THEN
			lbo_ok = FALSE
			Rollback ;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Maestro')
		END IF
		IF lds_log_dm.Update() = -1 THEN
			lbo_ok = FALSE
			Rollback ;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, DetMast')
		END IF
		IF lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			Rollback ;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Detalle')
		END IF
	END IF
	DESTROY lds_log_m
	DESTROY lds_log_dm
	DESTROY lds_log_m
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detmast.ii_update = 0
	dw_detail.ii_update = 0
END IF

end event

type dw_master from w_abc_mid`dw_master within w_cn211_abc_cv_plantilla
integer x = 46
integer y = 44
integer width = 3141
integer height = 476
string dataobject = "d_abc_cv_formatos_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

//idw_mst  = 			// dw_master
idw_det  = dw_detmast
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
end event

type dw_detail from w_abc_mid`dw_detail within w_cn211_abc_cv_plantilla
integer x = 46
integer y = 1084
integer width = 3141
integer height = 608
string dataobject = "d_cntbl_cv_plantilla_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
ii_rk[3] = 3

idw_mst  = dw_detmast

end event

type dw_detmast from w_abc_mid`dw_detmast within w_cn211_abc_cv_plantilla
integer x = 46
integer y = 564
integer width = 3141
integer height = 476
string dataobject = "d_abc_cv_plantilla_tbl"
boolean vscrollbar = true
end type

event dw_detmast::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
ii_dk[3] = 3
idw_mst  = dw_master
idw_det  = dw_detail
end event

event dw_detmast::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event dw_detmast::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

end event

event dw_detmast::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2],aa_id[3])
end event

