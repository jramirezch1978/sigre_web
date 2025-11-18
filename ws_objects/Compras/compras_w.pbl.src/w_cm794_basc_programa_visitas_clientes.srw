$PBExportHeader$w_cm794_basc_programa_visitas_clientes.srw
forward
global type w_cm794_basc_programa_visitas_clientes from w_rpt
end type
type cb_1 from commandbutton within w_cm794_basc_programa_visitas_clientes
end type
type em_1 from editmask within w_cm794_basc_programa_visitas_clientes
end type
type st_1 from statictext within w_cm794_basc_programa_visitas_clientes
end type
type dw_report from u_dw_rpt within w_cm794_basc_programa_visitas_clientes
end type
type gb_1 from groupbox within w_cm794_basc_programa_visitas_clientes
end type
end forward

global type w_cm794_basc_programa_visitas_clientes from w_rpt
integer x = 282
integer y = 250
integer width = 3109
integer height = 1363
string title = "[CM794] Programa de Visitas a Clientes"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
cb_1 cb_1
em_1 em_1
st_1 st_1
dw_report dw_report
gb_1 gb_1
end type
global w_cm794_basc_programa_visitas_clientes w_cm794_basc_programa_visitas_clientes

on w_cm794_basc_programa_visitas_clientes.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_1=create em_1
this.st_1=create st_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.gb_1
end on

on w_cm794_basc_programa_visitas_clientes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_1)
destroy(this.st_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//idw_1.Visible = False
idw_1 = dw_report
ii_help = 101           // help topic
em_1.text = string(today(),'yyyy')
idw_1.SetTransObject( SQLCA )

This.Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;integer li_ano
li_ano = integer(em_1.text)
dw_report.Retrieve(li_ano)
dw_report.Visible = True

dw_report.object.t_titulobasc1.text = 'PROGRAMA DE VISITAS A CLIENTES'
dw_report.object.t_codigobasc.text = 'CANT.FO.08.4'
dw_report.object.t_versionbasc.text = 'VERSION: 00'
dw_report.Object.p_logo.filename = gs_logo

ib_preview = false
event ue_preview()
//
//dw_report.Object.p_logo.filename = gs_logo
//dw_report.object.t_user.text     = gs_user
//dw_report.object.t_empresa.text  = gs_empresa
//dw_report.object.t_codigo.text   = dw_report.dataobject
//
end event

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


end event

event ue_print;call super::ue_print;dw_report.EVENT ue_print()

end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

type cb_1 from commandbutton within w_cm794_basc_programa_visitas_clientes
integer x = 731
integer y = 115
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;parent.Event ue_retrieve()
end event

type em_1 from editmask within w_cm794_basc_programa_visitas_clientes
integer x = 241
integer y = 96
integer width = 402
integer height = 106
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean autoskip = true
boolean spin = true
double increment = 1
string minmax = "2000~~9999"
end type

type st_1 from statictext within w_cm794_basc_programa_visitas_clientes
integer x = 91
integer y = 115
integer width = 146
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_cm794_basc_programa_visitas_clientes
integer x = 37
integer y = 256
integer width = 3003
integer height = 899
boolean bringtotop = true
string dataobject = "d_rpt_proveedor_basc_prog_visistas"
end type

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type gb_1 from groupbox within w_cm794_basc_programa_visitas_clientes
integer x = 37
integer y = 32
integer width = 662
integer height = 195
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

