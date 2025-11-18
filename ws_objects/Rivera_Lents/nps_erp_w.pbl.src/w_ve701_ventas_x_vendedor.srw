$PBExportHeader$w_ve701_ventas_x_vendedor.srw
forward
global type w_ve701_ventas_x_vendedor from w_report_smpl
end type
type st_1 from statictext within w_ve701_ventas_x_vendedor
end type
type st_2 from statictext within w_ve701_ventas_x_vendedor
end type
type dp_fecha1 from datepicker within w_ve701_ventas_x_vendedor
end type
type dp_fecha2 from datepicker within w_ve701_ventas_x_vendedor
end type
type cb_reporte from commandbutton within w_ve701_ventas_x_vendedor
end type
end forward

global type w_ve701_ventas_x_vendedor from w_report_smpl
integer height = 1688
string title = "[VE701] Ventas x Vendedor"
string menuname = "m_impresion"
st_1 st_1
st_2 st_2
dp_fecha1 dp_fecha1
dp_fecha2 dp_fecha2
cb_reporte cb_reporte
end type
global w_ve701_ventas_x_vendedor w_ve701_ventas_x_vendedor

on w_ve701_ventas_x_vendedor.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.st_2=create st_2
this.dp_fecha1=create dp_fecha1
this.dp_fecha2=create dp_fecha2
this.cb_reporte=create cb_reporte
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.dp_fecha1
this.Control[iCurrent+4]=this.dp_fecha2
this.Control[iCurrent+5]=this.cb_reporte
end on

on w_ve701_ventas_x_vendedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dp_fecha1)
destroy(this.dp_fecha2)
destroy(this.cb_reporte)
end on

event ue_retrieve;call super::ue_retrieve;date ld_fecha1, ld_fecha2
time t
dp_fecha1.getvalue( ld_Fecha1, t )
dp_fecha2.getvalue( ld_Fecha2, t )

dw_report.Retrieve(gnvo_app.invo_empresa.is_empresa, ld_fecha1, ld_fecha2)
dw_report.Object.p_logo.filename = gnvo_app.is_logo
end event

type p_pie from w_report_smpl`p_pie within w_ve701_ventas_x_vendedor
end type

type ole_skin from w_report_smpl`ole_skin within w_ve701_ventas_x_vendedor
end type

type uo_h from w_report_smpl`uo_h within w_ve701_ventas_x_vendedor
end type

type st_box from w_report_smpl`st_box within w_ve701_ventas_x_vendedor
end type

type phl_logonps from w_report_smpl`phl_logonps within w_ve701_ventas_x_vendedor
end type

type p_mundi from w_report_smpl`p_mundi within w_ve701_ventas_x_vendedor
end type

type p_logo from w_report_smpl`p_logo within w_ve701_ventas_x_vendedor
end type

type uo_filter from w_report_smpl`uo_filter within w_ve701_ventas_x_vendedor
end type

type st_filtro from w_report_smpl`st_filtro within w_ve701_ventas_x_vendedor
end type

type dw_report from w_report_smpl`dw_report within w_ve701_ventas_x_vendedor
integer y = 488
integer height = 960
string dataobject = "d_rpt_ventas_x_vendedor_tbl"
end type

type st_1 from statictext within w_ve701_ventas_x_vendedor
integer x = 640
integer y = 364
integer width = 311
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

type st_2 from statictext within w_ve701_ventas_x_vendedor
integer x = 1509
integer y = 356
integer width = 311
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

type dp_fecha1 from datepicker within w_ve701_ventas_x_vendedor
integer x = 942
integer y = 356
integer width = 526
integer height = 100
integer taborder = 60
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2010-06-05"), Time("19:32:43.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type dp_fecha2 from datepicker within w_ve701_ventas_x_vendedor
integer x = 1838
integer y = 348
integer width = 526
integer height = 100
integer taborder = 70
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2010-06-05"), Time("19:32:50.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type cb_reporte from commandbutton within w_ve701_ventas_x_vendedor
integer x = 2395
integer y = 324
integer width = 402
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve( )
end event

