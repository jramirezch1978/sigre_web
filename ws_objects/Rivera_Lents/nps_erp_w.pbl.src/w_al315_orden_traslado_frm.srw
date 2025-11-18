$PBExportHeader$w_al315_orden_traslado_frm.srw
forward
global type w_al315_orden_traslado_frm from w_rpt
end type
type dw_report from u_dw_rpt within w_al315_orden_traslado_frm
end type
end forward

global type w_al315_orden_traslado_frm from w_rpt
integer x = 256
integer y = 348
integer width = 3314
integer height = 2288
string title = "Formate Orden de Venta"
string menuname = "m_impresion"
long backcolor = 1073741824
dw_report dw_report
end type
global w_al315_orden_traslado_frm w_al315_orden_traslado_frm

on w_al315_orden_traslado_frm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_al315_orden_traslado_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;String ls_nro_otr

str_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_nro_otr 		= lstr_rep.string1

idw_1.Retrieve( ls_nro_otr )
idw_1.Visible = True
//idw_1.Object.p_logo.filename = gs_logol
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

type p_pie from w_rpt`p_pie within w_al315_orden_traslado_frm
end type

type ole_skin from w_rpt`ole_skin within w_al315_orden_traslado_frm
end type

type uo_h from w_rpt`uo_h within w_al315_orden_traslado_frm
end type

type st_box from w_rpt`st_box within w_al315_orden_traslado_frm
end type

type phl_logonps from w_rpt`phl_logonps within w_al315_orden_traslado_frm
end type

type p_mundi from w_rpt`p_mundi within w_al315_orden_traslado_frm
end type

type p_logo from w_rpt`p_logo within w_al315_orden_traslado_frm
end type

type dw_report from u_dw_rpt within w_al315_orden_traslado_frm
integer x = 498
integer y = 244
integer width = 3273
integer height = 1468
boolean bringtotop = true
string dataobject = "d_rpt_orden_traslado"
boolean hscrollbar = true
boolean vscrollbar = true
end type

