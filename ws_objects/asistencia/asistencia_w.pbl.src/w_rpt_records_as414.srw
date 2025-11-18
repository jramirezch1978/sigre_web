$PBExportHeader$w_rpt_records_as414.srw
forward
global type w_rpt_records_as414 from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_rpt_records_as414
end type
type cb_1 from commandbutton within w_rpt_records_as414
end type
type gb_trabajador from groupbox within w_rpt_records_as414
end type
type gb_3 from groupbox within w_rpt_records_as414
end type
type sle_codtra_desde from singlelineedit within w_rpt_records_as414
end type
type st_cod_trabajador from statictext within w_rpt_records_as414
end type
type st_2 from statictext within w_rpt_records_as414
end type
type sle_codtra_hasta from singlelineedit within w_rpt_records_as414
end type
end forward

global type w_rpt_records_as414 from w_report_smpl
integer width = 3461
integer height = 1644
string title = "Registro de Marcaciones Diarias"
string menuname = "m_reporte"
long backcolor = 79741120
uo_1 uo_1
cb_1 cb_1
gb_trabajador gb_trabajador
gb_3 gb_3
sle_codtra_desde sle_codtra_desde
st_cod_trabajador st_cod_trabajador
st_2 st_2
sle_codtra_hasta sle_codtra_hasta
end type
global w_rpt_records_as414 w_rpt_records_as414

on w_rpt_records_as414.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cb_1=create cb_1
this.gb_trabajador=create gb_trabajador
this.gb_3=create gb_3
this.sle_codtra_desde=create sle_codtra_desde
this.st_cod_trabajador=create st_cod_trabajador
this.st_2=create st_2
this.sle_codtra_hasta=create sle_codtra_hasta
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.gb_trabajador
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.sle_codtra_desde
this.Control[iCurrent+6]=this.st_cod_trabajador
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.sle_codtra_hasta
end on

on w_rpt_records_as414.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.gb_trabajador)
destroy(this.gb_3)
destroy(this.sle_codtra_desde)
destroy(this.st_cod_trabajador)
destroy(this.st_2)
destroy(this.sle_codtra_hasta)
end on

event ue_retrieve();call super::ue_retrieve;String ls_codigo_desde, ls_codigo_hasta
ls_codigo_desde = String(sle_codtra_desde.text)
ls_codigo_hasta = String(sle_codtra_hasta.text)

date ld_fec_desde
date ld_fec_hasta
ld_fec_desde=uo_1.of_get_fecha1()
ld_fec_hasta=uo_1.of_get_fecha2()

dw_report.retrieve(ls_codigo_desde,ls_codigo_hasta,ld_fec_desde,ld_fec_hasta)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_rpt_records_as414
integer x = 9
integer y = 336
integer width = 3410
integer height = 1124
integer taborder = 50
string dataobject = "d_records_tbl"
end type

type uo_1 from u_ingreso_rango_fechas within w_rpt_records_as414
integer x = 1664
integer y = 128
integer height = 96
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;string ls_inicio, ls_fec 
date ld_fec
uo_1.of_set_label('Desde','Hasta')

// Obtiene primer día del mes
ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 uo_1.of_set_fecha(date(ls_inicio),today())
 uo_1.of_set_rango_inicio(date('01/01/1900'))   // rango inicial
 uo_1.of_set_rango_fin(date('31/12/9999'))      // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_rpt_records_as414
integer x = 3072
integer y = 124
integer width = 274
integer height = 80
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

event clicked;w_rpt_records_as414.Event ue_retrieve()
end event

type gb_trabajador from groupbox within w_rpt_records_as414
integer x = 274
integer y = 52
integer width = 1234
integer height = 204
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 79741120
string text = " Carnet de Trabajador "
borderstyle borderstyle = styleraised!
end type

type gb_3 from groupbox within w_rpt_records_as414
integer x = 1591
integer y = 52
integer width = 1422
integer height = 204
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 79741120
string text = " Ingrese Rango de Fechas "
borderstyle borderstyle = styleraised!
end type

type sle_codtra_desde from singlelineedit within w_rpt_records_as414
integer x = 544
integer y = 124
integer width = 329
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_cod_trabajador from statictext within w_rpt_records_as414
integer x = 334
integer y = 136
integer width = 183
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rpt_records_as414
integer x = 919
integer y = 136
integer width = 155
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type sle_codtra_hasta from singlelineedit within w_rpt_records_as414
integer x = 1106
integer y = 124
integer width = 329
integer height = 80
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

