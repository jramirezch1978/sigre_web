$PBExportHeader$w_cn727_rpt_mayor_general_resumen.srw
forward
global type w_cn727_rpt_mayor_general_resumen from w_report_smpl
end type
type cb_1 from commandbutton within w_cn727_rpt_mayor_general_resumen
end type
type sle_ano from singlelineedit within w_cn727_rpt_mayor_general_resumen
end type
type sle_mes from singlelineedit within w_cn727_rpt_mayor_general_resumen
end type
type st_10 from statictext within w_cn727_rpt_mayor_general_resumen
end type
type st_11 from statictext within w_cn727_rpt_mayor_general_resumen
end type
type rb_mensual from radiobutton within w_cn727_rpt_mayor_general_resumen
end type
type rb_acum from radiobutton within w_cn727_rpt_mayor_general_resumen
end type
type st_1 from statictext within w_cn727_rpt_mayor_general_resumen
end type
type ddlb_1 from u_ddlb within w_cn727_rpt_mayor_general_resumen
end type
type gb_12 from groupbox within w_cn727_rpt_mayor_general_resumen
end type
end forward

global type w_cn727_rpt_mayor_general_resumen from w_report_smpl
integer width = 3479
integer height = 1604
string title = "Reporte del Libro Mayor"
string menuname = "m_abc_report_smpl"
cb_1 cb_1
sle_ano sle_ano
sle_mes sle_mes
st_10 st_10
st_11 st_11
rb_mensual rb_mensual
rb_acum rb_acum
st_1 st_1
ddlb_1 ddlb_1
gb_12 gb_12
end type
global w_cn727_rpt_mayor_general_resumen w_cn727_rpt_mayor_general_resumen

type variables
Integer ii_index
end variables

on w_cn727_rpt_mayor_general_resumen.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.st_10=create st_10
this.st_11=create st_11
this.rb_mensual=create rb_mensual
this.rb_acum=create rb_acum
this.st_1=create st_1
this.ddlb_1=create ddlb_1
this.gb_12=create gb_12
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.st_10
this.Control[iCurrent+5]=this.st_11
this.Control[iCurrent+6]=this.rb_mensual
this.Control[iCurrent+7]=this.rb_acum
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.ddlb_1
this.Control[iCurrent+10]=this.gb_12
end on

on w_cn727_rpt_mayor_general_resumen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.rb_mensual)
destroy(this.rb_acum)
destroy(this.st_1)
destroy(this.ddlb_1)
destroy(this.gb_12)
end on

event ue_retrieve;String ls_ano, ls_mes, ls_tipo, ls_moneda, ls_texto, ls_empresa
Long ll_ano, ll_mes

SetPointer(HourGlass!)

/* Valores por defecto */
ls_tipo='A'
ls_moneda='S'

ls_ano = sle_ano.text
ll_ano = LONG( String( sle_ano.text) )
ll_mes = LONG( String( sle_mes.text) )

IF rb_mensual.checked = TRUE THEN
	ls_tipo = 'M'
ELSEIF rb_acum.checked = TRUE THEN
	ls_tipo = 'A'
END IF 

idw_1.Visible = True

DECLARE PB_USP_CNTBL_RPT_RES_MAYOR PROCEDURE FOR USP_CNTBL_RPT_RES_MAYOR
		  ( :ll_ano, :ll_mes, :ls_tipo, :ls_moneda ) ;
Execute PB_USP_CNTBL_RPT_RES_MAYOR ;

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
idw_1.object.t_ruc.text   = gs_ruc
idw_1.object.t_user.text     = gs_user
idw_1.object.t_moneda.text     = 'Nuevos soles'
IF gs_empresa = 'FISHOLG' then
	idw_1.object.t_1.text		= 'LIBRO MAYOR'
end if
idw_1.object.t_texto.text     = 'Mes: ' + ls_texto + ' ' + ls_ano
end event

type dw_report from w_report_smpl`dw_report within w_cn727_rpt_mayor_general_resumen
integer x = 18
integer y = 328
integer width = 3406
integer height = 988
integer taborder = 90
string dataobject = "d_rpt_mayor_resumen_tbl"
end type

type cb_1 from commandbutton within w_cn727_rpt_mayor_general_resumen
integer x = 2245
integer y = 136
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

type sle_ano from singlelineedit within w_cn727_rpt_mayor_general_resumen
integer x = 1573
integer y = 156
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

type sle_mes from singlelineedit within w_cn727_rpt_mayor_general_resumen
integer x = 1961
integer y = 156
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

type st_10 from statictext within w_cn727_rpt_mayor_general_resumen
integer x = 1815
integer y = 156
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
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type st_11 from statictext within w_cn727_rpt_mayor_general_resumen
integer x = 1394
integer y = 156
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
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_mensual from radiobutton within w_cn727_rpt_mayor_general_resumen
integer x = 114
integer y = 128
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mensual"
end type

type rb_acum from radiobutton within w_cn727_rpt_mayor_general_resumen
integer x = 114
integer y = 204
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Acumulado"
end type

type st_1 from statictext within w_cn727_rpt_mayor_general_resumen
integer x = 526
integer y = 156
integer width = 206
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda:"
boolean focusrectangle = false
end type

type ddlb_1 from u_ddlb within w_cn727_rpt_mayor_general_resumen
integer x = 741
integer y = 164
integer width = 640
integer height = 340
integer taborder = 20
boolean bringtotop = true
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'moneda_dddw'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 3                     // Longitud del campo 1
ii_lc2 = 40							// Longitud del campo 2

end event

type gb_12 from groupbox within w_cn727_rpt_mayor_general_resumen
integer x = 41
integer y = 56
integer width = 2066
integer height = 236
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

