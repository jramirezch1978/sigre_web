$PBExportHeader$w_ope010_turnos_trabaj.srw
forward
global type w_ope010_turnos_trabaj from w_abc_master_smpl
end type
end forward

global type w_ope010_turnos_trabaj from w_abc_master_smpl
integer width = 2459
integer height = 1400
string title = "Mantenimiento de turnos (OPE010)"
string menuname = "m_master_sin_lista"
end type
global w_ope010_turnos_trabaj w_ope010_turnos_trabaj

on w_ope010_turnos_trabaj.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope010_turnos_trabaj.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(50,50)
ii_help = 26           					// help topic
end event

event ue_modify;call super::ue_modify;String ls_protect

ls_protect=dw_master.Describe("turno.protect")

IF ls_protect='0' THEN
   dw_master.of_column_protect('turno')
END IF
end event

event ue_update_pre;call super::ue_update_pre;if f_row_Processing( dw_master, "grid") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_ope010_turnos_trabaj
integer x = 0
integer y = 12
integer width = 2409
integer height = 1184
string dataobject = "d_abc_turnos_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1]=1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String ls_tipo_turno, ls_flag_estado
ls_tipo_turno='O'
ls_flag_estado='1'
dw_master.SetItem ( al_row, "tipo_turno", ls_tipo_turno )
dw_master.SetItem ( al_row, "flag_estado", ls_flag_estado )
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

