$PBExportHeader$w_cn731_cntbl_rpt_caja_bancos.srw
forward
global type w_cn731_cntbl_rpt_caja_bancos from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn731_cntbl_rpt_caja_bancos
end type
type sle_mes from singlelineedit within w_cn731_cntbl_rpt_caja_bancos
end type
type cb_1 from commandbutton within w_cn731_cntbl_rpt_caja_bancos
end type
type st_3 from statictext within w_cn731_cntbl_rpt_caja_bancos
end type
type st_4 from statictext within w_cn731_cntbl_rpt_caja_bancos
end type
type st_1 from statictext within w_cn731_cntbl_rpt_caja_bancos
end type
type gb_1 from groupbox within w_cn731_cntbl_rpt_caja_bancos
end type
end forward

global type w_cn731_cntbl_rpt_caja_bancos from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Libro de caja bancos (CN731)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
st_1 st_1
gb_1 gb_1
end type
global w_cn731_cntbl_rpt_caja_bancos w_cn731_cntbl_rpt_caja_bancos

on w_cn731_cntbl_rpt_caja_bancos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.gb_1
end on

on w_cn731_cntbl_rpt_caja_bancos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.gb_1)
end on

event ue_retrieve();call super::ue_retrieve;String ls_ano, ls_mes

ls_ano = String(sle_ano.text)
ls_mes = String(sle_mes.text)

DECLARE pb_usp_cntbl_rpt_caja_bancos PROCEDURE FOR USP_CNTBL_RPT_CAJA_BANCOS
        ( :ls_ano, :ls_mes ) ;
Execute pb_usp_cntbl_rpt_caja_bancos ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_mes.text = ls_mes
dw_report.object.t_ano.text = ls_ano

end event

type dw_report from w_report_smpl`dw_report within w_cn731_cntbl_rpt_caja_bancos
integer x = 23
integer y = 300
integer width = 3291
integer height = 1104
integer taborder = 50
string dataobject = "d_cntbl_rpt_caja_bancos_tbl"
end type

type sle_ano from singlelineedit within w_cn731_cntbl_rpt_caja_bancos
integer x = 2313
integer y = 124
integer width = 192
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

type sle_mes from singlelineedit within w_cn731_cntbl_rpt_caja_bancos
integer x = 2688
integer y = 124
integer width = 105
integer height = 72
integer taborder = 30
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

type cb_1 from commandbutton within w_cn731_cntbl_rpt_caja_bancos
integer x = 2926
integer y = 108
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

type st_3 from statictext within w_cn731_cntbl_rpt_caja_bancos
integer x = 2523
integer y = 132
integer width = 160
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
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn731_cntbl_rpt_caja_bancos
integer x = 2149
integer y = 132
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

type st_1 from statictext within w_cn731_cntbl_rpt_caja_bancos
integer x = 370
integer y = 116
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
string text = "REPORTE CONTABLE DE CAJA BANCOS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn731_cntbl_rpt_caja_bancos
integer x = 2112
integer y = 48
integer width = 745
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Periodo Contable "
end type

