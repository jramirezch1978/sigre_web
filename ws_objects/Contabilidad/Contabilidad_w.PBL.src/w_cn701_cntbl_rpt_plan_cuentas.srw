$PBExportHeader$w_cn701_cntbl_rpt_plan_cuentas.srw
forward
global type w_cn701_cntbl_rpt_plan_cuentas from w_report_smpl
end type
type cb_1 from commandbutton within w_cn701_cntbl_rpt_plan_cuentas
end type
type st_1 from statictext within w_cn701_cntbl_rpt_plan_cuentas
end type
type cbx_1 from checkbox within w_cn701_cntbl_rpt_plan_cuentas
end type
end forward

global type w_cn701_cntbl_rpt_plan_cuentas from w_report_smpl
integer width = 3269
integer height = 1604
string title = "Plan de cuentas (CN701)"
string menuname = "m_abc_report_smpl"
cb_1 cb_1
st_1 st_1
cbx_1 cbx_1
end type
global w_cn701_cntbl_rpt_plan_cuentas w_cn701_cntbl_rpt_plan_cuentas

on w_cn701_cntbl_rpt_plan_cuentas.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.st_1=create st_1
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cbx_1
end on

on w_cn701_cntbl_rpt_plan_cuentas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.cbx_1)
end on

event ue_retrieve();call super::ue_retrieve;dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn701_cntbl_rpt_plan_cuentas
integer x = 0
integer y = 160
integer width = 3168
integer height = 1168
string dataobject = "d_cntbl_plan_cuentas_tbl"
end type

type cb_1 from commandbutton within w_cn701_cntbl_rpt_plan_cuentas
integer x = 2514
integer y = 16
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

type st_1 from statictext within w_cn701_cntbl_rpt_plan_cuentas
integer x = 197
integer y = 16
integer width = 1627
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "PLAN DE CUENTAS "
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_cn701_cntbl_rpt_plan_cuentas
integer x = 1851
integer y = 24
integer width = 603
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar Fecha"
boolean checked = true
end type

event clicked;if cbx_1.checked then
	dw_report.object.t_fecha.visible = '1'
else
	dw_report.object.t_fecha.visible = '0'
end if
end event

