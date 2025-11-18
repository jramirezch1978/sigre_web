$PBExportHeader$w_rpt_turnos_as416.srw
forward
global type w_rpt_turnos_as416 from w_report_smpl
end type
type cb_1 from commandbutton within w_rpt_turnos_as416
end type
type gb_trabajador from groupbox within w_rpt_turnos_as416
end type
type gb_3 from groupbox within w_rpt_turnos_as416
end type
type st_1 from statictext within w_rpt_turnos_as416
end type
type st_2 from statictext within w_rpt_turnos_as416
end type
type st_3 from statictext within w_rpt_turnos_as416
end type
type st_4 from statictext within w_rpt_turnos_as416
end type
type st_5 from statictext within w_rpt_turnos_as416
end type
type ano from singlelineedit within w_rpt_turnos_as416
end type
type ddlb_1 from dropdownlistbox within w_rpt_turnos_as416
end type
type sem_desde from singlelineedit within w_rpt_turnos_as416
end type
type sem_hasta from singlelineedit within w_rpt_turnos_as416
end type
end forward

global type w_rpt_turnos_as416 from w_report_smpl
integer width = 3461
integer height = 1644
string title = "Programación de Turnos (AS416)"
string menuname = "m_reporte"
long backcolor = 79741120
cb_1 cb_1
gb_trabajador gb_trabajador
gb_3 gb_3
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
ano ano
ddlb_1 ddlb_1
sem_desde sem_desde
sem_hasta sem_hasta
end type
global w_rpt_turnos_as416 w_rpt_turnos_as416

on w_rpt_turnos_as416.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.gb_trabajador=create gb_trabajador
this.gb_3=create gb_3
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.ano=create ano
this.ddlb_1=create ddlb_1
this.sem_desde=create sem_desde
this.sem_hasta=create sem_hasta
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.gb_trabajador
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.ano
this.Control[iCurrent+10]=this.ddlb_1
this.Control[iCurrent+11]=this.sem_desde
this.Control[iCurrent+12]=this.sem_hasta
end on

on w_rpt_turnos_as416.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.gb_trabajador)
destroy(this.gb_3)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.ano)
destroy(this.ddlb_1)
destroy(this.sem_desde)
destroy(this.sem_hasta)
end on

event ue_retrieve();call super::ue_retrieve;String ls_mes, ls_ano
Double ln_semana_d, ln_semana_h
Double ln_nro_semana
ls_mes = String(ddlb_1.text)
ls_ano = String(ano.text)
ln_semana_d = Double(sem_desde.text)
ln_semana_h = Double(sem_hasta.text)

ln_nro_semana = ln_semana_h - ln_semana_d
ln_nro_semana = ln_nro_semana + 1

If ln_semana_d > ln_semana_h then
	MessageBox("Atención","Semana Desde no es Válido")
End if
If ln_nro_semana > 5 then
	MessageBox("Atención","Un Mes no Debe Tener Mas de 5 Semanas")
End if
If ln_semana_h > 53 then
	MessageBox("Atención","Un Año No Tiene Mas de 53 Semanas")
End if

DECLARE pb_usp_rpt_turnos PROCEDURE FOR USP_RPT_TURNOS
        (:ls_mes, :ls_ano, :ln_semana_d, :ln_semana_h) ;
Execute pb_usp_rpt_turnos ;
dw_report.retrieve(ls_mes, ls_ano, ln_semana_d, ln_semana_h)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_rpt_turnos_as416
integer x = 9
integer y = 428
integer width = 3410
integer height = 1032
integer taborder = 30
string dataobject = "d_rpt_turnos_tbl"
end type

type cb_1 from commandbutton within w_rpt_turnos_as416
integer x = 3031
integer y = 232
integer width = 274
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;w_rpt_turnos_as416.Event ue_retrieve()
end event

type gb_trabajador from groupbox within w_rpt_turnos_as416
integer x = 251
integer y = 160
integer width = 1417
integer height = 204
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 79741120
string text = " Fecha de Proceso "
borderstyle borderstyle = styleraised!
end type

type gb_3 from groupbox within w_rpt_turnos_as416
integer x = 1733
integer y = 160
integer width = 1248
integer height = 204
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 79741120
string text = " Rango de Semanas "
borderstyle borderstyle = styleraised!
end type

type st_1 from statictext within w_rpt_turnos_as416
integer x = 480
integer y = 36
integer width = 2661
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = " FORMATO DE PROGRAMAMCION DE TURNOS MENSUALES "
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rpt_turnos_as416
integer x = 320
integer y = 240
integer width = 242
integer height = 80
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
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rpt_turnos_as416
integer x = 1120
integer y = 240
integer width = 242
integer height = 80
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
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_4 from statictext within w_rpt_turnos_as416
integer x = 1879
integer y = 240
integer width = 279
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desde"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_5 from statictext within w_rpt_turnos_as416
integer x = 2400
integer y = 240
integer width = 279
integer height = 80
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
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type ano from singlelineedit within w_rpt_turnos_as416
integer x = 1413
integer y = 240
integer width = 178
integer height = 80
integer taborder = 50
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

type ddlb_1 from dropdownlistbox within w_rpt_turnos_as416
integer x = 599
integer y = 232
integer width = 480
integer height = 260
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
string text = "none"
boolean sorted = false
boolean vscrollbar = true
string item[] = {"ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SETIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"}
borderstyle borderstyle = stylelowered!
end type

type sem_desde from singlelineedit within w_rpt_turnos_as416
integer x = 2199
integer y = 240
integer width = 151
integer height = 80
integer taborder = 60
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

type sem_hasta from singlelineedit within w_rpt_turnos_as416
integer x = 2725
integer y = 240
integer width = 151
integer height = 80
integer taborder = 70
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

