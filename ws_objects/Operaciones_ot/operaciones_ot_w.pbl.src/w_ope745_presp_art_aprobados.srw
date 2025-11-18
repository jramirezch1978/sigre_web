$PBExportHeader$w_ope745_presp_art_aprobados.srw
forward
global type w_ope745_presp_art_aprobados from w_rpt
end type
type dw_report from u_dw_rpt within w_ope745_presp_art_aprobados
end type
end forward

global type w_ope745_presp_art_aprobados from w_rpt
integer width = 1344
integer height = 1344
string title = "Presupuesto Proyectado A(OPE745)"
string menuname = "m_rpt_smpl"
long backcolor = 134217728
dw_report dw_report
end type
global w_ope745_presp_art_aprobados w_ope745_presp_art_aprobados

type variables
Str_cns_pop istr_1
end variables

event open;//IF f_access(gs_user, THIS.ClassName(), is_niveles) THEN 
	THIS.EVENT ue_open_pre()
//ELSE
//	CLOSE(THIS)
//END IF
end event

event ue_open_pre;Long	ll_row, ll_total

idw_1 = dw_report
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
idw_1.Visible = True




This.Event ue_retrieve()
of_position(0,0)


end event

on w_ope745_presp_art_aprobados.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_ope745_presp_art_aprobados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_retrieve;call super::ue_retrieve;
idw_1.Visible = True
idw_1.SettransObject(sqlca)
idw_1.Retrieve()
dw_report.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

type dw_report from u_dw_rpt within w_ope745_presp_art_aprobados
integer x = 14
integer y = 52
integer width = 1239
integer height = 1052
string dataobject = "d_rpt_presupuesto_art_aprobados_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

