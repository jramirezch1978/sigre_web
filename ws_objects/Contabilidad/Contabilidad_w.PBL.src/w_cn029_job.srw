$PBExportHeader$w_cn029_job.srw
forward
global type w_cn029_job from w_abc_master_smpl
end type
end forward

global type w_cn029_job from w_abc_master_smpl
integer width = 2254
integer height = 1036
string title = "Job (CN029)"
string menuname = "m_master_smpl"
end type
global w_cn029_job w_cn029_job

on w_cn029_job.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn029_job.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("job.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("job")
END IF

end event

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

//of_position_window(50,50)       			// Posicionar la ventana en forma fija

end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn029_job
integer x = 0
integer y = 0
integer width = 2213
integer height = 804
string dataobject = "d_job_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw

end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;this.SetItem(al_row,'flag_tipo','1')
this.SetItem(al_row,'fecha',today())

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

