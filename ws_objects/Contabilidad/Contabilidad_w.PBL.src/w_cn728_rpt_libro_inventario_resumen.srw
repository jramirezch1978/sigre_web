$PBExportHeader$w_cn728_rpt_libro_inventario_resumen.srw
forward
global type w_cn728_rpt_libro_inventario_resumen from w_report_smpl
end type
type cb_1 from commandbutton within w_cn728_rpt_libro_inventario_resumen
end type
type sle_ano from singlelineedit within w_cn728_rpt_libro_inventario_resumen
end type
type sle_mes from singlelineedit within w_cn728_rpt_libro_inventario_resumen
end type
type st_10 from statictext within w_cn728_rpt_libro_inventario_resumen
end type
type st_11 from statictext within w_cn728_rpt_libro_inventario_resumen
end type
type gb_12 from groupbox within w_cn728_rpt_libro_inventario_resumen
end type
end forward

global type w_cn728_rpt_libro_inventario_resumen from w_report_smpl
integer width = 3479
integer height = 1604
string title = "Reporte del Libro Mayor"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
sle_ano sle_ano
sle_mes sle_mes
st_10 st_10
st_11 st_11
gb_12 gb_12
end type
global w_cn728_rpt_libro_inventario_resumen w_cn728_rpt_libro_inventario_resumen

on w_cn728_rpt_libro_inventario_resumen.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.st_10=create st_10
this.st_11=create st_11
this.gb_12=create gb_12
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.st_10
this.Control[iCurrent+5]=this.st_11
this.Control[iCurrent+6]=this.gb_12
end on

on w_cn728_rpt_libro_inventario_resumen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.gb_12)
end on

event ue_retrieve;String ls_ano, ls_mes, ls_texto, ls_empresa
Long ll_ano, ll_mes

SetPointer(HourGlass!)

/* Valores por defecto */

ls_ano = sle_ano.text
ll_ano = LONG( String( sle_ano.text) )
ll_mes = LONG( String( sle_mes.text) )

idw_1.Visible = True

DECLARE PB_USP_CNT_RPT_LIB_INV_CNTA PROCEDURE FOR USP_CNT_RPT_LIB_INV_CNTA
		  ( :ll_ano, :ll_mes ) ;
Execute PB_USP_CNT_RPT_LIB_INV_CNTA ;

SELECT USF_CNT_MES_TEXTO(:ll_mes) 
INTO :ls_texto 
FROM dual ;

SELECT e.nombre 
INTO :ls_empresa
FROM genparam g, empresa e
WHERE g.cod_empresa = e.cod_empresa AND g.reckey = '1' ;

SetPointer(Arrow!)

idw_1.retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text   = ls_empresa
idw_1.object.t_user.text     = gs_user
idw_1.object.t_texto.text     = 'Mes: ' + ls_texto + ' ' + ls_ano + '  -  Nuevos soles'
end event

type dw_report from w_report_smpl`dw_report within w_cn728_rpt_libro_inventario_resumen
integer x = 18
integer y = 292
integer width = 3406
integer height = 1024
integer taborder = 90
string dataobject = "d_rpt_libro_inv_x_cnta"
end type

type cb_1 from commandbutton within w_cn728_rpt_libro_inventario_resumen
integer x = 2208
integer y = 84
integer width = 297
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

type sle_ano from singlelineedit within w_cn728_rpt_libro_inventario_resumen
integer x = 247
integer y = 132
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
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn728_rpt_libro_inventario_resumen
integer x = 635
integer y = 132
integer width = 105
integer height = 76
integer taborder = 60
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

type st_10 from statictext within w_cn728_rpt_libro_inventario_resumen
integer x = 489
integer y = 132
integer width = 133
integer height = 76
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
boolean focusrectangle = false
end type

type st_11 from statictext within w_cn728_rpt_libro_inventario_resumen
integer x = 69
integer y = 132
integer width = 155
integer height = 76
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

type gb_12 from groupbox within w_cn728_rpt_libro_inventario_resumen
integer x = 41
integer y = 56
integer width = 763
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

