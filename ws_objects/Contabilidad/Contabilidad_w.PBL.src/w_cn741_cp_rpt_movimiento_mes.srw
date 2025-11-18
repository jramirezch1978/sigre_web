$PBExportHeader$w_cn741_cp_rpt_movimiento_mes.srw
forward
global type w_cn741_cp_rpt_movimiento_mes from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn741_cp_rpt_movimiento_mes
end type
type sle_mes from singlelineedit within w_cn741_cp_rpt_movimiento_mes
end type
type cb_1 from commandbutton within w_cn741_cp_rpt_movimiento_mes
end type
type st_3 from statictext within w_cn741_cp_rpt_movimiento_mes
end type
type st_4 from statictext within w_cn741_cp_rpt_movimiento_mes
end type
type st_1 from statictext within w_cn741_cp_rpt_movimiento_mes
end type
type st_2 from statictext within w_cn741_cp_rpt_movimiento_mes
end type
type gb_1 from groupbox within w_cn741_cp_rpt_movimiento_mes
end type
end forward

global type w_cn741_cp_rpt_movimiento_mes from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Resumen mov. mensuales costos produccion (CN741)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
st_1 st_1
st_2 st_2
gb_1 gb_1
end type
global w_cn741_cp_rpt_movimiento_mes w_cn741_cp_rpt_movimiento_mes

on w_cn741_cp_rpt_movimiento_mes.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_cn741_cp_rpt_movimiento_mes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_ano, ls_mes
ls_ano = String(sle_ano.text)
ls_mes = String(sle_mes.text)

DECLARE pb_usp_cp_rpt_movimiento_mes PROCEDURE FOR USP_CP_RPT_MOVIMIENTO_MES
        ( :ls_ano, :ls_mes ) ;
Execute pb_usp_cp_rpt_movimiento_mes ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
if gs_origen = 'PR' then
	dw_report.object.t_32.text = 'MOVIMIENTO MENSUAL DE COSTOS DE PRODUCCION DE AZUCAR'
elseif gs_origen = 'IN' then
	dw_report.object.t_32.text = 'MOVIMIENTO MENSUAL DE COSTOS DE PRODUCCION DE CAÑA'
end if


end event

type dw_report from w_report_smpl`dw_report within w_cn741_cp_rpt_movimiento_mes
integer x = 23
integer y = 364
integer width = 3287
integer height = 1040
integer taborder = 40
string dataobject = "d_cp_rpt_movimiento_mes_tbl"
end type

type sle_ano from singlelineedit within w_cn741_cp_rpt_movimiento_mes
integer x = 2336
integer y = 160
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
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn741_cp_rpt_movimiento_mes
integer x = 2757
integer y = 160
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
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn741_cp_rpt_movimiento_mes
integer x = 2994
integer y = 156
integer width = 274
integer height = 80
integer taborder = 30
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

type st_3 from statictext within w_cn741_cp_rpt_movimiento_mes
integer x = 2560
integer y = 176
integer width = 178
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

type st_4 from statictext within w_cn741_cp_rpt_movimiento_mes
integer x = 2130
integer y = 176
integer width = 174
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

type st_1 from statictext within w_cn741_cp_rpt_movimiento_mes
integer x = 297
integer y = 72
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
string text = "RESUMEN DE MOVIMIENTOS MENSUALES"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn741_cp_rpt_movimiento_mes
integer x = 430
integer y = 192
integer width = 1381
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
string text = "COSTOS DE PRODUCCION AZUCAR"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn741_cp_rpt_movimiento_mes
integer x = 2098
integer y = 92
integer width = 823
integer height = 180
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

