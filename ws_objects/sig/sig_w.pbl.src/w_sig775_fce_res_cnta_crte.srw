$PBExportHeader$w_sig775_fce_res_cnta_crte.srw
forward
global type w_sig775_fce_res_cnta_crte from w_rpt
end type
type dw_report from u_dw_rpt within w_sig775_fce_res_cnta_crte
end type
end forward

global type w_sig775_fce_res_cnta_crte from w_rpt
integer x = 256
integer y = 348
integer width = 3200
integer height = 1700
string title = "Resumen de cuenta corriente (SIG715)"
string menuname = "m_rpt_simple"
long backcolor = 15793151
dw_report dw_report
end type
global w_sig775_fce_res_cnta_crte w_sig775_fce_res_cnta_crte

type variables
Long il_dias
Date id_fecha_hoy
String is_codrel

end variables

on w_sig775_fce_res_cnta_crte.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_sig775_fce_res_cnta_crte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()
idw_1.object.p_logo.filename = gs_logo
// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;Long ll_ano
String ls_texto

sg_parametros lstr_rep

lstr_rep = message.powerobjectparm
//is_codrel = lstr_rep.string1
ls_texto = 'Saldos acumulados'
//idw_1.SetTransObject(sqlca)
idw_1.ii_zoom_actual = 110
ib_preview = false
event ue_preview()

idw_1.retrieve()

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

type dw_report from u_dw_rpt within w_sig775_fce_res_cnta_crte
integer y = 12
integer width = 3113
integer height = 1460
boolean bringtotop = true
string dataobject = "d_rpt_saldo_trabajador_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;String ls_reporte, ls_cod_trabajador
sg_parametros lstr_rep

IF row=0 then return

IF this.Rowcount( ) = 0 then return

ls_cod_trabajador = this.object.cod_trabajador[row]

lstr_rep.string1 = ls_cod_trabajador

OpenSheetWithParm(w_sig775_fce_det_cnta_crte, lstr_rep, w_main, 2, layered!)

end event

