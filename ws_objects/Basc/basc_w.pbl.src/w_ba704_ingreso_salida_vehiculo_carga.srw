$PBExportHeader$w_ba704_ingreso_salida_vehiculo_carga.srw
forward
global type w_ba704_ingreso_salida_vehiculo_carga from w_report_smpl
end type
type cb_1 from commandbutton within w_ba704_ingreso_salida_vehiculo_carga
end type
type dp_1 from datepicker within w_ba704_ingreso_salida_vehiculo_carga
end type
type st_1 from statictext within w_ba704_ingreso_salida_vehiculo_carga
end type
type dp_2 from datepicker within w_ba704_ingreso_salida_vehiculo_carga
end type
type rb_1 from radiobutton within w_ba704_ingreso_salida_vehiculo_carga
end type
type rb_2 from radiobutton within w_ba704_ingreso_salida_vehiculo_carga
end type
type gb_2 from groupbox within w_ba704_ingreso_salida_vehiculo_carga
end type
type gb_1 from groupbox within w_ba704_ingreso_salida_vehiculo_carga
end type
end forward

global type w_ba704_ingreso_salida_vehiculo_carga from w_report_smpl
integer x = 5
integer y = 4
integer width = 2838
integer height = 1168
string title = "(BA704) Control de Ingreso y Salida de Vehiculos"
string menuname = "m_reporte"
cb_1 cb_1
dp_1 dp_1
st_1 st_1
dp_2 dp_2
rb_1 rb_1
rb_2 rb_2
gb_2 gb_2
gb_1 gb_1
end type
global w_ba704_ingreso_salida_vehiculo_carga w_ba704_ingreso_salida_vehiculo_carga

type variables

end variables

on w_ba704_ingreso_salida_vehiculo_carga.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.dp_1=create dp_1
this.st_1=create st_1
this.dp_2=create dp_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dp_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dp_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_ba704_ingreso_salida_vehiculo_carga.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dp_1)
destroy(this.st_1)
destroy(this.dp_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;
dw_report.settransobject(Sqlca)
end event

event ue_retrieve;call super::ue_retrieve;datetime ldt_ini, ldt_fin
string ls_flag

ldt_ini = datetime(date(dp_1.value),time('00:00:00'))
ldt_fin = datetime(date(dp_2.value),time('23:59:59'))

if rb_1.checked then
	ls_flag = '1'
else
	ls_flag = '2'
end if

dw_report.RETRIEVE( ldt_ini, ldt_fin, ls_flag )

if ls_flag = '1' then
	
	dw_report.object.t_titulobasc1.text = 'CONTROL DE INGRESO DE VEHICULOS DE LA EMPRESA'
	dw_report.object.t_titulobasc2.text = ''
	dw_report.object.t_codigobasc.text = 'CANT.FO.09.8'
	dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'

else
	
	dw_report.object.t_titulobasc1.text = 'CONTROL DE INGRESO DE VEHICULOS PARTICULARES'
	dw_report.object.t_titulobasc2.text = ''
	dw_report.object.t_codigobasc.text = 'CANT.FO.09.6'
	dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'

end if

dw_report.object.t_usuario.text = upper(gs_user)
dw_report.object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_ba704_ingreso_salida_vehiculo_carga
integer x = 29
integer y = 307
integer width = 2754
integer height = 694
string dataobject = "d_rpt_control_vehiculo_carga"
end type

type cb_1 from commandbutton within w_ba704_ingreso_salida_vehiculo_carga
integer x = 1697
integer y = 179
integer width = 384
integer height = 106
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;parent.event ue_retrieve()
end event

type dp_1 from datepicker within w_ba704_ingreso_salida_vehiculo_carga
integer x = 73
integer y = 131
integer width = 512
integer height = 99
integer taborder = 20
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-11"), Time("12:25:58.000000"))
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type st_1 from statictext within w_ba704_ingreso_salida_vehiculo_carga
integer x = 581
integer y = 147
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

type dp_2 from datepicker within w_ba704_ingreso_salida_vehiculo_carga
integer x = 673
integer y = 131
integer width = 512
integer height = 99
integer taborder = 20
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-11"), Time("12:25:58.000000"))
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type rb_1 from radiobutton within w_ba704_ingreso_salida_vehiculo_carga
integer x = 1298
integer y = 106
integer width = 340
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Empresa"
boolean checked = true
end type

type rb_2 from radiobutton within w_ba704_ingreso_salida_vehiculo_carga
integer x = 1298
integer y = 195
integer width = 358
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Particular"
end type

type gb_2 from groupbox within w_ba704_ingreso_salida_vehiculo_carga
integer x = 29
integer y = 26
integer width = 1203
integer height = 259
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

type gb_1 from groupbox within w_ba704_ingreso_salida_vehiculo_carga
integer x = 1258
integer y = 26
integer width = 413
integer height = 259
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo"
end type

