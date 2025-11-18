$PBExportHeader$w_ve740_doc_pend_ov.srw
forward
global type w_ve740_doc_pend_ov from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_ve740_doc_pend_ov
end type
type cb_1 from commandbutton within w_ve740_doc_pend_ov
end type
type dw_report from u_dw_rpt within w_ve740_doc_pend_ov
end type
type gb_1 from groupbox within w_ve740_doc_pend_ov
end type
end forward

global type w_ve740_doc_pend_ov from w_rpt
integer width = 2670
integer height = 1832
string title = "Guias Pendientes de Facturar (VE740)"
string menuname = "m_reporte"
long backcolor = 134217728
uo_1 uo_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ve740_doc_pend_ov w_ve740_doc_pend_ov

on w_ve740_doc_pend_ov.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.gb_1
end on

on w_ve740_doc_pend_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)

ib_preview = false

ib_preview = FALSE
THIS.Event ue_preview()

end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_filter;call super::ue_filter;idw_1.groupcalc()
end event

type uo_1 from u_ingreso_rango_fechas within w_ve740_doc_pend_ov
integer x = 105
integer y = 104
integer taborder = 20
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_ve740_doc_pend_ov
integer x = 2213
integer y = 12
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Date   ld_fecha_inicial,ld_fecha_final

ld_fecha_inicial = uo_1.of_get_fecha1()
ld_fecha_final   = uo_1.of_get_fecha2()


declare PB_usp_com_pend_fact procedure for usp_com_pend_fact(:ld_fecha_inicial,:ld_fecha_final);
execute PB_usp_com_pend_fact ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

close	PB_usp_com_pend_fact ;


dw_report.retrieve(ld_fecha_inicial,ld_fecha_final)
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text 	   = gs_user
end event

type dw_report from u_dw_rpt within w_ve740_doc_pend_ov
integer x = 27
integer y = 280
integer width = 2569
integer height = 1340
string dataobject = "d_abc_doc_pend_x_ov_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ve740_doc_pend_ov
integer x = 27
integer y = 28
integer width = 1449
integer height = 228
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos"
end type

