$PBExportHeader$w_cntbl_rpt_detalle_gastos_r.srw
forward
global type w_cntbl_rpt_detalle_gastos_r from w_report_smpl
end type
type sle_ano from singlelineedit within w_cntbl_rpt_detalle_gastos_r
end type
type sle_mes from singlelineedit within w_cntbl_rpt_detalle_gastos_r
end type
type cb_1 from commandbutton within w_cntbl_rpt_detalle_gastos_r
end type
type st_3 from statictext within w_cntbl_rpt_detalle_gastos_r
end type
type st_4 from statictext within w_cntbl_rpt_detalle_gastos_r
end type
type ddlb_1 from dropdownlistbox within w_cntbl_rpt_detalle_gastos_r
end type
type st_2 from statictext within w_cntbl_rpt_detalle_gastos_r
end type
type gb_1 from groupbox within w_cntbl_rpt_detalle_gastos_r
end type
end forward

global type w_cntbl_rpt_detalle_gastos_r from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Resumen de Gastos por Centro de Costo y Cuenta Contable"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
ddlb_1 ddlb_1
st_2 st_2
gb_1 gb_1
end type
global w_cntbl_rpt_detalle_gastos_r w_cntbl_rpt_detalle_gastos_r

on w_cntbl_rpt_detalle_gastos_r.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.ddlb_1=create ddlb_1
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.ddlb_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_cntbl_rpt_detalle_gastos_r.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ddlb_1)
destroy(this.st_2)
destroy(this.gb_1)
end on

event ue_retrieve();call super::ue_retrieve;String ls_ano, ls_mes, ls_nivel

ls_ano   = String(sle_ano.text)
ls_mes   = String(sle_mes.text)
ls_nivel = String(upper(ddlb_1.Text))

DECLARE pb_usp_cntbl_rpt_detalle_gastos_r PROCEDURE FOR USP_CNTBL_RPT_DETALLE_GASTOS_R
        ( :ls_ano, :ls_mes, :ls_nivel ) ;
Execute pb_usp_cntbl_rpt_detalle_gastos_r ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cntbl_rpt_detalle_gastos_r
integer x = 23
integer y = 312
integer width = 3291
integer height = 1092
integer taborder = 50
string dataobject = "d_cntbl_rpt_detalle_gastos_r_tbl"
end type

type sle_ano from singlelineedit within w_cntbl_rpt_detalle_gastos_r
integer x = 937
integer y = 128
integer width = 192
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cntbl_rpt_detalle_gastos_r
integer x = 1600
integer y = 132
integer width = 105
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cntbl_rpt_detalle_gastos_r
integer x = 2683
integer y = 120
integer width = 270
integer height = 84
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

type st_3 from statictext within w_cntbl_rpt_detalle_gastos_r
integer x = 1161
integer y = 140
integer width = 384
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
string text = "Mes Contable"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cntbl_rpt_detalle_gastos_r
integer x = 759
integer y = 140
integer width = 155
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
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_cntbl_rpt_detalle_gastos_r
integer x = 2373
integer y = 116
integer width = 174
integer height = 476
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 16711680
string text = "none"
string item[] = {"1","2","3","4","5","6","7","8","9","10"}
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cntbl_rpt_detalle_gastos_r
integer x = 1746
integer y = 136
integer width = 567
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Nivel Cuenta Contable"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cntbl_rpt_detalle_gastos_r
integer x = 718
integer y = 56
integer width = 1888
integer height = 188
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Seleccione Parámetros "
end type

