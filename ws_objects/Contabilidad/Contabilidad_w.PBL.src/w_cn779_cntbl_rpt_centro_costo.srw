$PBExportHeader$w_cn779_cntbl_rpt_centro_costo.srw
forward
global type w_cn779_cntbl_rpt_centro_costo from w_report_smpl
end type
end forward

global type w_cn779_cntbl_rpt_centro_costo from w_report_smpl
integer width = 3369
integer height = 1604
string title = "(CN779) Maestro de Centros de Costos"
string menuname = "m_abc_report_smpl"
end type
global w_cn779_cntbl_rpt_centro_costo w_cn779_cntbl_rpt_centro_costo

on w_cn779_cntbl_rpt_centro_costo.create
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
end on

on w_cn779_cntbl_rpt_centro_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();call super::ue_retrieve;dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

event ue_open_pre;call super::ue_open_pre;this.event ue_retrieve( )
end event

type dw_report from w_report_smpl`dw_report within w_cn779_cntbl_rpt_centro_costo
integer x = 0
integer y = 0
integer width = 3287
integer height = 1168
string dataobject = "d_rpt_centros_costo_tbl"
end type

