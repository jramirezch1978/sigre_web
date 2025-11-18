$PBExportHeader$w_cntbl_rpt_detalle_gastos_c.srw
forward
global type w_cntbl_rpt_detalle_gastos_c from w_report_smpl
end type
type sle_ano from singlelineedit within w_cntbl_rpt_detalle_gastos_c
end type
type sle_mes from singlelineedit within w_cntbl_rpt_detalle_gastos_c
end type
type cb_1 from commandbutton within w_cntbl_rpt_detalle_gastos_c
end type
type st_3 from statictext within w_cntbl_rpt_detalle_gastos_c
end type
type st_4 from statictext within w_cntbl_rpt_detalle_gastos_c
end type
type rb_1 from radiobutton within w_cntbl_rpt_detalle_gastos_c
end type
type rb_2 from radiobutton within w_cntbl_rpt_detalle_gastos_c
end type
type gb_1 from groupbox within w_cntbl_rpt_detalle_gastos_c
end type
type gb_2 from groupbox within w_cntbl_rpt_detalle_gastos_c
end type
end forward

global type w_cntbl_rpt_detalle_gastos_c from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Resumen General a Nivel de Cuenta por Divisiones"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
gb_2 gb_2
end type
global w_cntbl_rpt_detalle_gastos_c w_cntbl_rpt_detalle_gastos_c

on w_cntbl_rpt_detalle_gastos_c.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_cntbl_rpt_detalle_gastos_c.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve();call super::ue_retrieve;String ls_ano, ls_mes, ls_tipo

ls_ano   = String(sle_ano.text)
ls_mes   = String(sle_mes.text)

if rb_1.checked = true then
	ls_tipo = '9'
elseif rb_2.checked = true then
	ls_tipo = '6'
end if

DECLARE pb_usp_cntbl_rpt_detalle_gastos_c PROCEDURE FOR USP_CNTBL_RPT_DETALLE_GASTOS_C
        ( :ls_ano, :ls_mes, :ls_tipo ) ;
Execute pb_usp_cntbl_rpt_detalle_gastos_c ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cntbl_rpt_detalle_gastos_c
integer x = 23
integer y = 280
integer width = 3291
integer height = 1124
integer taborder = 50
string dataobject = "d_cntbl_rpt_detalle_gastos_c_tbl"
end type

type sle_ano from singlelineedit within w_cntbl_rpt_detalle_gastos_c
integer x = 1659
integer y = 116
integer width = 192
integer height = 76
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

type sle_mes from singlelineedit within w_cntbl_rpt_detalle_gastos_c
integer x = 2322
integer y = 120
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

type cb_1 from commandbutton within w_cntbl_rpt_detalle_gastos_c
integer x = 2610
integer y = 108
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

type st_3 from statictext within w_cntbl_rpt_detalle_gastos_c
integer x = 1883
integer y = 128
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

type st_4 from statictext within w_cntbl_rpt_detalle_gastos_c
integer x = 1481
integer y = 128
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

type rb_1 from radiobutton within w_cntbl_rpt_detalle_gastos_c
integer x = 635
integer y = 116
integer width = 297
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Clase 9"
borderstyle borderstyle = styleraised!
end type

type rb_2 from radiobutton within w_cntbl_rpt_detalle_gastos_c
integer x = 1010
integer y = 116
integer width = 297
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 12632256
string text = "Clase 6"
borderstyle borderstyle = styleraised!
end type

type gb_1 from groupbox within w_cntbl_rpt_detalle_gastos_c
integer x = 1440
integer y = 44
integer width = 1088
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
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_cntbl_rpt_detalle_gastos_c
integer x = 576
integer y = 44
integer width = 795
integer height = 188
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Seleccione Cuenta "
borderstyle borderstyle = stylelowered!
end type

