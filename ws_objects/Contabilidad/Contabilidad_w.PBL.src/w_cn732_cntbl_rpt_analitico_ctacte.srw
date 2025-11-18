$PBExportHeader$w_cn732_cntbl_rpt_analitico_ctacte.srw
forward
global type w_cn732_cntbl_rpt_analitico_ctacte from w_report_smpl
end type
type cb_1 from commandbutton within w_cn732_cntbl_rpt_analitico_ctacte
end type
type sle_cuenta from singlelineedit within w_cn732_cntbl_rpt_analitico_ctacte
end type
type cb_4 from commandbutton within w_cn732_cntbl_rpt_analitico_ctacte
end type
type st_3 from statictext within w_cn732_cntbl_rpt_analitico_ctacte
end type
type sle_ano from singlelineedit within w_cn732_cntbl_rpt_analitico_ctacte
end type
type sle_mes from singlelineedit within w_cn732_cntbl_rpt_analitico_ctacte
end type
type st_20 from statictext within w_cn732_cntbl_rpt_analitico_ctacte
end type
type st_21 from statictext within w_cn732_cntbl_rpt_analitico_ctacte
end type
type gb_22 from groupbox within w_cn732_cntbl_rpt_analitico_ctacte
end type
end forward

global type w_cn732_cntbl_rpt_analitico_ctacte from w_report_smpl
integer width = 3397
integer height = 1604
string title = "Mayor Analítico de Cuenta Corriente (CN732)"
string menuname = "m_abc_report_smpl"
cb_1 cb_1
sle_cuenta sle_cuenta
cb_4 cb_4
st_3 st_3
sle_ano sle_ano
sle_mes sle_mes
st_20 st_20
st_21 st_21
gb_22 gb_22
end type
global w_cn732_cntbl_rpt_analitico_ctacte w_cn732_cntbl_rpt_analitico_ctacte

type variables
String is_opcion

end variables

on w_cn732_cntbl_rpt_analitico_ctacte.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_cuenta=create sle_cuenta
this.cb_4=create cb_4
this.st_3=create st_3
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.st_20=create st_20
this.st_21=create st_21
this.gb_22=create gb_22
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_cuenta
this.Control[iCurrent+3]=this.cb_4
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.sle_ano
this.Control[iCurrent+6]=this.sle_mes
this.Control[iCurrent+7]=this.st_20
this.Control[iCurrent+8]=this.st_21
this.Control[iCurrent+9]=this.gb_22
end on

on w_cn732_cntbl_rpt_analitico_ctacte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_cuenta)
destroy(this.cb_4)
destroy(this.st_3)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_20)
destroy(this.st_21)
destroy(this.gb_22)
end on

event ue_retrieve;call super::ue_retrieve;Integer	li_year, li_mes
String 	ls_cuenta

if sle_ano.text = '' or IsNull(sle_ano.text) then
	
	sle_ano.setFocus()
	return
end if

li_year   = Integer(sle_ano.text)
li_mes    = Integer(sle_mes.text)
ls_cuenta = TRIM(sle_cuenta.text) + '%'

dw_report.retrieve(li_year, li_mes, ls_cuenta)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn732_cntbl_rpt_analitico_ctacte
integer x = 0
integer y = 208
integer width = 3319
integer height = 1100
integer taborder = 60
string dataobject = "d_cntbl_rpt_analitico_ctate_tbl"
end type

type cb_1 from commandbutton within w_cn732_cntbl_rpt_analitico_ctacte
integer x = 1627
integer y = 64
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

type sle_cuenta from singlelineedit within w_cn732_cntbl_rpt_analitico_ctacte
integer x = 1019
integer y = 76
integer width = 329
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

type cb_4 from commandbutton within w_cn732_cntbl_rpt_analitico_ctacte
integer x = 1399
integer y = 76
integer width = 87
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_cnta_cntbl 	lstr_cnta

lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()

if lstr_cnta.b_return = true then
	sle_cuenta.text  = lstr_cnta.cnta_cntbl
end if

		
	


end event

type st_3 from statictext within w_cn732_cntbl_rpt_analitico_ctacte
integer x = 795
integer y = 84
integer width = 187
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
string text = "Cuenta"
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn732_cntbl_rpt_analitico_ctacte
integer x = 233
integer y = 76
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

type sle_mes from singlelineedit within w_cn732_cntbl_rpt_analitico_ctacte
integer x = 640
integer y = 76
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

type st_20 from statictext within w_cn732_cntbl_rpt_analitico_ctacte
integer x = 466
integer y = 84
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
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_21 from statictext within w_cn732_cntbl_rpt_analitico_ctacte
integer x = 64
integer y = 84
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

type gb_22 from groupbox within w_cn732_cntbl_rpt_analitico_ctacte
integer width = 1563
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

