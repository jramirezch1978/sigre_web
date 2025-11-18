$PBExportHeader$w_ma002_tipo_maquina.srw
forward
global type w_ma002_tipo_maquina from w_abc_master_smpl
end type
end forward

global type w_ma002_tipo_maquina from w_abc_master_smpl
integer width = 1879
integer height = 920
string title = "Tipos de máquinas (MA002)"
string menuname = "m_abc_master_smpl"
end type
global w_ma002_tipo_maquina w_ma002_tipo_maquina

on w_ma002_tipo_maquina.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_ma002_tipo_maquina.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)

//Help
ii_help = 5
end event

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("tipo_maquina.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('tipo_maquina')
END IF
end event

event ue_update_pre;call super::ue_update_pre;if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if
dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_ma002_tipo_maquina
integer x = 0
integer y = 0
integer width = 1815
integer height = 716
string dataobject = "d_abc_tipos_maquina"
end type

event dw_master::constructor;call super::constructor;ii_ck[1]=1
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

