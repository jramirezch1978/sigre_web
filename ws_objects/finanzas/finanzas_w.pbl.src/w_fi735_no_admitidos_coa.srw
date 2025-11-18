$PBExportHeader$w_fi735_no_admitidos_coa.srw
forward
global type w_fi735_no_admitidos_coa from w_rpt
end type
type em_1 from editmask within w_fi735_no_admitidos_coa
end type
type cb_1 from commandbutton within w_fi735_no_admitidos_coa
end type
type dw_report from u_dw_rpt within w_fi735_no_admitidos_coa
end type
type gb_1 from groupbox within w_fi735_no_admitidos_coa
end type
end forward

global type w_fi735_no_admitidos_coa from w_rpt
integer width = 2587
integer height = 1708
string title = "No Admitidos COA (FI735)"
string menuname = "m_reporte"
long backcolor = 134217728
em_1 em_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_fi735_no_admitidos_coa w_fi735_no_admitidos_coa

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

ib_preview = FALSE



THIS.Event ue_preview()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text	= gs_empresa
dw_report.object.t_user.text 		= gs_user

end event

on w_fi735_no_admitidos_coa.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.em_1=create em_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.gb_1
end on

on w_fi735_no_admitidos_coa.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
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

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;dw_report.EVENT ue_print()
end event

type em_1 from editmask within w_fi735_no_admitidos_coa
integer x = 64
integer y = 72
integer width = 251
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_1 from commandbutton within w_fi735_no_admitidos_coa
integer x = 384
integer y = 60
integer width = 375
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Recuperar"
end type

event clicked;Long ll_ano

ll_ano = Long(em_1.text)

dw_report.Retrieve(ll_ano)
end event

type dw_report from u_dw_rpt within w_fi735_no_admitidos_coa
integer x = 32
integer y = 224
integer width = 2491
integer height = 1284
string dataobject = "d_rpt_no_admitidos_x_coa_tbl"
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_fi735_no_admitidos_coa
integer x = 27
integer y = 8
integer width = 832
integer height = 184
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
end type

