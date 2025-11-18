$PBExportHeader$w_cn726_rpt_mayor_resumen.srw
forward
global type w_cn726_rpt_mayor_resumen from w_report_smpl
end type
type cb_1 from commandbutton within w_cn726_rpt_mayor_resumen
end type
type sle_ano from singlelineedit within w_cn726_rpt_mayor_resumen
end type
type sle_mes from singlelineedit within w_cn726_rpt_mayor_resumen
end type
type st_10 from statictext within w_cn726_rpt_mayor_resumen
end type
type st_11 from statictext within w_cn726_rpt_mayor_resumen
end type
type rb_mensual from radiobutton within w_cn726_rpt_mayor_resumen
end type
type rb_acum from radiobutton within w_cn726_rpt_mayor_resumen
end type
type st_1 from statictext within w_cn726_rpt_mayor_resumen
end type
type ddlb_1 from dropdownlistbox within w_cn726_rpt_mayor_resumen
end type
type gb_12 from groupbox within w_cn726_rpt_mayor_resumen
end type
end forward

global type w_cn726_rpt_mayor_resumen from w_report_smpl
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
rb_mensual rb_mensual
rb_acum rb_acum
st_1 st_1
ddlb_1 ddlb_1
gb_12 gb_12
end type
global w_cn726_rpt_mayor_resumen w_cn726_rpt_mayor_resumen

on w_cn726_rpt_mayor_resumen.create
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

on w_cn726_rpt_mayor_resumen.destroy
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

event ue_retrieve;String ls_ano, ls_mes, ls_tipo, ls_moneda
Long ll_ano, ll_mes

/* Valores por defecto */
ls_tipo='A'
ls_moneda='S'

ll_ano = LONG( String( sle_ano.text) )
ll_mes = LONG( String( sle_mes.text) )

IF rb_mensual.checked = TRUE THEN
	ls_tipo = 'M'
ELSEIF rb_acum.checked = TRUE THEN
	ls_tipo = 'A'
//ELSEIF rb_sol.checked = TRUE THEN
	ls_moneda = 'S'
//ELSEIF rb_dolar.checked = TRUE THEN
	ls_moneda = 'D'
END IF 


	
DECLARE PB_USP_CNTBL_RPT_RES_MAYOR PROCEDURE FOR USP_CNTBL_RPT_RES_MAYOR
		  ( :ll_ano, :ll_mes, :ls_tipo, :ls_moneda ) ;
Execute PB_USP_CNTBL_RPT_RES_MAYOR ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text   = gs_empresa
dw_report.object.t_user.text     = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn726_rpt_mayor_resumen
integer x = 23
integer y = 316
integer width = 3406
integer height = 1096
integer taborder = 90
string dataobject = "d_cntbl_rpt_libro_mayor_tbl"
end type

type cb_1 from commandbutton within w_cn726_rpt_mayor_resumen
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

type sle_ano from singlelineedit within w_cn726_rpt_mayor_resumen
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

type sle_mes from singlelineedit within w_cn726_rpt_mayor_resumen
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

type st_10 from statictext within w_cn726_rpt_mayor_resumen
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
long backcolor = 12632256
string text = "Mes"
boolean focusrectangle = false
end type

type st_11 from statictext within w_cn726_rpt_mayor_resumen
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
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_mensual from radiobutton within w_cn726_rpt_mayor_resumen
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
long backcolor = 12632256
string text = "Mensual"
borderstyle borderstyle = stylelowered!
end type

type rb_acum from radiobutton within w_cn726_rpt_mayor_resumen
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
long backcolor = 12632256
string text = "Acumulado"
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn726_rpt_mayor_resumen
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
long backcolor = 12632256
string text = "Moneda:"
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_cn726_rpt_mayor_resumen
integer x = 731
integer y = 156
integer width = 640
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

event constructor;Long ll_filas, ll_fila
DataStore ds_moneda
ds_moneda = Create DataStore
ds_moneda.DataObject = 'd_dddw_moneda'
ds_moneda.SetTransObject ( SQLCA ) ;
ll_filas = ds_moneda.Retrieve()
For ll_fila = 1 to ll_filas
	 ddlb_1.AddItem ( ds_moneda.object.cod_moneda  [ll_fila] + ' ' + &
	                  ds_moneda.object.descripcion [ll_fila] )
Next

end event

type gb_12 from groupbox within w_cn726_rpt_mayor_resumen
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
long backcolor = 12632256
string text = " Periodo Contable "
borderstyle borderstyle = stylelowered!
end type

