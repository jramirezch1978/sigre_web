$PBExportHeader$w_fi728_voucher_o_chq.srw
forward
global type w_fi728_voucher_o_chq from w_rpt
end type
type dw_report from u_dw_rpt within w_fi728_voucher_o_chq
end type
end forward

global type w_fi728_voucher_o_chq from w_rpt
integer width = 2185
integer height = 1356
string title = "Impresion Voucher (FI728)"
string menuname = "m_impresion"
long backcolor = 67108864
boolean clientedge = true
dw_report dw_report
end type
global w_fi728_voucher_o_chq w_fi728_voucher_o_chq

on w_fi728_voucher_o_chq.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_fi728_voucher_o_chq.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;Str_cns_pop lstr_cns_pop


//recibo estructura
lstr_cns_pop = message.powerobjectparm








idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.dataobject = lstr_cns_pop.arg [3]
idw_1.SetTransObject(sqlca)

ib_preview = false
THIS.Event ue_preview()


dw_report.retrieve(lstr_cns_pop.arg [1],Long(lstr_cns_pop.arg [2]),gnvo_app.invo_empresa.is_empresa)
dw_report.Object.p_logo.filename = gnvo_app.is_logo
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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type ole_skin from w_rpt`ole_skin within w_fi728_voucher_o_chq
end type

type dw_report from u_dw_rpt within w_fi728_voucher_o_chq
integer width = 2080
integer height = 1104
string dataobject = "d_rpt_fomato_chq_voucher_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

