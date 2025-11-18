$PBExportHeader$w_ope003_labor_ejecutor_rpt.srw
forward
global type w_ope003_labor_ejecutor_rpt from w_report_smpl
end type
end forward

global type w_ope003_labor_ejecutor_rpt from w_report_smpl
integer x = 329
integer y = 188
integer width = 3643
integer height = 2028
string title = "Reporte de Labores (OPE003RPT)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
end type
global w_ope003_labor_ejecutor_rpt w_ope003_labor_ejecutor_rpt

event ue_open_pre();call super::ue_open_pre;of_position(0,0)
This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;idw_1.Visible = True

idw_1.Retrieve(gs_user)
idw_1.Object.p_logo.filename = gs_logo
end event

on w_ope003_labor_ejecutor_rpt.create
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
end on

on w_ope003_labor_ejecutor_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_report from w_report_smpl`dw_report within w_ope003_labor_ejecutor_rpt
string dataobject = "d_rpt_labores_ff"
end type

event dw_report::constructor;call super::constructor;is_dwform = 'form'  
end event

