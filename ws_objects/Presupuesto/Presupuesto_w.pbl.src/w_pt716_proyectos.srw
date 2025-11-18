$PBExportHeader$w_pt716_proyectos.srw
forward
global type w_pt716_proyectos from w_report_smpl
end type
end forward

global type w_pt716_proyectos from w_report_smpl
integer width = 1641
integer height = 1552
string title = "Maestro de Proyectos (PT716)"
string menuname = "m_impresion"
long backcolor = 67108864
end type
global w_pt716_proyectos w_pt716_proyectos

on w_pt716_proyectos.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_pt716_proyectos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;This.Event ue_retrieve()
end event

event ue_retrieve();call super::ue_retrieve;idw_1.Retrieve()
//idw_1.Object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_pt716_proyectos
integer width = 1568
integer height = 1324
string dataobject = "d_rpt_proyectos"
end type

