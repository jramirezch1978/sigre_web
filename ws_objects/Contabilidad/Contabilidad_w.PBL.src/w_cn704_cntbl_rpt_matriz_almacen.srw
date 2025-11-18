$PBExportHeader$w_cn704_cntbl_rpt_matriz_almacen.srw
forward
global type w_cn704_cntbl_rpt_matriz_almacen from w_report_smpl
end type
type cb_1 from commandbutton within w_cn704_cntbl_rpt_matriz_almacen
end type
type st_1 from statictext within w_cn704_cntbl_rpt_matriz_almacen
end type
end forward

global type w_cn704_cntbl_rpt_matriz_almacen from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Matrices contables por movimiento de almacen (CN704)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
st_1 st_1
end type
global w_cn704_cntbl_rpt_matriz_almacen w_cn704_cntbl_rpt_matriz_almacen

on w_cn704_cntbl_rpt_matriz_almacen.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
end on

on w_cn704_cntbl_rpt_matriz_almacen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn704_cntbl_rpt_matriz_almacen
integer x = 23
integer y = 236
integer width = 3287
integer height = 1168
string dataobject = "d_rpt_matriz_cntbl_almacen_tbl"
end type

type cb_1 from commandbutton within w_cn704_cntbl_rpt_matriz_almacen
integer x = 2784
integer y = 68
integer width = 297
integer height = 92
integer taborder = 10
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

type st_1 from statictext within w_cn704_cntbl_rpt_matriz_almacen
integer x = 1029
integer y = 64
integer width = 1714
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 12632256
string text = "Matrices Contables Por Movimiento de Almacen"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

