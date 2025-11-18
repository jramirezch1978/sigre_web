$PBExportHeader$w_fl726_consist_pago_trip.srw
forward
global type w_fl726_consist_pago_trip from w_rpt
end type
type st_1 from statictext within w_fl726_consist_pago_trip
end type
type em_hasta from editmask within w_fl726_consist_pago_trip
end type
type cb_1 from commandbutton within w_fl726_consist_pago_trip
end type
type em_ano from editmask within w_fl726_consist_pago_trip
end type
type em_desde from editmask within w_fl726_consist_pago_trip
end type
type st_3 from statictext within w_fl726_consist_pago_trip
end type
type st_2 from statictext within w_fl726_consist_pago_trip
end type
type dw_report from u_dw_rpt within w_fl726_consist_pago_trip
end type
end forward

global type w_fl726_consist_pago_trip from w_rpt
integer width = 3035
integer height = 4012
string title = "Consistencia Pagos Tripulantes (FL726)"
string menuname = "m_rpt"
long backcolor = 67108864
st_1 st_1
em_hasta em_hasta
cb_1 cb_1
em_ano em_ano
em_desde em_desde
st_3 st_3
st_2 st_2
dw_report dw_report
end type
global w_fl726_consist_pago_trip w_fl726_consist_pago_trip

type variables
uo_parte_pesca iuo_parte
end variables

on w_fl726_consist_pago_trip.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_1=create st_1
this.em_hasta=create em_hasta
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_desde=create em_desde
this.st_3=create st_3
this.st_2=create st_2
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_hasta
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.em_desde
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.dw_report
end on

on w_fl726_consist_pago_trip.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_hasta)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_desde)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_report)
end on

event ue_retrieve;call super::ue_retrieve;integer 	li_mes1, li_mes2, li_ano
string 	ls_mensaje, ls_nave

li_ano = integer(em_ano.text)
li_mes1 = integer(em_desde.text)
li_mes2 = integer(em_hasta.text)

idw_1.Retrieve(li_ano, li_mes1, li_mes2)
idw_1.Visible = True
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.Datawindow.Print.Orientation = 1

iuo_parte = create uo_parte_pesca

em_ano.text = string( year( Date(f_fecha_actual()) ) )
em_desde.text = string( month( Date(f_fecha_actual()) ) )
em_hasta.text = string( month( Date(f_fecha_actual()) ) )

//idw_1.object.p_logo.filename 	= gs_logo
//idw_1.object.t_empresa.text 	= gs_empresa
//idw_1.object.t_usuario.text	= gs_user
//idw_1.object.t_objeto.text		= this.classname()
end event

event resize;call super::resize;this.SetRedraw(false)
dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
this.SetRedraw(true)
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
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

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type st_1 from statictext within w_fl726_consist_pago_trip
integer x = 1230
integer y = 56
integer width = 306
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Mes hasta:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_hasta from editmask within w_fl726_consist_pago_trip
integer x = 1554
integer y = 36
integer width = 283
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
end type

event modified;dw_report.Reset()
end event

type cb_1 from commandbutton within w_fl726_consist_pago_trip
integer x = 1865
integer y = 40
integer width = 393
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve( )
end event

type em_ano from editmask within w_fl726_consist_pago_trip
integer x = 229
integer y = 36
integer width = 315
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

type em_desde from editmask within w_fl726_consist_pago_trip
integer x = 933
integer y = 36
integer width = 283
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
end type

event modified;dw_report.Reset()
end event

type st_3 from statictext within w_fl726_consist_pago_trip
integer x = 27
integer y = 56
integer width = 165
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl726_consist_pago_trip
integer x = 608
integer y = 56
integer width = 306
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Mes desde:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_fl726_consist_pago_trip
integer y = 172
integer width = 2482
integer height = 1412
integer taborder = 70
string dataobject = "d_rpt_consist_pagos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

