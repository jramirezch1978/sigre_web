$PBExportHeader$w_sig781_det_fce_presupuesto.srw
forward
global type w_sig781_det_fce_presupuesto from w_rpt
end type
type dw_report from u_dw_rpt within w_sig781_det_fce_presupuesto
end type
end forward

global type w_sig781_det_fce_presupuesto from w_rpt
integer x = 256
integer y = 348
integer width = 3200
integer height = 1912
string title = "Ratio de ejecución vs presupuesto (SIG781)"
string menuname = "m_rpt_simple"
long backcolor = 12632256
dw_report dw_report
end type
global w_sig781_det_fce_presupuesto w_sig781_det_fce_presupuesto

type variables
String is_tipo_gasto
end variables

on w_sig781_det_fce_presupuesto.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_sig781_det_fce_presupuesto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()
//idw_1.object.p_logo.filename = gs_logo
// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;String ls_tipo_gasto, ls_texto
sg_parametros lstr_rep

lstr_rep = message.powerobjectparm

is_tipo_gasto = trim(lstr_rep.string1)

idw_1.dataobject = 'd_rpt_fce_presup_x_detalle_tbl'

IF is_tipo_gasto = 'F' THEN
	ls_texto = 'Gastos fijos'
ELSEIF is_tipo_gasto = 'V' then
	ls_texto = 'Gastos variables'	
ELSEIF is_tipo_gasto = 'P' then
	ls_texto = 'Gastos de proyectos'
ELSEIF is_tipo_gasto = 'T' then
	ls_texto = 'Gastos de parada'
ELSEIF is_tipo_gasto = 'A' then
	ls_texto = 'Gastos de activos'
ELSEIF is_tipo_gasto = 'N' then
	ls_texto = 'No gastos'
ELSEIF is_tipo_gasto = 'E' then
	ls_texto = 'Gastos de exportación'
ELSEIF is_tipo_gasto = 'F' then
	ls_texto = 'Gastos de fondos'
ELSE
	ls_texto = 'Gastos no definidos'
END IF

idw_1.SettransObject(sqlca)

idw_1.ii_zoom_actual = 100
ib_preview = false
event ue_preview()

idw_1.Retrieve(is_tipo_gasto)
idw_1.Visible = True
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
idw_1.Object.t_texto.text = ls_texto
idw_1.Object.p_logo.filename = gs_logo

end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

type dw_report from u_dw_rpt within w_sig781_det_fce_presupuesto
integer y = 8
integer width = 3131
integer height = 1620
boolean bringtotop = true
string dataobject = "d_rpt_fce_presup_x_detalle_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;String ls_cnta_prsp
sg_parametros lstr_rep

if row=0 then return

IF this.RowCount()=0 THEN Return

ls_cnta_prsp = this.object.cnta_prsp[row]

lstr_rep.string1 = is_tipo_gasto
lstr_rep.string2 = ls_cnta_prsp

OpenSheetWithParm(w_sig781_fce_presup_ejec_det_cc, lstr_rep, w_main, 2, layered!)


end event

