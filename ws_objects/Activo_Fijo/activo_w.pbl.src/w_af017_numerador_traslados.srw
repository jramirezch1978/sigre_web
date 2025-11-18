$PBExportHeader$w_af017_numerador_traslados.srw
forward
global type w_af017_numerador_traslados from w_abc_master_smpl
end type
end forward

global type w_af017_numerador_traslados from w_abc_master_smpl
integer width = 1513
integer height = 600
string title = "(AF017) Numerador de Traslados"
string menuname = "m_numerador"
long backcolor = 67108864
end type
global w_af017_numerador_traslados w_af017_numerador_traslados

type variables
//string ls_dato
end variables

on w_af017_numerador_traslados.create
call super::create
if this.MenuName = "m_numerador" then this.MenuID = create m_numerador
end on

on w_af017_numerador_traslados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 250
This.move(ll_x,ll_y)

ib_log = TRUE

ii_lec_mst = 0
dw_master.retrieve(gs_origen)
end event

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_1.Retrieve(gs_origen)
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_af017_numerador_traslados
integer x = 14
integer y = 20
integer width = 1449
integer height = 372
string dataobject = "dw_numerador_traslados_tbl"
boolean hscrollbar = false
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

