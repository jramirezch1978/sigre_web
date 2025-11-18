$PBExportHeader$w_cam051_ley_fitosanitario.srw
forward
global type w_cam051_ley_fitosanitario from w_abc_master_smpl
end type
end forward

global type w_cam051_ley_fitosanitario from w_abc_master_smpl
integer height = 1064
string title = "[CAM051] Ley de Fitosanitarios"
string menuname = "m_abc_master_smpl"
end type
global w_cam051_ley_fitosanitario w_cam051_ley_fitosanitario

type variables
String      		is_tabla_m,is_tabla_d,is_colname_m[],is_coltype_m[],is_colname_d[],is_coltype_d[]
n_cst_log_diario	in_log
end variables

on w_cam051_ley_fitosanitario.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam051_ley_fitosanitario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update;call super::ue_update;//Override

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log_m, lds_log_d
	lds_log_m = Create DataStore
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gs_user, is_tabla_m)
END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Maestro')
		END IF
	END IF
	DESTROY lds_log_m
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_cam051_ley_fitosanitario
string dataobject = "d_Abc_ley_fitosanitario"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;integer li_id, li_item = 0, li_row

select max(nro_item)
	into :li_id
from SIC_LEY_FITOSATINARIO;

if dw_master.RowCount( ) > 0 then
	for li_row = 1 to dw_master.RowCount( )
			if li_item < Int(dw_master.object.nro_item[li_row]) then
				li_item = Int(dw_master.object.nro_item[li_row])
			end if
	next
end if

if isNull(li_id) then
	li_id = 0
end if

if li_item > li_id then
	li_id = li_item
end if
li_id = li_id +1

this.object.nro_item[al_row] = li_id
this.setcolumn('producto')
end event

