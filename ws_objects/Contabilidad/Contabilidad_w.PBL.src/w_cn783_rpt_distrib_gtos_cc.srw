$PBExportHeader$w_cn783_rpt_distrib_gtos_cc.srw
forward
global type w_cn783_rpt_distrib_gtos_cc from w_report_smpl
end type
type cb_1 from commandbutton within w_cn783_rpt_distrib_gtos_cc
end type
type sle_ano from singlelineedit within w_cn783_rpt_distrib_gtos_cc
end type
type sle_mes from singlelineedit within w_cn783_rpt_distrib_gtos_cc
end type
type st_10 from statictext within w_cn783_rpt_distrib_gtos_cc
end type
type st_11 from statictext within w_cn783_rpt_distrib_gtos_cc
end type
type em_nivel from editmask within w_cn783_rpt_distrib_gtos_cc
end type
type rb_nivel from radiobutton within w_cn783_rpt_distrib_gtos_cc
end type
type rb_1 from radiobutton within w_cn783_rpt_distrib_gtos_cc
end type
type gb_12 from groupbox within w_cn783_rpt_distrib_gtos_cc
end type
type gb_1 from groupbox within w_cn783_rpt_distrib_gtos_cc
end type
end forward

global type w_cn783_rpt_distrib_gtos_cc from w_report_smpl
integer width = 3479
integer height = 1604
string title = "Libro de inventario resumen (CN780)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
boolean righttoleft = true
cb_1 cb_1
sle_ano sle_ano
sle_mes sle_mes
st_10 st_10
st_11 st_11
em_nivel em_nivel
rb_nivel rb_nivel
rb_1 rb_1
gb_12 gb_12
gb_1 gb_1
end type
global w_cn783_rpt_distrib_gtos_cc w_cn783_rpt_distrib_gtos_cc

on w_cn783_rpt_distrib_gtos_cc.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.st_10=create st_10
this.st_11=create st_11
this.em_nivel=create em_nivel
this.rb_nivel=create rb_nivel
this.rb_1=create rb_1
this.gb_12=create gb_12
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.st_10
this.Control[iCurrent+5]=this.st_11
this.Control[iCurrent+6]=this.em_nivel
this.Control[iCurrent+7]=this.rb_nivel
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.gb_12
this.Control[iCurrent+10]=this.gb_1
end on

on w_cn783_rpt_distrib_gtos_cc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.em_nivel)
destroy(this.rb_nivel)
destroy(this.rb_1)
destroy(this.gb_12)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_ano, ls_mes, ls_texto, ls_almacen, ls_nivel
Long ll_ano, ll_mes

ls_ano = String(sle_ano.text)
ls_mes = String(sle_mes.text)
ls_nivel = TRIM(em_nivel.text)
ll_ano = LONG( ls_ano )
ll_mes = LONG( ls_mes )
ls_texto = 'Año ' + ls_ano + ' - Mes ' + ls_mes

SetPointer(HourGlass!)

DECLARE PB_USP_CNT_GASTOS_CC_X_NIVEL PROCEDURE FOR USP_CNT_GASTOS_CC_X_NIVEL
		  ( :ll_ano, :ll_mes ) ;
Execute PB_USP_CNT_GASTOS_CC_X_NIVEL ;

IF ls_nivel='1' THEN
	idw_1.dataobject='d_rpt_distrib_cc_n1_tbl'
	ls_texto = ls_texto + ' - Nivel 1'
ELSEIF ls_nivel='2' THEN
	idw_1.dataobject='d_rpt_distrib_cc_n2_tbl'
	ls_texto = ls_texto + ' - Nivel 2'
ELSEIF ls_nivel='3' THEN
	idw_1.dataobject='d_rpt_distrib_cc_n3_tbl'	
	ls_texto = ls_texto + ' - Nivel 3'
ELSE
	idw_1.dataobject='d_rpt_distrib_cc_n4_tbl'
	ls_texto = ls_texto + ' - Detalle x centro costo'	
END IF

idw_1.SettransObject(sqlca)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_texto.text = ls_texto
idw_1.object.t_user.text = gs_user
idw_1.object.t_empresa.text = gs_empresa

ib_preview = FALSE
idw_1.ii_zoom_actual = 100
//Parent.Event ue_preview()
Event ue_preview()

idw_1.retrieve()

SetPointer(Arrow!)


end event

type dw_report from w_report_smpl`dw_report within w_cn783_rpt_distrib_gtos_cc
integer x = 23
integer y = 316
integer width = 3406
integer height = 1096
integer taborder = 90
string dataobject = "d_rpt_distrib_cc_n1_tbl"
end type

type cb_1 from commandbutton within w_cn783_rpt_distrib_gtos_cc
integer x = 1842
integer y = 116
integer width = 315
integer height = 92
integer taborder = 80
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

type sle_ano from singlelineedit within w_cn783_rpt_distrib_gtos_cc
integer x = 1111
integer y = 128
integer width = 192
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn783_rpt_distrib_gtos_cc
integer x = 1595
integer y = 128
integer width = 105
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_cn783_rpt_distrib_gtos_cc
integer x = 1399
integer y = 136
integer width = 169
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
string text = "Mes:"
boolean focusrectangle = false
end type

type st_11 from statictext within w_cn783_rpt_distrib_gtos_cc
integer x = 942
integer y = 136
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
string text = "Año :"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_nivel from editmask within w_cn783_rpt_distrib_gtos_cc
integer x = 608
integer y = 88
integer width = 101
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "1"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "#"
end type

type rb_nivel from radiobutton within w_cn783_rpt_distrib_gtos_cc
integer x = 87
integer y = 88
integer width = 507
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "x nivel CC [1-3] :"
boolean checked = true
end type

event clicked;IF em_nivel.text = '0' THEN
	em_nivel.text = '1'
END IF
end event

type rb_1 from radiobutton within w_cn783_rpt_distrib_gtos_cc
integer x = 87
integer y = 188
integer width = 507
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Detalle"
end type

event clicked;em_nivel.text = '0'
end event

type gb_12 from groupbox within w_cn783_rpt_distrib_gtos_cc
integer x = 910
integer y = 52
integer width = 1298
integer height = 200
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

type gb_1 from groupbox within w_cn783_rpt_distrib_gtos_cc
integer x = 59
integer y = 24
integer width = 695
integer height = 252
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = "Parámetro"
end type

