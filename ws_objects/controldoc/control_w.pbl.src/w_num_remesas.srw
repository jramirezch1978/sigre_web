$PBExportHeader$w_num_remesas.srw
forward
global type w_num_remesas from w_abc_master
end type
end forward

global type w_num_remesas from w_abc_master
integer width = 887
integer height = 700
string title = "Numeracion de Remesas"
string menuname = "m_mantenimiento_sl"
end type
global w_num_remesas w_num_remesas

on w_num_remesas.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_num_remesas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_update;call super::ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
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

IF ib_log and lbo_ok THEN
	lbo_ok = dw_master.of_save_log()
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_1.Retrieve()
	dw_master.ii_update 	= 0
	dw_master.il_totdel 	= 0
	dw_master.ii_protect = 0
	dw_master.of_protect( )
END IF


end event

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve( )

of_position_window(50,50)

end event

type dw_master from w_abc_master`dw_master within w_num_remesas
integer x = 32
integer y = 60
integer width = 709
integer height = 376
string dataobject = "d_num_remesas"
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

