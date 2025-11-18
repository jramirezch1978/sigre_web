$PBExportHeader$w_ope017_incidencias_clase.srw
forward
global type w_ope017_incidencias_clase from w_abc_master_smpl
end type
end forward

global type w_ope017_incidencias_clase from w_abc_master_smpl
integer width = 1801
integer height = 1648
string title = "Clase de incidencias (OPE017)"
string menuname = "m_master_sin_lista"
end type
global w_ope017_incidencias_clase w_ope017_incidencias_clase

on w_ope017_incidencias_clase.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope017_incidencias_clase.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("clase.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('clase')
END IF

end event

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)

//Help
ii_help = 7
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

//--VERIFICACION Y ASIGNACION DE TIPO DE MAQUINA
IF f_row_Processing( dw_master, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_ope017_incidencias_clase
integer x = 0
integer y = 4
integer width = 1737
integer height = 1308
string dataobject = "d_abc_incidencia_clase_tbl"
end type

event dw_master::itemchanged;call super::itemchanged;Accepttext()
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

