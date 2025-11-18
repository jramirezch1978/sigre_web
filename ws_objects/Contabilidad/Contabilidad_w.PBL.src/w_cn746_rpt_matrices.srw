$PBExportHeader$w_cn746_rpt_matrices.srw
forward
global type w_cn746_rpt_matrices from w_report_smpl
end type
end forward

global type w_cn746_rpt_matrices from w_report_smpl
integer width = 3369
integer height = 1604
string title = "[CN746] Matrices Contables Financieras"
string menuname = "m_abc_report_smpl"
end type
global w_cn746_rpt_matrices w_cn746_rpt_matrices

on w_cn746_rpt_matrices.create
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
end on

on w_cn746_rpt_matrices.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;String ls_nada

DECLARE USP_CNTBL_RPT_MATRICES PROCEDURE FOR 
	USP_CNTBL_RPT_MATRICES(:ls_nada);
Execute USP_CNTBL_RPT_MATRICES ;

dw_report.retrieve()

Close USP_CNTBL_RPT_MATRICES;

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

event ue_open_pre;call super::ue_open_pre;this.event ue_retrieve( )
end event

type dw_report from w_report_smpl`dw_report within w_cn746_rpt_matrices
integer x = 0
integer y = 0
integer width = 3291
integer height = 1104
integer taborder = 50
string dataobject = "d_cntbl_rpt_matrices_tbl"
end type

