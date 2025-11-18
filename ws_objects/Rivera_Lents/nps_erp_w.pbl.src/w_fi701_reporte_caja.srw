$PBExportHeader$w_fi701_reporte_caja.srw
forward
global type w_fi701_reporte_caja from w_report_smpl
end type
type sle_banco from singlelineedit within w_fi701_reporte_caja
end type
type sle_descrip from singlelineedit within w_fi701_reporte_caja
end type
type cb_reporte from commandbutton within w_fi701_reporte_caja
end type
type st_1 from statictext within w_fi701_reporte_caja
end type
type st_2 from statictext within w_fi701_reporte_caja
end type
type dp_fecha1 from datepicker within w_fi701_reporte_caja
end type
type dp_fecha2 from datepicker within w_fi701_reporte_caja
end type
type gb_1 from groupbox within w_fi701_reporte_caja
end type
end forward

global type w_fi701_reporte_caja from w_report_smpl
integer width = 4073
integer height = 1688
string title = "[FI701] Reporte de Caja Bancos"
string menuname = "m_impresion"
sle_banco sle_banco
sle_descrip sle_descrip
cb_reporte cb_reporte
st_1 st_1
st_2 st_2
dp_fecha1 dp_fecha1
dp_fecha2 dp_fecha2
gb_1 gb_1
end type
global w_fi701_reporte_caja w_fi701_reporte_caja

on w_fi701_reporte_caja.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_banco=create sle_banco
this.sle_descrip=create sle_descrip
this.cb_reporte=create cb_reporte
this.st_1=create st_1
this.st_2=create st_2
this.dp_fecha1=create dp_fecha1
this.dp_fecha2=create dp_fecha2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_banco
this.Control[iCurrent+2]=this.sle_descrip
this.Control[iCurrent+3]=this.cb_reporte
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.dp_fecha1
this.Control[iCurrent+7]=this.dp_fecha2
this.Control[iCurrent+8]=this.gb_1
end on

on w_fi701_reporte_caja.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_banco)
destroy(this.sle_descrip)
destroy(this.cb_reporte)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dp_fecha1)
destroy(this.dp_fecha2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_codigo
date ld_fecha1, ld_fecha2
time t

dp_fecha1.getvalue( ld_Fecha1, t )
dp_fecha2.getvalue( ld_Fecha2, t )

ls_codigo = sle_banco.text

if ls_codigo = "" then
	MessageBox('Error', 'Debe especificar un banco')
	sle_banco.SetFocus()
	return
end if

dw_report.Retrieve(ls_codigo, ld_fecha1, ld_fecha2 )

dw_report.visible = true
dw_report.Object.p_logo.filename = gnvo_app.is_logo
dw_report.object.Datawindow.Print.Orientation = 2
dw_report.object.Datawindow.Print.Paper.Size = 9
end event

type p_pie from w_report_smpl`p_pie within w_fi701_reporte_caja
end type

type ole_skin from w_report_smpl`ole_skin within w_fi701_reporte_caja
end type

type uo_h from w_report_smpl`uo_h within w_fi701_reporte_caja
end type

type st_box from w_report_smpl`st_box within w_fi701_reporte_caja
end type

type phl_logonps from w_report_smpl`phl_logonps within w_fi701_reporte_caja
end type

type p_mundi from w_report_smpl`p_mundi within w_fi701_reporte_caja
end type

type p_logo from w_report_smpl`p_logo within w_fi701_reporte_caja
end type

type uo_filter from w_report_smpl`uo_filter within w_fi701_reporte_caja
end type

type st_filtro from w_report_smpl`st_filtro within w_fi701_reporte_caja
end type

type dw_report from w_report_smpl`dw_report within w_fi701_reporte_caja
integer x = 507
integer y = 464
integer height = 748
string dataobject = "d_rpt_reporte_caja_tbl"
end type

type sle_banco from singlelineedit within w_fi701_reporte_caja
event dobleclick pbm_lbuttondblclk
integer x = 571
integer y = 348
integer width = 224
integer height = 88
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_banco AS CODIGO_banco, " &
	  	 + "nom_banco AS nombre_banco " &
	    + "FROM banco " &
		 + "where cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de banco')
	return
end if

SELECT nom_banco 
	INTO :ls_desc
FROM banco
where cod_banco = :ls_codigo 
  and cod_empresa = :gnvo_app.invo_empresa.is_empresa;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de ls_codigo no existe o no es un ls_codigo de la empresa')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_fi701_reporte_caja
integer x = 800
integer y = 348
integer width = 1102
integer height = 88
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_reporte from commandbutton within w_fi701_reporte_caja
integer x = 3598
integer y = 324
integer width = 402
integer height = 112
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve( )
end event

type st_1 from statictext within w_fi701_reporte_caja
integer x = 1952
integer y = 356
integer width = 229
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Desde:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi701_reporte_caja
integer x = 2734
integer y = 356
integer width = 229
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Hasta:"
boolean focusrectangle = false
end type

type dp_fecha1 from datepicker within w_fi701_reporte_caja
integer x = 2190
integer y = 340
integer width = 526
integer height = 100
integer taborder = 130
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2010-07-31"), Time("14:29:06.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type dp_fecha2 from datepicker within w_fi701_reporte_caja
integer x = 2971
integer y = 340
integer width = 526
integer height = 100
integer taborder = 120
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2010-07-31"), Time("14:29:06.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type gb_1 from groupbox within w_fi701_reporte_caja
integer x = 544
integer y = 272
integer width = 1376
integer height = 184
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Caja o Banco:"
end type

