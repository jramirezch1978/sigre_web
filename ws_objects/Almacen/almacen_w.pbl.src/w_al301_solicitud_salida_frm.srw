$PBExportHeader$w_al301_solicitud_salida_frm.srw
forward
global type w_al301_solicitud_salida_frm from w_rpt
end type
type dw_report from u_dw_rpt within w_al301_solicitud_salida_frm
end type
end forward

global type w_al301_solicitud_salida_frm from w_rpt
integer x = 256
integer y = 348
integer width = 3314
integer height = 1676
string title = "Formato de Solicitud de salida"
string menuname = "m_impresion"
long backcolor = 12632256
dw_report dw_report
end type
global w_al301_solicitud_salida_frm w_al301_solicitud_salida_frm

on w_al301_solicitud_salida_frm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_al301_solicitud_salida_frm.destroy
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

event ue_retrieve();call super::ue_retrieve;String ls_cod_origen, ls_nro_oc

str_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_cod_origen = lstr_rep.string1
ls_nro_oc = lstr_rep.string2
//// ejecuta store procedure para mostrar totales
//DECLARE PB_USP_RPT_ORDEN_COMPRA PROCEDURE FOR USP_RPT_ORDEN_COMPRA( :ls_cod_origen, :ll_nro_oc);
//EXECUTE PB_USP_RPT_ORDEN_COMPRA;
//IF SQLCA.SQLCODE = -1 THEN
//	Messagebox( "Error", "Al ejecutar Store Procedure")
//	Return
//END IF

idw_1.Retrieve(ls_cod_origen, ls_nro_oc)
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

type dw_report from u_dw_rpt within w_al301_solicitud_salida_frm
integer y = 4
integer width = 3273
integer height = 1468
boolean bringtotop = true
string dataobject = "d_rpt_sol_salida"
boolean hscrollbar = true
boolean vscrollbar = true
end type

