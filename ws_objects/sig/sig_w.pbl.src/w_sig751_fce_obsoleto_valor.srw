$PBExportHeader$w_sig751_fce_obsoleto_valor.srw
forward
global type w_sig751_fce_obsoleto_valor from w_rpt
end type
type dw_report from u_dw_rpt within w_sig751_fce_obsoleto_valor
end type
end forward

global type w_sig751_fce_obsoleto_valor from w_rpt
integer x = 256
integer y = 348
integer width = 3218
integer height = 1676
string title = "Stock valorizado de materiales (SIG751)"
string menuname = "m_rpt_simple"
long backcolor = 15793151
dw_report dw_report
end type
global w_sig751_fce_obsoleto_valor w_sig751_fce_obsoleto_valor

type variables
Long il_dias
Date id_fecha_hoy

end variables

on w_sig751_fce_obsoleto_valor.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_sig751_fce_obsoleto_valor.destroy
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

event ue_retrieve;call super::ue_retrieve;String ls_cod_clase, ls_texto
Date ld_fecha_hoy

sg_paramet lstr_rep

lstr_rep = message.powerobjectparm

il_dias = lstr_rep.long1
id_fecha_hoy = lstr_rep.date1

idw_1.ii_zoom_actual = 110
ib_preview = false
event ue_preview()

idw_1.Retrieve(il_dias, id_fecha_hoy)
idw_1.Visible = True
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
idw_1.Object.t_texto.text = 'Días considerados :' + string(il_dias, '#####')
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

type dw_report from u_dw_rpt within w_sig751_fce_obsoleto_valor
integer y = 4
integer width = 3081
integer height = 1468
boolean bringtotop = true
string dataobject = "d_rpt_res_valor_obsoleto_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;String ls_reporte, ls_cod_clase
sg_parametros lstr_rep

IF row=0 then return

IF this.Rowcount( ) = 0 then return

ls_cod_clase = this.object.cod_clase[row]

lstr_rep.string1 = ls_cod_clase
lstr_rep.long1 = il_dias
lstr_rep.date1 = id_fecha_hoy

OpenSheetWithParm(w_sig751_fce_obsoleto_valor_det, lstr_rep, w_main, 2, layered!)

end event

