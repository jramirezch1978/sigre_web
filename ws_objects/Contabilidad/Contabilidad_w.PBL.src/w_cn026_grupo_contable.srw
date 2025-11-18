$PBExportHeader$w_cn026_grupo_contable.srw
forward
global type w_cn026_grupo_contable from w_abc_master_smpl
end type
end forward

global type w_cn026_grupo_contable from w_abc_master_smpl
integer width = 2048
integer height = 2208
string title = "Grupo Contable - Costos (CN026)"
string menuname = "m_abc_master_smpl"
end type
global w_cn026_grupo_contable w_cn026_grupo_contable

on w_cn026_grupo_contable.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn026_grupo_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("grp_cntbl.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("grp_cntbl")
END IF
end event

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)


//of_position_window(30,30)       			// Posicionar la ventana en forma fija

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn026_grupo_contable
integer width = 1819
integer height = 1788
string dataobject = "d_grupo_contable_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

