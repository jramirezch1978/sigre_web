$PBExportHeader$w_cd703_rpt_remesas.srw
forward
global type w_cd703_rpt_remesas from w_report_smpl
end type
type sle_1 from singlelineedit within w_cd703_rpt_remesas
end type
type st_1 from statictext within w_cd703_rpt_remesas
end type
type cb_1 from commandbutton within w_cd703_rpt_remesas
end type
end forward

global type w_cd703_rpt_remesas from w_report_smpl
integer width = 3534
integer height = 2292
string title = "Formato de Remesa"
string menuname = "m_impresion"
long backcolor = 12632256
sle_1 sle_1
st_1 st_1
cb_1 cb_1
end type
global w_cd703_rpt_remesas w_cd703_rpt_remesas

on w_cd703_rpt_remesas.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_1=create sle_1
this.st_1=create st_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
end on

on w_cd703_rpt_remesas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.cb_1)
end on

event ue_retrieve;call super::ue_retrieve;Long 	 ll_row, ll_ano, ll_mes
String ls_usuario

ls_usuario = sle_1.text
dw_report.SetTransObject( sqlca)
this.Event ue_preview()
dw_report.retrieve(ls_usuario)		
dw_report.object.p_logo.filename = gs_logo


end event

event ue_open_pre;call super::ue_open_pre;of_position_window(50,50)
end event

type dw_report from w_report_smpl`dw_report within w_cd703_rpt_remesas
integer x = 32
integer y = 188
integer width = 3342
integer height = 1828
string dataobject = "d_rpt_remesa"
boolean hscrollbar = false
boolean vscrollbar = false
end type

type sle_1 from singlelineedit within w_cd703_rpt_remesas
integer x = 379
integer y = 28
integer width = 379
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cd703_rpt_remesas
integer x = 41
integer y = 40
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Nro. Remesa"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cd703_rpt_remesas
integer x = 878
integer y = 32
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_retrieve()
end event

