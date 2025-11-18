$PBExportHeader$w_ve902_generacion_fact_cobrar_guias.srw
forward
global type w_ve902_generacion_fact_cobrar_guias from w_rpt
end type
type dw_report from u_dw_rpt within w_ve902_generacion_fact_cobrar_guias
end type
end forward

global type w_ve902_generacion_fact_cobrar_guias from w_rpt
integer width = 914
integer height = 912
string title = "[VE902] Reporte de Guias a Facturar"
string menuname = "m_reporte"
long backcolor = 67108864
dw_report dw_report
end type
global w_ve902_generacion_fact_cobrar_guias w_ve902_generacion_fact_cobrar_guias

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = FALSE
THIS.Event ue_preview()

str_parametros sgt_parametros

sgt_parametros = message.powerobjectparm

decimal{4} ld_tasa_cambio
date		  ld_fecha

ld_fecha = date(sgt_parametros.datetime1)

select vta_dol_prom
  into :ld_tasa_cambio
  from calendario
 where trunc(fecha) = :ld_fecha;

idw_1.retrieve(sgt_parametros.date1, sgt_parametros.date2, &
					sgt_parametros.string1, sgt_parametros.datetime1, &
					ld_tasa_cambio, gs_origen, gs_empresa, gs_user)

idw_1.Object.p_logo.filename = gs_logo
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

on w_ve902_generacion_fact_cobrar_guias.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_ve902_generacion_fact_cobrar_guias.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

type dw_report from u_dw_rpt within w_ve902_generacion_fact_cobrar_guias
integer x = 37
integer y = 32
integer width = 773
integer height = 612
string dataobject = "d_rpt_generacion_fact_guias"
boolean hscrollbar = true
boolean vscrollbar = true
integer ii_zoom_actual = 100
end type

