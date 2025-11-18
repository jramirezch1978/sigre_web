$PBExportHeader$w_cm729_aprobadores_doc_compra.srw
forward
global type w_cm729_aprobadores_doc_compra from w_report_smpl
end type
end forward

global type w_cm729_aprobadores_doc_compra from w_report_smpl
integer width = 3721
integer height = 1612
string title = "(CM729) Reporte de Aprobadores de documentos de compra"
string menuname = "m_impresion"
long backcolor = 67108864
end type
global w_cm729_aprobadores_doc_compra w_cm729_aprobadores_doc_compra

on w_cm729_aprobadores_doc_compra.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_cm729_aprobadores_doc_compra.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()


dw_report.Object.Datawindow.Print.Orientation = 1    
end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM729'

end event

type dw_report from w_report_smpl`dw_report within w_cm729_aprobadores_doc_compra
integer y = 28
integer width = 3662
integer height = 1348
string dataobject = "d_rpt_logistica_aprobador_tbl"
end type

