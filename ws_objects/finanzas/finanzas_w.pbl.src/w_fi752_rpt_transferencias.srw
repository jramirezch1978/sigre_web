$PBExportHeader$w_fi752_rpt_transferencias.srw
forward
global type w_fi752_rpt_transferencias from w_rpt
end type
type uo_fechas from u_ingreso_rango_fechas within w_fi752_rpt_transferencias
end type
type cb_2 from commandbutton within w_fi752_rpt_transferencias
end type
type dw_report from u_dw_rpt within w_fi752_rpt_transferencias
end type
type cb_reporte from commandbutton within w_fi752_rpt_transferencias
end type
type gb_1 from groupbox within w_fi752_rpt_transferencias
end type
end forward

global type w_fi752_rpt_transferencias from w_rpt
integer width = 3589
integer height = 1364
string title = "[FI752] Detalle de Transferencias entre cuentas"
string menuname = "m_reporte"
uo_fechas uo_fechas
cb_2 cb_2
dw_report dw_report
cb_reporte cb_reporte
gb_1 gb_1
end type
global w_fi752_rpt_transferencias w_fi752_rpt_transferencias

on w_fi752_rpt_transferencias.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_fechas=create uo_fechas
this.cb_2=create cb_2
this.dw_report=create dw_report
this.cb_reporte=create cb_reporte
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.cb_reporte
this.Control[iCurrent+5]=this.gb_1
end on

on w_fi752_rpt_transferencias.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_2)
destroy(this.dw_report)
destroy(this.cb_reporte)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()


// ii_help = 101           // help topic


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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type uo_fechas from u_ingreso_rango_fechas within w_fi752_rpt_transferencias
event destroy ( )
integer x = 64
integer y = 80
integer taborder = 40
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date ld_hoy

ld_hoy = DAte(gnvo_app.of_fecha_actual())

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_hoy, ld_hoy)
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type cb_2 from commandbutton within w_fi752_rpt_transferencias
integer x = 1435
integer y = 56
integer width = 471
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cuentas de Bancos"
end type

event clicked;Long ll_count
str_parametros sl_param 

sl_param.dw1		= 'd_abc_cnta_bco_help_rpt_tbl'
sl_param.titulo	= 'Cuenta de Banco'
sl_param.opcion   = 8
sl_param.db1 		= 1600
sl_param.string1 	= '1RPP'

OpenWithParm( w_abc_seleccion_lista_search, sl_param)
end event

type dw_report from u_dw_rpt within w_fi752_rpt_transferencias
integer y = 312
integer width = 3511
integer height = 800
integer taborder = 20
string dataobject = "d_rpt_transferencias_tbl"
end type

type cb_reporte from commandbutton within w_fi752_rpt_transferencias
integer x = 1435
integer y = 180
integer width = 471
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Reporte"
end type

event clicked;String 	ls_mensaje
Date 		ld_Fecha1, ld_fecha2


ld_Fecha1 = uo_Fechas.of_get_fecha1()
ld_fecha2  = uo_Fechas.of_get_fecha2()

dw_report.Retrieve(ld_fecha1, ld_fecha2)

dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_nombre.text   = gs_empresa
dw_report.Object.t_user.Text     = gs_user



end event

type gb_1 from groupbox within w_fi752_rpt_transferencias
integer width = 2414
integer height = 300
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros para el reporte"
end type

