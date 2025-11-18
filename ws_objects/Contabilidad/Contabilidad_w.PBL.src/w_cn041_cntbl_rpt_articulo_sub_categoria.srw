$PBExportHeader$w_cn041_cntbl_rpt_articulo_sub_categoria.srw
forward
global type w_cn041_cntbl_rpt_articulo_sub_categoria from w_report_smpl
end type
type cb_1 from commandbutton within w_cn041_cntbl_rpt_articulo_sub_categoria
end type
end forward

global type w_cn041_cntbl_rpt_articulo_sub_categoria from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Reporte de Artículos con Sub-Categorías (CN041)"
string menuname = "m_abc_report_smpl"
cb_1 cb_1
end type
global w_cn041_cntbl_rpt_articulo_sub_categoria w_cn041_cntbl_rpt_articulo_sub_categoria

on w_cn041_cntbl_rpt_articulo_sub_categoria.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_cn041_cntbl_rpt_articulo_sub_categoria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
end on

event ue_retrieve;call super::ue_retrieve;dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn041_cntbl_rpt_articulo_sub_categoria
integer x = 0
integer y = 116
integer width = 3291
integer height = 1192
integer taborder = 50
string dataobject = "d_rpt_articulo_sub_categoria_tbl"
end type

type cb_1 from commandbutton within w_cn041_cntbl_rpt_articulo_sub_categoria
integer x = 1801
integer y = 12
integer width = 297
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

