$PBExportHeader$w_rh623_rpt_validacion_contable.srw
forward
global type w_rh623_rpt_validacion_contable from w_rpt
end type
type dw_report from u_dw_rpt within w_rh623_rpt_validacion_contable
end type
end forward

global type w_rh623_rpt_validacion_contable from w_rpt
integer width = 2505
integer height = 1236
string title = "[RH623] Reporte de Validacion de Pre Asientos"
string menuname = "m_reporte"
long backcolor = 10789024
dw_report dw_report
end type
global w_rh623_rpt_validacion_contable w_rh623_rpt_validacion_contable

on w_rh623_rpt_validacion_contable.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_rh623_rpt_validacion_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()
This.Event ue_retrieve()

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

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()




idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text	  = gs_user
end event

event open;//IF f_access(gs_user, THIS.ClassName(), is_niveles) THEN 
//	THIS.EVENT ue_open_pre()
//ELSE
//	CLOSE(THIS)
//END IF
THIS.EVENT ue_open_pre()
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type dw_report from u_dw_rpt within w_rh623_rpt_validacion_contable
integer width = 2391
integer height = 988
string dataobject = "d_rpt_validacion_cntbl_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

