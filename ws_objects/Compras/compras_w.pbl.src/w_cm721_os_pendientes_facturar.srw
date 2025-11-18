$PBExportHeader$w_cm721_os_pendientes_facturar.srw
forward
global type w_cm721_os_pendientes_facturar from w_rpt
end type
type st_1 from statictext within w_cm721_os_pendientes_facturar
end type
type em_1 from editmask within w_cm721_os_pendientes_facturar
end type
type uo_1 from u_ingreso_rango_fechas within w_cm721_os_pendientes_facturar
end type
type dw_report from u_dw_rpt within w_cm721_os_pendientes_facturar
end type
type cb_1 from commandbutton within w_cm721_os_pendientes_facturar
end type
end forward

global type w_cm721_os_pendientes_facturar from w_rpt
integer x = 283
integer y = 248
integer width = 3113
integer height = 1416
string title = "[CM721] Ordenes de Servicio pendientes de facturar"
string menuname = "m_impresion"
long backcolor = 79741120
st_1 st_1
em_1 em_1
uo_1 uo_1
dw_report dw_report
cb_1 cb_1
end type
global w_cm721_os_pendientes_facturar w_cm721_os_pendientes_facturar

on w_cm721_os_pendientes_facturar.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.em_1=create em_1
this.uo_1=create uo_1
this.dw_report=create dw_report
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_1
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.cb_1
end on

on w_cm721_os_pendientes_facturar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_1)
destroy(this.uo_1)
destroy(this.dw_report)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
ii_help = 721           // help topic

idw_1.SetTransObject( SQLCA )
em_1.text = '0.05'

end event

event ue_retrieve;call super::ue_retrieve;Date ld_fec_desde, ld_fec_hasta
Decimal {2} ld_desviacion 

ld_fec_desde = uo_1.of_get_fecha1()
ld_fec_hasta = uo_1.of_get_fecha2()  
ld_desviacion = Dec(em_1.text)
dw_report.Retrieve(ld_fec_desde, ld_fec_hasta, ld_desviacion)
dw_report.Visible = True
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_user.text  	= gs_user
dw_report.object.t_objeto.text   = dw_report.dataobject
dw_report.object.t_texto.text   = 'Del ' + String(ld_fec_desde,'dd/mm/yyyy') + ' al ' + String(ld_fec_hasta,'dd/mm/yyyy')
end event

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


end event

event ue_print();call super::ue_print;dw_report.EVENT ue_print()
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

type st_1 from statictext within w_cm721_os_pendientes_facturar
integer x = 59
integer y = 160
integer width = 1074
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desviación entre monto total y monto facturado: "
boolean focusrectangle = false
end type

type em_1 from editmask within w_cm721_os_pendientes_facturar
integer x = 1152
integer y = 140
integer width = 160
integer height = 92
integer taborder = 30
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

type uo_1 from u_ingreso_rango_fechas within w_cm721_os_pendientes_facturar
event destroy ( )
integer x = 50
integer y = 44
integer taborder = 30
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type dw_report from u_dw_rpt within w_cm721_os_pendientes_facturar
integer y = 252
integer width = 2999
integer height = 900
boolean bringtotop = true
string dataobject = "d_rpt_os_pendiente_facturar_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_cm721_os_pendientes_facturar
integer x = 2501
integer y = 72
integer width = 302
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
ib_preview = true

Parent.Event ue_retrieve()

end event

