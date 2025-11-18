$PBExportHeader$w_fi745_rpt_detracciones.srw
forward
global type w_fi745_rpt_detracciones from w_rpt
end type
type st_2 from statictext within w_fi745_rpt_detracciones
end type
type st_1 from statictext within w_fi745_rpt_detracciones
end type
type em_ano from editmask within w_fi745_rpt_detracciones
end type
type ddlb_mes from dropdownlistbox within w_fi745_rpt_detracciones
end type
type cb_1 from commandbutton within w_fi745_rpt_detracciones
end type
type dw_report from u_dw_rpt within w_fi745_rpt_detracciones
end type
type gb_1 from groupbox within w_fi745_rpt_detracciones
end type
end forward

global type w_fi745_rpt_detracciones from w_rpt
integer width = 2971
integer height = 1768
string title = "Reporte de Detracciones (FI745)"
string menuname = "m_reporte_filter"
st_2 st_2
st_1 st_1
em_ano em_ano
ddlb_mes ddlb_mes
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_fi745_rpt_detracciones w_fi745_rpt_detracciones

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_fi745_rpt_detracciones.create
int iCurrent
call super::create
if this.MenuName = "m_reporte_filter" then this.MenuID = create m_reporte_filter
this.st_2=create st_2
this.st_1=create st_1
this.em_ano=create em_ano
this.ddlb_mes=create ddlb_mes
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_ano
this.Control[iCurrent+4]=this.ddlb_mes
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.gb_1
end on

on w_fi745_rpt_detracciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.ddlb_mes)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = false
THIS.Event ue_preview()


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

event ue_retrieve;call super::ue_retrieve;Long ll_ano ,ll_mes


ll_ano    = Long(em_ano.text)
ll_mes    = Long(LEFT(ddlb_mes.text,2))

idw_1.Retrieve(ll_ano,ll_mes)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type st_2 from statictext within w_fi745_rpt_detracciones
integer x = 471
integer y = 80
integer width = 192
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi745_rpt_detracciones
integer x = 59
integer y = 80
integer width = 215
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_fi745_rpt_detracciones
integer x = 270
integer y = 68
integer width = 174
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type ddlb_mes from dropdownlistbox within w_fi745_rpt_detracciones
integer x = 681
integer y = 72
integer width = 517
integer height = 856
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_fi745_rpt_detracciones
integer x = 1230
integer y = 60
integer width = 402
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_fi745_rpt_detracciones
integer y = 192
integer width = 2889
integer height = 1208
string dataobject = "d_rpt_detracciones_x_pagar_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_fi745_rpt_detracciones
integer width = 2903
integer height = 188
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Datos"
end type

