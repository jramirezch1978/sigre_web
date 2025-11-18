$PBExportHeader$w_cn013_clase_contable.srw
forward
global type w_cn013_clase_contable from w_abc_master_smpl
end type
end forward

global type w_cn013_clase_contable from w_abc_master_smpl
integer width = 1554
integer height = 1608
string title = "Clase Contable (CN013)"
string menuname = "m_abc_master_smpl"
end type
global w_cn013_clase_contable w_cn013_clase_contable

on w_cn013_clase_contable.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn013_clase_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("clase_cntbl.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("clase_cntbl")
END IF
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn013_clase_contable
integer width = 1486
integer height = 1348
string dataobject = "d_cntbl_clase_tbl"
end type

