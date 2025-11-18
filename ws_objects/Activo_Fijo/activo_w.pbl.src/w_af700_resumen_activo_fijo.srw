$PBExportHeader$w_af700_resumen_activo_fijo.srw
forward
global type w_af700_resumen_activo_fijo from w_rpt
end type
type cbx_mostrar from checkbox within w_af700_resumen_activo_fijo
end type
type pb_aceptar from picturebutton within w_af700_resumen_activo_fijo
end type
type st_2 from statictext within w_af700_resumen_activo_fijo
end type
type st_1 from statictext within w_af700_resumen_activo_fijo
end type
type em_mes from editmask within w_af700_resumen_activo_fijo
end type
type em_year from editmask within w_af700_resumen_activo_fijo
end type
type dw_report from u_dw_rpt within w_af700_resumen_activo_fijo
end type
type gb_1 from groupbox within w_af700_resumen_activo_fijo
end type
end forward

global type w_af700_resumen_activo_fijo from w_rpt
integer width = 3767
integer height = 2004
string title = "[AF700] Resumen de Activos Fijos"
string menuname = "m_reporte"
windowstate windowstate = maximized!
cbx_mostrar cbx_mostrar
pb_aceptar pb_aceptar
st_2 st_2
st_1 st_1
em_mes em_mes
em_year em_year
dw_report dw_report
gb_1 gb_1
end type
global w_af700_resumen_activo_fijo w_af700_resumen_activo_fijo

on w_af700_resumen_activo_fijo.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_mostrar=create cbx_mostrar
this.pb_aceptar=create pb_aceptar
this.st_2=create st_2
this.st_1=create st_1
this.em_mes=create em_mes
this.em_year=create em_year
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_mostrar
this.Control[iCurrent+2]=this.pb_aceptar
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.em_mes
this.Control[iCurrent+6]=this.em_year
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.gb_1
end on

on w_af700_resumen_activo_fijo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_mostrar)
destroy(this.pb_aceptar)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_mes)
destroy(this.em_year)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)


em_year.text = String(Year(today()))
em_mes.text  = String(Month(today()))


end event

event ue_retrieve;call super::ue_retrieve;String  ls_mensaje
Long    ll_year, ll_mes 
date	  ld_fecha

ll_year = Long(em_year.text)
ll_mes = Long(em_mes.text)


idw_1.Retrieve(ll_year, ll_mes)

idw_1.Visible = True
ib_preview = false
THIS.Event ue_preview()

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text   = gs_empresa
idw_1.object.t_usuario.text  = gs_user

IF cbx_mostrar.checked = false THEN
	idw_1.Object.fecha_imp.visible = FALSE
ELSE
	idw_1.Object.fecha_imp.visible = TRUE
END IF
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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type cbx_mostrar from checkbox within w_af700_resumen_activo_fijo
integer x = 786
integer y = 76
integer width = 850
integer height = 124
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar Fecha de Impresión"
end type

type pb_aceptar from picturebutton within w_af700_resumen_activo_fijo
integer x = 1705
integer width = 393
integer height = 204
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\sigre\resources\BMP\aceptar.bmp"
alignment htextalign = left!
end type

event clicked;String  ls_mes, ls_year

ls_mes = em_mes.text
ls_year = em_year.text

IF IsNull(ls_mes) OR LEN(ls_mes) = 0 THEN
	messagebox('Aviso', 'Por favor ingrese un Mes Correcto')
	RETURN 1
END IF

IF IsNull(ls_year) OR LEN(ls_year) = 0 THEN
	messagebox('Aviso', 'Por favor ingrese un Año Correcto')
	RETURN 1
END IF

Parent.Event ue_retrieve()
end event

type st_2 from statictext within w_af700_resumen_activo_fijo
integer x = 379
integer y = 108
integer width = 133
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Mes:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_af700_resumen_activo_fijo
integer x = 14
integer y = 108
integer width = 123
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Año:"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_mes from editmask within w_af700_resumen_activo_fijo
integer x = 512
integer y = 96
integer width = 201
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
double increment = 1
string minmax = "1~~12"
end type

event modified;Long  	ll_mes
String 	ls_fecha
date		ld_fecha

ll_mes = long(em_mes.text)

IF ll_mes < 1 OR ll_mes > 12 OR Isnull(ll_mes) THEN
	MessageBox('Aviso', 'Debe El valor para el mes no es correcto')
	This.text  = String(Month(today()))
	RETURN 1
END IF


end event

type em_year from editmask within w_af700_resumen_activo_fijo
integer x = 151
integer y = 92
integer width = 210
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
string minmax = "2004~~"
end type

event modified;String ls_fecha
Long	 ll_mes

ll_mes = long(em_mes.text)

ls_fecha = String('01'+'/'+string(ll_mes + 1, '00') +'/' + This.text)


end event

type dw_report from u_dw_rpt within w_af700_resumen_activo_fijo
integer y = 228
integer width = 3643
integer height = 1560
integer taborder = 40
string dataobject = "dw_rpt_resumen_activos_tbl"
end type

event rowfocuschanged;call super::rowfocuschanged;IF currentrow > 0 THEN
	This.SelectRow(0,false)
	This.SelectRow(currentrow,true)
	dw_REPORT.Scrolltorow(currentrow)
END IF

end event

type gb_1 from groupbox within w_af700_resumen_activo_fijo
integer y = 28
integer width = 736
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Periodo"
end type

