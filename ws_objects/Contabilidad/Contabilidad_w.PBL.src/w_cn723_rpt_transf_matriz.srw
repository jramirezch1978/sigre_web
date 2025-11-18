$PBExportHeader$w_cn723_rpt_transf_matriz.srw
forward
global type w_cn723_rpt_transf_matriz from w_report_smpl
end type
type cb_1 from commandbutton within w_cn723_rpt_transf_matriz
end type
end forward

global type w_cn723_rpt_transf_matriz from w_report_smpl
integer width = 3410
integer height = 2052
string title = "Movimiento de almacenes a contabilizar (CN723)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
end type
global w_cn723_rpt_transf_matriz w_cn723_rpt_transf_matriz

type variables

end variables

on w_cn723_rpt_transf_matriz.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_cn723_rpt_transf_matriz.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
end on

event resize;call super::resize;// prueba

end event

type dw_report from w_report_smpl`dw_report within w_cn723_rpt_transf_matriz
integer x = 9
integer y = 216
integer width = 3333
integer height = 1612
integer taborder = 50
string dataobject = "d_rpt_transf_matriz"
end type

type cb_1 from commandbutton within w_cn723_rpt_transf_matriz
integer x = 2917
integer y = 48
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprime"
end type

event clicked;idw_1.SetTransObject(sqlca)
idw_1.retrieve()
idw_1.object.p_logo.filename = gs_logo

idw_1.visible = true
parent.event ue_preview()

end event

