$PBExportHeader$w_ve762_proyeccion_ingresos_mensual.srw
forward
global type w_ve762_proyeccion_ingresos_mensual from w_rpt
end type
type cbx_2 from checkbox within w_ve762_proyeccion_ingresos_mensual
end type
type ddlb_mes from dropdownlistbox within w_ve762_proyeccion_ingresos_mensual
end type
type st_2 from statictext within w_ve762_proyeccion_ingresos_mensual
end type
type em_year from editmask within w_ve762_proyeccion_ingresos_mensual
end type
type st_1 from statictext within w_ve762_proyeccion_ingresos_mensual
end type
type dw_reporte from u_dw_rpt within w_ve762_proyeccion_ingresos_mensual
end type
type cb_1 from commandbutton within w_ve762_proyeccion_ingresos_mensual
end type
type gb_1 from groupbox within w_ve762_proyeccion_ingresos_mensual
end type
end forward

global type w_ve762_proyeccion_ingresos_mensual from w_rpt
integer width = 3520
integer height = 2360
string title = "[VE762] Proyeccion de Ingresos Mensual"
string menuname = "m_reporte"
cbx_2 cbx_2
ddlb_mes ddlb_mes
st_2 st_2
em_year em_year
st_1 st_1
dw_reporte dw_reporte
cb_1 cb_1
gb_1 gb_1
end type
global w_ve762_proyeccion_ingresos_mensual w_ve762_proyeccion_ingresos_mensual

on w_ve762_proyeccion_ingresos_mensual.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_2=create cbx_2
this.ddlb_mes=create ddlb_mes
this.st_2=create st_2
this.em_year=create em_year
this.st_1=create st_1
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_2
this.Control[iCurrent+2]=this.ddlb_mes
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_year
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dw_reporte
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve762_proyeccion_ingresos_mensual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_2)
destroy(this.ddlb_mes)
destroy(this.st_2)
destroy(this.em_year)
destroy(this.st_1)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Integer	li_year, li_mes	
String	ls_titulo, ls_flag

li_year = Integer(em_year.text)
li_mes 	= Integer(LEFT(ddlb_mes.text,2))

CHOOSE CASE trim(string(li_mes, '00'))

	CASE '01'
		  ls_titulo = '01 ENERO'
	CASE '02'
		  ls_titulo = '02 FEBRERO'
	CASE '03'
		  ls_titulo = '03 MARZO'
	CASE '04'
		  ls_titulo = '04 ABRIL'
	CASE '05'
		  ls_titulo = '05 MAYO'
	CASE '06'
		  ls_titulo = '06 JUNIO'
	CASE '07'
		  ls_titulo = '07 JULIO'
	CASE '08'
		  ls_titulo = '08 AGOSTO'
	CASE '09'
		  ls_titulo = '09 SEPTIEMBRE'
	CASE '10'
		  ls_titulo = '10 OCTUBRE'
	CASE '11'
		  ls_titulo = '11 NOVIEMBRE'
	CASE '12'
		  ls_titulo = '12 DICIEMBRE'
END CHOOSE
//--

if cbx_2.checked then
	ls_flag = '1'
else
	ls_flag = '0'
end if

ls_titulo = 'PERIODO ' + ls_titulo + ' - ' + string(li_year)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user
idw_1.object.t_titulo2.text  = ls_titulo

idw_1.retrieve( li_year, li_mes, ls_flag )


end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

Event ue_preview()

em_year.text = string(date(gnvo_app.of_fecha_Actual()), 'yyyy')

//This.Event ue_retrieve()

// ii_help = 101           // help topic




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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_reporte.width  = newwidth - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

type cbx_2 from checkbox within w_ve762_proyeccion_ingresos_mensual
integer x = 41
integer y = 172
integer width = 654
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Deducir cuotas pagadas"
end type

type ddlb_mes from dropdownlistbox within w_ve762_proyeccion_ingresos_mensual
integer x = 645
integer y = 68
integer width = 517
integer height = 856
integer taborder = 40
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

type st_2 from statictext within w_ve762_proyeccion_ingresos_mensual
integer x = 453
integer y = 80
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

type em_year from editmask within w_ve762_proyeccion_ingresos_mensual
integer x = 210
integer y = 68
integer width = 229
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "0000"
boolean spin = true
double increment = 1
string minmax = "1~~9999"
end type

type st_1 from statictext within w_ve762_proyeccion_ingresos_mensual
integer x = 14
integer y = 80
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

type dw_reporte from u_dw_rpt within w_ve762_proyeccion_ingresos_mensual
integer y = 280
integer width = 3319
integer height = 1556
integer taborder = 0
string dataobject = "d_rpt_proy_ingresos_mensual_crt"
end type

type cb_1 from commandbutton within w_ve762_proyeccion_ingresos_mensual
integer x = 1225
integer y = 44
integer width = 352
integer height = 172
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Event ue_retrieve()
end event

type gb_1 from groupbox within w_ve762_proyeccion_ingresos_mensual
integer width = 3232
integer height = 268
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtro para el reporte"
end type

