$PBExportHeader$w_cn713_cntbl_rpt_balance_general.srw
forward
global type w_cn713_cntbl_rpt_balance_general from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn713_cntbl_rpt_balance_general
end type
type sle_mes from singlelineedit within w_cn713_cntbl_rpt_balance_general
end type
type cb_1 from commandbutton within w_cn713_cntbl_rpt_balance_general
end type
type st_3 from statictext within w_cn713_cntbl_rpt_balance_general
end type
type st_4 from statictext within w_cn713_cntbl_rpt_balance_general
end type
type st_1 from statictext within w_cn713_cntbl_rpt_balance_general
end type
type ddlb_2 from dropdownlistbox within w_cn713_cntbl_rpt_balance_general
end type
type st_2 from statictext within w_cn713_cntbl_rpt_balance_general
end type
type st_7 from statictext within w_cn713_cntbl_rpt_balance_general
end type
type em_nivel from editmask within w_cn713_cntbl_rpt_balance_general
end type
type cbx_1 from checkbox within w_cn713_cntbl_rpt_balance_general
end type
type gb_1 from groupbox within w_cn713_cntbl_rpt_balance_general
end type
type gb_2 from groupbox within w_cn713_cntbl_rpt_balance_general
end type
end forward

global type w_cn713_cntbl_rpt_balance_general from w_report_smpl
integer width = 3694
integer height = 1604
string title = "Balance general (CN713)"
string menuname = "m_abc_report_smpl"
long backcolor = 67108864
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
st_1 st_1
ddlb_2 ddlb_2
st_2 st_2
st_7 st_7
em_nivel em_nivel
cbx_1 cbx_1
gb_1 gb_1
gb_2 gb_2
end type
global w_cn713_cntbl_rpt_balance_general w_cn713_cntbl_rpt_balance_general

on w_cn713_cntbl_rpt_balance_general.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.st_1=create st_1
this.ddlb_2=create ddlb_2
this.st_2=create st_2
this.st_7=create st_7
this.em_nivel=create em_nivel
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.ddlb_2
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_7
this.Control[iCurrent+10]=this.em_nivel
this.Control[iCurrent+11]=this.cbx_1
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
end on

on w_cn713_cntbl_rpt_balance_general.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.ddlb_2)
destroy(this.st_2)
destroy(this.st_7)
destroy(this.em_nivel)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String ls_ano, ls_mes, ls_moneda
integer ln_nivel, ln_niveles

ln_nivel  = integer(em_nivel.text)
ls_moneda = upper(ddlb_2.Text)
ls_ano    = String(sle_ano.text)
ls_mes    = String(sle_mes.text)

select nro_niveles into :ln_niveles from cntblparam
  where reckey = '1' ;
  
if (ln_nivel > ln_niveles) or isnull(ln_nivel) or ln_nivel = 0 then
	MessageBox('Aviso','Número de Nivel no Existe')
	return
end if
  
DECLARE pb_usp_cntbl_rpt_balance_general PROCEDURE FOR USP_CNTBL_RPT_BALANCE_GENERAL
        ( :ls_ano, :ls_mes, :ls_moneda, :ln_nivel ) ;
Execute pb_usp_cntbl_rpt_balance_general ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn713_cntbl_rpt_balance_general
integer x = 0
integer y = 248
integer width = 3291
integer height = 1128
integer taborder = 60
string dataobject = "d_cntbl_balance_general_tbl"
end type

type sle_ano from singlelineedit within w_cn713_cntbl_rpt_balance_general
integer x = 1211
integer y = 80
integer width = 192
integer height = 72
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

type sle_mes from singlelineedit within w_cn713_cntbl_rpt_balance_general
integer x = 1586
integer y = 80
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

type cb_1 from commandbutton within w_cn713_cntbl_rpt_balance_general
integer x = 3337
integer y = 52
integer width = 297
integer height = 92
integer taborder = 50
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

type st_3 from statictext within w_cn713_cntbl_rpt_balance_general
integer x = 1422
integer y = 88
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
long backcolor = 67108864
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn713_cntbl_rpt_balance_general
integer x = 1047
integer y = 88
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
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn713_cntbl_rpt_balance_general
integer y = 72
integer width = 928
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "BALANCE GENERAL"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type ddlb_2 from dropdownlistbox within w_cn713_cntbl_rpt_balance_general
integer x = 2469
integer y = 68
integer width = 215
integer height = 352
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
string text = "none"
string item[] = {"S/.","US$"}
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cn713_cntbl_rpt_balance_general
integer x = 1870
integer y = 84
integer width = 169
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 67108864
string text = "Nivel"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_cn713_cntbl_rpt_balance_general
integer x = 2222
integer y = 88
integer width = 242
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_nivel from editmask within w_cn713_cntbl_rpt_balance_general
integer x = 2048
integer y = 76
integer width = 155
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 16711680
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type cbx_1 from checkbox within w_cn713_cntbl_rpt_balance_general
integer x = 2747
integer y = 72
integer width = 485
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

type gb_1 from groupbox within w_cn713_cntbl_rpt_balance_general
integer x = 1010
integer y = 4
integer width = 745
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
end type

type gb_2 from groupbox within w_cn713_cntbl_rpt_balance_general
integer x = 1829
integer width = 910
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 255
long backcolor = 67108864
string text = " Seleccione "
end type

