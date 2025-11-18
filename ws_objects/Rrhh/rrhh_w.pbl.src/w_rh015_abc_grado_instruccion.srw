$PBExportHeader$w_rh015_abc_grado_instruccion.srw
forward
global type w_rh015_abc_grado_instruccion from w_abc_master_smpl
end type
end forward

global type w_rh015_abc_grado_instruccion from w_abc_master_smpl
integer width = 1806
integer height = 1288
string title = "(RH015) Grados de Instrucciones"
string menuname = "m_master_simple"
end type
global w_rh015_abc_grado_instruccion w_rh015_abc_grado_instruccion

on w_rh015_abc_grado_instruccion.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh015_abc_grado_instruccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_modify;call super::ue_modify;String ls_protect

ls_protect = dw_master.Describe("cod_grado_inst.protect")
If ls_protect = '0' then
	dw_master.of_column_protect('cod_grado_inst')
End If
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh015_abc_grado_instruccion
integer width = 1737
integer height = 1092
string dataobject = "d_grado_instruccion_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

