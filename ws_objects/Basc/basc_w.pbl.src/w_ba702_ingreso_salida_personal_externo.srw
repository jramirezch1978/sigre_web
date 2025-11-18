$PBExportHeader$w_ba702_ingreso_salida_personal_externo.srw
forward
global type w_ba702_ingreso_salida_personal_externo from w_report_smpl
end type
type cb_1 from commandbutton within w_ba702_ingreso_salida_personal_externo
end type
type dp_1 from datepicker within w_ba702_ingreso_salida_personal_externo
end type
type st_1 from statictext within w_ba702_ingreso_salida_personal_externo
end type
type dp_2 from datepicker within w_ba702_ingreso_salida_personal_externo
end type
type gb_2 from groupbox within w_ba702_ingreso_salida_personal_externo
end type
end forward

global type w_ba702_ingreso_salida_personal_externo from w_report_smpl
integer width = 2853
integer height = 1203
string title = "(BA702) Control de Ingreso y Salida de Visitantes"
string menuname = "m_reporte"
cb_1 cb_1
dp_1 dp_1
st_1 st_1
dp_2 dp_2
gb_2 gb_2
end type
global w_ba702_ingreso_salida_personal_externo w_ba702_ingreso_salida_personal_externo

type variables

end variables

on w_ba702_ingreso_salida_personal_externo.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.dp_1=create dp_1
this.st_1=create st_1
this.dp_2=create dp_2
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dp_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dp_2
this.Control[iCurrent+5]=this.gb_2
end on

on w_ba702_ingreso_salida_personal_externo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dp_1)
destroy(this.st_1)
destroy(this.dp_2)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;
dw_report.settransobject(Sqlca)
end event

event ue_retrieve;call super::ue_retrieve;datetime ldt_ini, ldt_fin

ldt_ini = datetime(date(dp_1.value),time('00:00:00'))
ldt_fin = datetime(date(dp_2.value),time('23:59:59'))

dw_report.RETRIEVE( ldt_ini, ldt_fin )
dw_report.object.t_titulobasc1.text = 'CONTROL DE INGRESO DE VISITANTES'
dw_report.object.t_titulobasc2.text = ''
dw_report.object.t_codigobasc.text = 'CANT.FO.09.1'
dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
dw_report.object.t_usuario.text = upper(gs_user)
dw_report.object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_ba702_ingreso_salida_personal_externo
integer x = 37
integer y = 320
integer width = 2747
integer height = 675
string dataobject = "d_rpt_ingreso_salida_personal_externo"
end type

type cb_1 from commandbutton within w_ba702_ingreso_salida_personal_externo
integer x = 1280
integer y = 192
integer width = 369
integer height = 99
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Aceptar"
end type

event clicked;parent.event ue_retrieve()
end event

type dp_1 from datepicker within w_ba702_ingreso_salida_personal_externo
integer x = 80
integer y = 138
integer width = 512
integer height = 99
integer taborder = 20
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-04"), Time("15:16:09.000000"))
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type st_1 from statictext within w_ba702_ingreso_salida_personal_externo
integer x = 589
integer y = 154
integer width = 88
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type dp_2 from datepicker within w_ba702_ingreso_salida_personal_externo
integer x = 680
integer y = 138
integer width = 512
integer height = 99
integer taborder = 20
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-04"), Time("15:16:09.000000"))
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type gb_2 from groupbox within w_ba702_ingreso_salida_personal_externo
integer x = 37
integer y = 32
integer width = 1211
integer height = 259
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

