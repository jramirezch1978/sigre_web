$PBExportHeader$w_af302_aprobacion_traslados.srw
forward
global type w_af302_aprobacion_traslados from w_abc_master_smpl
end type
end forward

global type w_af302_aprobacion_traslados from w_abc_master_smpl
integer width = 3653
integer height = 1008
string title = "[AF302] Aprobación de Traslados"
string menuname = "m_numerador"
end type
global w_af302_aprobacion_traslados w_af302_aprobacion_traslados

on w_af302_aprobacion_traslados.create
call super::create
if this.MenuName = "m_numerador" then this.MenuID = create m_numerador
end on

on w_af302_aprobacion_traslados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.of_protect( )
ib_log 		= True

end event

event ue_update;// Ancester Override
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
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	dw_master.retrieve( )
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_af302_aprobacion_traslados
integer x = 32
integer y = 100
integer width = 3570
integer height = 704
string dataobject = "dw_aprobacion_traslado_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
end event

event dw_master::itemchanged;call super::itemchanged;String ls_data, ls_null
date	 ldt_null


SetNull(ls_null)
SetNull(ldt_null)
This.Accepttext()

IF row <= 0 THEN RETURN

ls_data = This.object.aprobacion [row]

CHOOSE CASE dwo.name
	 CASE 'aprobacion'
			
			IF ls_data = '0' THEN
				This.object.usr_autorizacion  [row] = gs_user
				This.object.fecha_autorizacion[row] = f_fecha_actual()
			ELSE
				This.object.usr_autorizacion  [row] = ls_null
				This.object.fecha_autorizacion[row] = ldt_null
			END IF

END CHOOSE
end event

