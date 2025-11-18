$PBExportHeader$w_cn747_articulo_sub_categoria.srw
forward
global type w_cn747_articulo_sub_categoria from w_report_smpl
end type
end forward

global type w_cn747_articulo_sub_categoria from w_report_smpl
integer width = 3369
integer height = 1604
string title = "[CN041] Reporte de Artículos con Sub-Categorías "
string menuname = "m_abc_report_smpl"
end type
global w_cn747_articulo_sub_categoria w_cn747_articulo_sub_categoria

on w_cn747_articulo_sub_categoria.create
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
end on

on w_cn747_articulo_sub_categoria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

event ue_open_pre;call super::ue_open_pre;this.event ue_retrieve( )
end event

type dw_report from w_report_smpl`dw_report within w_cn747_articulo_sub_categoria
integer x = 0
integer y = 0
integer width = 3291
integer height = 1192
integer taborder = 50
string dataobject = "d_rpt_articulo_sub_categoria_tbl"
end type

