$PBExportHeader$w_rh732_rpt_basc_programa_capacitacion.srw
forward
global type w_rh732_rpt_basc_programa_capacitacion from w_report_smpl
end type
type cb_1 from commandbutton within w_rh732_rpt_basc_programa_capacitacion
end type
type em_1 from editmask within w_rh732_rpt_basc_programa_capacitacion
end type
type gb_2 from groupbox within w_rh732_rpt_basc_programa_capacitacion
end type
end forward

global type w_rh732_rpt_basc_programa_capacitacion from w_report_smpl
integer width = 3291
integer height = 1491
string title = "(RH732) Programa de Capacitacion y Actividades"
string menuname = "m_impresion"
cb_1 cb_1
em_1 em_1
gb_2 gb_2
end type
global w_rh732_rpt_basc_programa_capacitacion w_rh732_rpt_basc_programa_capacitacion

on w_rh732_rpt_basc_programa_capacitacion.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_1=create em_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_1
this.Control[iCurrent+3]=this.gb_2
end on

on w_rh732_rpt_basc_programa_capacitacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano
li_ano   = integer(em_1.text)
dw_report.RETRIEVE(li_ano)
dw_report.object.t_titulobasc1.text = 'PROGRAMA DE CAPACITACIONES Y ACTIVIDADES'
dw_report.object.t_titulobasc2.text = ''
dw_report.object.t_codigobasc.text = 'CANT.FO.05.3'
dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
dw_report.object.t_usuario.text = upper(gs_user)
dw_report.object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_rh732_rpt_basc_programa_capacitacion
integer x = 37
integer y = 256
integer width = 3185
integer height = 1027
integer taborder = 30
string dataobject = "d_rpt_basc_prog_capacitaciones_composite"
end type

type cb_1 from commandbutton within w_rh732_rpt_basc_programa_capacitacion
integer x = 512
integer y = 128
integer width = 296
integer height = 99
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_1 from editmask within w_rh732_rpt_basc_programa_capacitacion
integer x = 80
integer y = 96
integer width = 358
integer height = 106
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string mask = "####"
boolean autoskip = true
boolean spin = true
double increment = 1
string minmax = "2000~~2025"
end type

event constructor;THIS.TEXT = STRING(TODAY(),'YYYY')
end event

type gb_2 from groupbox within w_rh732_rpt_basc_programa_capacitacion
integer x = 37
integer y = 29
integer width = 443
integer height = 202
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Año"
borderstyle borderstyle = stylebox!
end type

