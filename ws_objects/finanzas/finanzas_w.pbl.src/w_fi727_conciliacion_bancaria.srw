$PBExportHeader$w_fi727_conciliacion_bancaria.srw
forward
global type w_fi727_conciliacion_bancaria from w_rpt
end type
type dw_report from u_dw_rpt within w_fi727_conciliacion_bancaria
end type
end forward

global type w_fi727_conciliacion_bancaria from w_rpt
integer width = 2395
integer height = 1560
string title = "Conciliacion Bancaria (FI727)"
string menuname = "m_reporte"
long backcolor = 12632256
dw_report dw_report
end type
global w_fi727_conciliacion_bancaria w_fi727_conciliacion_bancaria

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;str_parametros ls_param

idw_1 = dw_report
idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()

ls_param = message.powerobjectparm

//lleno temporal
DECLARE usp_fin_rpt_conciliacion PROCEDURE FOR 
	usp_fin_rpt_conciliacion(	:ls_param.string1,
										:ls_param.longa[1],
										:ls_param.longa[2]);
EXECUTE usp_fin_rpt_conciliacion ;



IF gnvo_app.of_existserror( SQLCA, 'PROCEDURE usp_fin_rpt_conciliacion') then return


CLOSE usp_fin_rpt_conciliacion;


dw_report.Retrieve(ls_param.string1,ls_param.longa[1],ls_param.longa[2])

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text   = gs_user
end event

on w_fi727_conciliacion_bancaria.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_fi727_conciliacion_bancaria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type dw_report from u_dw_rpt within w_fi727_conciliacion_bancaria
integer width = 2318
integer height = 1304
string dataobject = "d_rpt_conciliacion_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

