$PBExportHeader$w_rh608_rpt_f_calculo.srw
forward
global type w_rh608_rpt_f_calculo from w_rpt
end type
type st_4 from statictext within w_rh608_rpt_f_calculo
end type
type ddlb_mes from dropdownlistbox within w_rh608_rpt_f_calculo
end type
type em_ano from editmask within w_rh608_rpt_f_calculo
end type
type st_3 from statictext within w_rh608_rpt_f_calculo
end type
type cb_1 from commandbutton within w_rh608_rpt_f_calculo
end type
type dw_report from u_dw_rpt within w_rh608_rpt_f_calculo
end type
end forward

global type w_rh608_rpt_f_calculo from w_rpt
integer width = 2226
integer height = 1704
string title = "(RH608) Fecha de Calculo "
string menuname = "m_reporte"
st_4 st_4
ddlb_mes ddlb_mes
em_ano em_ano
st_3 st_3
cb_1 cb_1
dw_report dw_report
end type
global w_rh608_rpt_f_calculo w_rh608_rpt_f_calculo

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = FALSE

THIS.Event ue_preview()

em_ano.text = string(date(gnvo_app.of_fecha_actual( )), 'yyyy')

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user
dw_report.object.t_name.text	   = this.classname( )

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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_rh608_rpt_f_calculo.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_4=create st_4
this.ddlb_mes=create ddlb_mes
this.em_ano=create em_ano
this.st_3=create st_3
this.cb_1=create cb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.ddlb_mes
this.Control[iCurrent+3]=this.em_ano
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.dw_report
end on

on w_rh608_rpt_f_calculo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_4)
destroy(this.ddlb_mes)
destroy(this.em_ano)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.dw_report)
end on

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type st_4 from statictext within w_rh608_rpt_f_calculo
integer x = 443
integer y = 40
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "MES:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_mes from dropdownlistbox within w_rh608_rpt_f_calculo
integer x = 640
integer y = 32
integer width = 517
integer height = 856
integer taborder = 30
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

type em_ano from editmask within w_rh608_rpt_f_calculo
integer x = 242
integer y = 32
integer width = 261
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

type st_3 from statictext within w_rh608_rpt_f_calculo
integer x = 50
integer y = 40
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AÑO:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_rh608_rpt_f_calculo
integer x = 1193
integer y = 28
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_ano,ls_mes,ls_cadena

ls_ano = em_ano.text
ls_mes = LEFT(ddlb_mes.text,2)


ls_cadena = ls_ano + ls_mes

dw_report.Retrieve(ls_cadena)

end event

type dw_report from u_dw_rpt within w_rh608_rpt_f_calculo
integer y = 144
integer width = 2094
integer height = 1088
string dataobject = "d_abc_fechas_proceso_tbl"
end type

