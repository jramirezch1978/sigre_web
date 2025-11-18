$PBExportHeader$w_ve734_rpt_pln_cobranza.srw
forward
global type w_ve734_rpt_pln_cobranza from w_rpt
end type
type dw_report from u_dw_rpt within w_ve734_rpt_pln_cobranza
end type
end forward

global type w_ve734_rpt_pln_cobranza from w_rpt
integer width = 3346
integer height = 1936
string title = "Planilla de Cobranza (FI726)"
string menuname = "m_reporte"
long backcolor = 12632256
dw_report dw_report
end type
global w_ve734_rpt_pln_cobranza w_ve734_rpt_pln_cobranza

type variables
Str_cns_pop istr_1
end variables

on w_ve734_rpt_pln_cobranza.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_ve734_rpt_pln_cobranza.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;

idw_1 = dw_report
idw_1.Visible = True
idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()

istr_1 = Message.PowerObjectParm	



This.Event ue_retrieve()


end event

event ue_retrieve;call super::ue_retrieve;String ls_pln_cobranza

ls_pln_cobranza = istr_1.arg [1]

//eliminacion de tabla temporal
delete from  tt_fin_pln_cob_det ;



DECLARE PB_USP_FIN_RPT_PLN_COBRANZA PROCEDURE FOR USP_FIN_RPT_PLN_COBRANZA 
(:ls_pln_cobranza);
EXECUTE PB_USP_FIN_RPT_PLN_COBRANZA ;



IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF


CLOSE PB_USP_FIN_RPT_PLN_COBRANZA ;


dw_report.Retrieve(ls_pln_cobranza,gs_empresa,gs_user)
idw_1.object.p_logo.filename = gs_logo
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x
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

type dw_report from u_dw_rpt within w_ve734_rpt_pln_cobranza
integer x = 14
integer y = 12
integer width = 3278
integer height = 1688
integer taborder = 20
string dataobject = "d_rpt_pln_cobranza_tbl"
end type

