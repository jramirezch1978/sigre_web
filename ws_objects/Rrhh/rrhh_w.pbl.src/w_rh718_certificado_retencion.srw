$PBExportHeader$w_rh718_certificado_retencion.srw
forward
global type w_rh718_certificado_retencion from w_rpt
end type
type dw_report from u_dw_rpt within w_rh718_certificado_retencion
end type
end forward

global type w_rh718_certificado_retencion from w_rpt
integer width = 3845
integer height = 1840
string title = "Certificado Retención (RH718)"
string menuname = "m_reporte"
long backcolor = 12632256
dw_report dw_report
end type
global w_rh718_certificado_retencion w_rh718_certificado_retencion

type variables
str_seleccionar istr_seleccionar
end variables

on w_rh718_certificado_retencion.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_rh718_certificado_retencion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()


istr_seleccionar = Message.PowerObjectParm
THIS.Event ue_retrieve()

end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve(istr_seleccionar.param1[1], &
					istr_seleccionar.paraml1[1],&
					istr_seleccionar.paramdc1[1],&
					istr_seleccionar.param1[2])


//idw_1.object.p_logo.filename = gs_logo
//idw_1.object.t_nombre.text = gs_empresa
//idw_1.object.t_user.text = gs_user
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

type dw_report from u_dw_rpt within w_rh718_certificado_retencion
integer width = 3712
integer height = 1620
string dataobject = "d_rpt_formato_certificado_ret_quinta_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

