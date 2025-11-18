$PBExportHeader$w_af702_resumen_activo_fijo_x_rango.srw
forward
global type w_af702_resumen_activo_fijo_x_rango from w_rpt
end type
type cbx_mostrar from checkbox within w_af702_resumen_activo_fijo_x_rango
end type
type st_5 from statictext within w_af702_resumen_activo_fijo_x_rango
end type
type em_year2 from editmask within w_af702_resumen_activo_fijo_x_rango
end type
type st_4 from statictext within w_af702_resumen_activo_fijo_x_rango
end type
type em_mes2 from editmask within w_af702_resumen_activo_fijo_x_rango
end type
type st_3 from statictext within w_af702_resumen_activo_fijo_x_rango
end type
type pb_aceptar from picturebutton within w_af702_resumen_activo_fijo_x_rango
end type
type st_descripcion from statictext within w_af702_resumen_activo_fijo_x_rango
end type
type sle_origen from singlelineedit within w_af702_resumen_activo_fijo_x_rango
end type
type st_2 from statictext within w_af702_resumen_activo_fijo_x_rango
end type
type st_1 from statictext within w_af702_resumen_activo_fijo_x_rango
end type
type em_mes from editmask within w_af702_resumen_activo_fijo_x_rango
end type
type em_year from editmask within w_af702_resumen_activo_fijo_x_rango
end type
type dw_report from u_dw_rpt within w_af702_resumen_activo_fijo_x_rango
end type
type gb_2 from groupbox within w_af702_resumen_activo_fijo_x_rango
end type
type gb_1 from groupbox within w_af702_resumen_activo_fijo_x_rango
end type
end forward

global type w_af702_resumen_activo_fijo_x_rango from w_rpt
integer width = 3767
integer height = 2004
string title = "[AF702] Resumen de Activos Fijos por Rango"
string menuname = "m_reporte"
windowstate windowstate = maximized!
cbx_mostrar cbx_mostrar
st_5 st_5
em_year2 em_year2
st_4 st_4
em_mes2 em_mes2
st_3 st_3
pb_aceptar pb_aceptar
st_descripcion st_descripcion
sle_origen sle_origen
st_2 st_2
st_1 st_1
em_mes em_mes
em_year em_year
dw_report dw_report
gb_2 gb_2
gb_1 gb_1
end type
global w_af702_resumen_activo_fijo_x_rango w_af702_resumen_activo_fijo_x_rango

on w_af702_resumen_activo_fijo_x_rango.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_mostrar=create cbx_mostrar
this.st_5=create st_5
this.em_year2=create em_year2
this.st_4=create st_4
this.em_mes2=create em_mes2
this.st_3=create st_3
this.pb_aceptar=create pb_aceptar
this.st_descripcion=create st_descripcion
this.sle_origen=create sle_origen
this.st_2=create st_2
this.st_1=create st_1
this.em_mes=create em_mes
this.em_year=create em_year
this.dw_report=create dw_report
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_mostrar
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.em_year2
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.em_mes2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.pb_aceptar
this.Control[iCurrent+8]=this.st_descripcion
this.Control[iCurrent+9]=this.sle_origen
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.em_mes
this.Control[iCurrent+13]=this.em_year
this.Control[iCurrent+14]=this.dw_report
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.gb_1
end on

on w_af702_resumen_activo_fijo_x_rango.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_mostrar)
destroy(this.st_5)
destroy(this.em_year2)
destroy(this.st_4)
destroy(this.em_mes2)
destroy(this.st_3)
destroy(this.pb_aceptar)
destroy(this.st_descripcion)
destroy(this.sle_origen)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_mes)
destroy(this.em_year)
destroy(this.dw_report)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)


sle_origen.text = gs_origen
sle_origen.event modified( )

em_year.text = String(Year(today()))
em_mes.text  = String(Month(today()))

em_year2.text = String(Year(today()))
em_mes2.text  = String(Month(today()))

end event

event ue_retrieve;call super::ue_retrieve;String  ls_origen, ls_mes, ls_mensaje
Long    ll_year, ll_mes, ll_year2, ll_mes2
date	  ld_fecha

ll_year = Long(em_year.text)
ll_mes = Long(em_mes.text)
ll_year2 = Long(em_year2.text)
ll_mes2 = Long(em_mes2.text)
ls_origen = sle_origen.Text
DECLARE USP_AFI_RPT_DET_ACTIVOS_RANGO PROCEDURE FOR 
		  USP_AFI_RPT_DET_ACTIVOS_RANGO ( :ll_year, 
		  									 :ll_mes, 
											 :ls_origen,
											 :ll_year2,
											 :ll_mes2) ;

EXECUTE USP_AFI_RPT_DET_ACTIVOS_RANGO ;

if SQLCA.SQLCode = -1 then
  ls_mensaje = sqlca.sqlerrtext
  rollback ;
  MessageBox("SQL error", ls_mensaje, StopSign!)
  MessageBox('Atención','No se realizó el cálculo de C.T.S. decreto de urgencia', Exclamation! )
end if

CLOSE USP_AFI_RPT_DET_ACTIVOS_RANGO;

ls_mes  = String(date(('01'+ '/'+ string(ll_mes, '##')+'/' + string(ll_year))),'mmm')

idw_1.Visible = True
idw_1.Retrieve(em_year.text, ls_mes)

THIS.Event ue_preview()

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
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

type cbx_mostrar from checkbox within w_af702_resumen_activo_fijo_x_rango
integer x = 2537
integer y = 76
integer width = 690
integer height = 124
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar Fec. de Imp"
end type

type st_5 from statictext within w_af702_resumen_activo_fijo_x_rango
integer x = 1760
integer y = 116
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

type em_year2 from editmask within w_af702_resumen_activo_fijo_x_rango
integer x = 1897
integer y = 100
integer width = 210
integer height = 84
integer taborder = 40
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

ll_mes = long(em_mes2.text)

ls_fecha = String('01'+'/'+string(ll_mes + 1, '00') +'/' + This.text)


end event

type st_4 from statictext within w_af702_resumen_activo_fijo_x_rango
integer x = 2126
integer y = 116
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

type em_mes2 from editmask within w_af702_resumen_activo_fijo_x_rango
integer x = 2258
integer y = 104
integer width = 201
integer height = 84
integer taborder = 50
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

ll_mes = long(em_mes2.text)

IF ll_mes < 1 OR ll_mes > 12 OR Isnull(ll_mes) THEN
	MessageBox('Aviso', 'Debe El valor para el mes no es correcto')
	This.text  = String(Month(today()))
	RETURN 1
END IF


end event

type st_3 from statictext within w_af702_resumen_activo_fijo_x_rango
integer x = 1481
integer y = 120
integer width = 251
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "HASTA"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_aceptar from picturebutton within w_af702_resumen_activo_fijo_x_rango
integer x = 3323
integer y = 52
integer width = 306
integer height = 148
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\aceptar.bmp"
alignment htextalign = left!
end type

event clicked;String  ls_origen, ls_mes, ls_year, ls_mes2, ls_year2

ls_origen = sle_origen.text
ls_year = em_year.text
ls_year2 = em_year2.text
ls_mes = em_mes.text
ls_mes2 = em_mes2.text

IF IsNull(ls_origen) OR LEN(ls_origen) = 0 THEN
	messagebox('Aviso', 'Por favor ingrese un codigo de Origen')
	RETURN 1
END IF

IF IsNull(ls_mes) OR LEN(ls_mes) = 0 THEN
	messagebox('Aviso', 'Por favor ingrese un Mes Correcto')
	RETURN 1
END IF

IF IsNull(ls_year) OR LEN(ls_year) = 0 THEN
	messagebox('Aviso', 'Por favor ingrese un Año Correcto')
	RETURN 1
END IF

IF integer(ls_year) > integer (ls_year2) THEN
	messagebox('Aviso', 'Por favor el año de inicio no puede ser mayor al año de fin')
	RETURN 1
ELSEIF ls_year = ls_year2 AND integer(ls_mes) > integer (ls_mes2) THEN
	messagebox('Aviso', 'Por favor el mes de inicio no puede ser mayor al mes de fin')
	RETURN 1	
END IF

Parent.Event ue_retrieve()
end event

type st_descripcion from statictext within w_af702_resumen_activo_fijo_x_rango
integer x = 229
integer y = 100
integer width = 453
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_af702_resumen_activo_fijo_x_rango
event dobleclick pbm_lbuttondblclk
integer x = 87
integer y = 100
integer width = 119
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT COD_ORIGEN AS CODIGO_ORIGEN, " &
		  + "NOMBRE AS DESCRIPCION " &
		  + "FROM ORIGEN " &
		  + "WHERE FLAG_ESTADO = '1'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
IF ls_codigo <> '' THEN
	This.text 				= ls_codigo
	st_descripcion.text  = ls_data
END IF

end event

event modified;String 	ls_cod_origen, ls_desc, ls_null

SetNull(ls_null)

ls_cod_origen = sle_origen.text
IF ls_cod_origen = '' OR IsNull(ls_cod_origen) THEN
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	RETURN
END IF

SELECT NOMBRE
	INTO :ls_desc
FROM ORIGEN
WHERE cod_origen = :ls_cod_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de ORIGEN no existe')
	st_descripcion.text = ls_null
	This.text			  = ls_null
	RETURN
END IF

st_descripcion.text = ls_desc

end event

type st_2 from statictext within w_af702_resumen_activo_fijo_x_rango
integer x = 1097
integer y = 116
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

type st_1 from statictext within w_af702_resumen_activo_fijo_x_rango
integer x = 731
integer y = 116
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

type em_mes from editmask within w_af702_resumen_activo_fijo_x_rango
integer x = 1230
integer y = 104
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

type em_year from editmask within w_af702_resumen_activo_fijo_x_rango
integer x = 869
integer y = 100
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

type dw_report from u_dw_rpt within w_af702_resumen_activo_fijo_x_rango
integer x = 18
integer y = 252
integer width = 3643
integer height = 1560
integer taborder = 70
string dataobject = "dw_rpt_resumen_activos_x_rango_tbl"
end type

event rowfocuschanged;call super::rowfocuschanged;IF currentrow > 0 THEN
	This.SelectRow(0,false)
	This.SelectRow(currentrow,true)
	dw_REPORT.Scrolltorow(currentrow)
END IF

end event

type gb_2 from groupbox within w_af702_resumen_activo_fijo_x_rango
integer x = 64
integer y = 32
integer width = 635
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217750
string text = "Origen"
end type

type gb_1 from groupbox within w_af702_resumen_activo_fijo_x_rango
integer x = 718
integer y = 36
integer width = 1801
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Rango de Meses"
end type

