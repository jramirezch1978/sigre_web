$PBExportHeader$w_fi707_rpt_doc_generados_masivos.srw
forward
global type w_fi707_rpt_doc_generados_masivos from w_report_smpl
end type
end forward

global type w_fi707_rpt_doc_generados_masivos from w_report_smpl
string title = "Reporte de Documentos Generados (FI707)"
string menuname = "m_reporte"
long backcolor = 12632256
end type
global w_fi707_rpt_doc_generados_masivos w_fi707_rpt_doc_generados_masivos

on w_fi707_rpt_doc_generados_masivos.create
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
end on

on w_fi707_rpt_doc_generados_masivos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;This.Event ue_retrieve()
end event

event ue_retrieve();call super::ue_retrieve;idw_1.Retrieve(gs_empresa,gs_user)
idw_1.Object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_fi707_rpt_doc_generados_masivos
string dataobject = "d_rpt_generacion_cheques_masivos_tbl"
end type

