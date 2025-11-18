$PBExportHeader$w_cntbl_rpt_matrices.srw
forward
global type w_cntbl_rpt_matrices from w_report_smpl
end type
type cb_1 from commandbutton within w_cntbl_rpt_matrices
end type
type st_1 from statictext within w_cntbl_rpt_matrices
end type
end forward

global type w_cntbl_rpt_matrices from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Contabilidad"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
st_1 st_1
end type
global w_cntbl_rpt_matrices w_cntbl_rpt_matrices

on w_cntbl_rpt_matrices.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
end on

on w_cntbl_rpt_matrices.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_nada

DECLARE pb_usp_cntbl_rpt_matrices PROCEDURE FOR USP_CNTBL_RPT_MATRICES
(:ls_nada);
Execute pb_usp_cntbl_rpt_matrices ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cntbl_rpt_matrices
integer x = 23
integer y = 300
integer width = 3291
integer height = 1104
integer taborder = 50
string dataobject = "d_cntbl_rpt_matrices_tbl"
end type

type cb_1 from commandbutton within w_cntbl_rpt_matrices
integer x = 2683
integer y = 100
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

type st_1 from statictext within w_cntbl_rpt_matrices
integer x = 905
integer y = 104
integer width = 1627
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 12632256
string text = "MATRICES CONTABLES FINANCIERAS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

