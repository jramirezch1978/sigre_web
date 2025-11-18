$PBExportHeader$w_ap307_pd_descarga_frm.srw
forward
global type w_ap307_pd_descarga_frm from w_rpt
end type
type dw_report from u_dw_rpt within w_ap307_pd_descarga_frm
end type
end forward

global type w_ap307_pd_descarga_frm from w_rpt
integer width = 2574
integer height = 1856
string title = "Reporte de Costo Diario de Materia Prima"
string menuname = "m_rpt"
long backcolor = 67108864
dw_report dw_report
end type
global w_ap307_pd_descarga_frm w_ap307_pd_descarga_frm

on w_ap307_pd_descarga_frm.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_ap307_pd_descarga_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width 	= newwidth 	- dw_report.x
dw_report.height	= newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;String ls_nro_parte

str_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_nro_parte = lstr_rep.string1
dw_report.Retrieve( ls_nro_parte)
idw_1.Visible = True
idw_1.Object.p_logo.filename  = gs_logo
idw_1.object.usuario_t.text	= gs_user
end event

type dw_report from u_dw_rpt within w_ap307_pd_descarga_frm
integer width = 2427
integer height = 1620
string dataobject = "d_ap_pd_costo_diario_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

