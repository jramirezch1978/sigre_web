$PBExportHeader$w_cn003_moneda.srw
forward
global type w_cn003_moneda from w_abc_master_smpl
end type
end forward

global type w_cn003_moneda from w_abc_master_smpl
integer width = 1893
integer height = 816
string title = "Mantenimiento de Monedas (CN003)"
string menuname = "m_abc_master_smpl"
end type
global w_cn003_moneda w_cn003_moneda

on w_cn003_moneda.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn003_moneda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_moneda.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cod_moneda")
END IF
end event

event resize;//  Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn003_moneda
integer width = 1847
integer height = 632
string dataobject = "d_moneda_tbl"
end type

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;//AcceptText()
end event

