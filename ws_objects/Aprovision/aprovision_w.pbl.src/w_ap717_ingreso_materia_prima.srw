$PBExportHeader$w_ap717_ingreso_materia_prima.srw
forward
global type w_ap717_ingreso_materia_prima from w_rpt
end type
type st_desc_moneda from statictext within w_ap717_ingreso_materia_prima
end type
type st_desc_und from statictext within w_ap717_ingreso_materia_prima
end type
type st_descripcion from statictext within w_ap717_ingreso_materia_prima
end type
type sle_und from singlelineedit within w_ap717_ingreso_materia_prima
end type
type sle_moneda from singlelineedit within w_ap717_ingreso_materia_prima
end type
type sle_especie from singlelineedit within w_ap717_ingreso_materia_prima
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap717_ingreso_materia_prima
end type
type cbx_especie from checkbox within w_ap717_ingreso_materia_prima
end type
type dw_origen from u_dw_abc within w_ap717_ingreso_materia_prima
end type
type pb_1 from picturebutton within w_ap717_ingreso_materia_prima
end type
type dw_report from u_dw_rpt within w_ap717_ingreso_materia_prima
end type
type gb_1 from groupbox within w_ap717_ingreso_materia_prima
end type
type gb_2 from groupbox within w_ap717_ingreso_materia_prima
end type
type gb_3 from groupbox within w_ap717_ingreso_materia_prima
end type
end forward

global type w_ap717_ingreso_materia_prima from w_rpt
integer width = 4014
integer height = 2488
string title = "Ingreso de Materia Prima   (AP717)"
string menuname = "m_rpt"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_query_retrieve ( )
st_desc_moneda st_desc_moneda
st_desc_und st_desc_und
st_descripcion st_descripcion
sle_und sle_und
sle_moneda sle_moneda
sle_especie sle_especie
uo_fecha uo_fecha
cbx_especie cbx_especie
dw_origen dw_origen
pb_1 pb_1
dw_report dw_report
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_ap717_ingreso_materia_prima w_ap717_ingreso_materia_prima

type variables
string is_cod_origen
end variables

forward prototypes
public function boolean of_verificar ()
end prototypes

event ue_query_retrieve();this.event dynamic ue_retrieve()
end event

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

long 		ll_i
String 	ls_separador
boolean	lb_ok

is_cod_origen = ''
ls_separador  = ''
lb_ok			  = True

IF sle_especie.Text = '' and Not cbx_especie.Checked THEN
	messagebox('Aprovisionamiento', 'Por favor seleccione una Especie')
	RETURN lb_ok = False
END IF

IF sle_moneda.text = '' THEN
	messagebox('Aprovisionamiento', 'Por favor seleccione una moneda')
	RETURN lb_ok = False
END IF

IF sle_und.text = '' THEN
	messagebox('Aprovisionamiento', 'Por favor seleccione una unidad')
	RETURN lb_ok = False
END IF

// leer el dw_origen con los origenes seleccionados
For ll_i = 1 To dw_origen.RowCount()
	If dw_origen.Object.Chec[ll_i] = '1' Then
		if is_cod_origen <>'' THEN ls_separador = ', '
		is_cod_origen = is_cod_origen + ls_separador + dw_origen.Object.cod_origen[ll_i]
	end if
Next

IF LEN(is_cod_origen) = 0 THEN
	messagebox('Aprovisionamiento', 'Debe seleccionar al menos un origen para el Reporte')
	return lb_ok = False
END IF

RETURN lb_ok





end function

on w_ap717_ingreso_materia_prima.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_desc_moneda=create st_desc_moneda
this.st_desc_und=create st_desc_und
this.st_descripcion=create st_descripcion
this.sle_und=create sle_und
this.sle_moneda=create sle_moneda
this.sle_especie=create sle_especie
this.uo_fecha=create uo_fecha
this.cbx_especie=create cbx_especie
this.dw_origen=create dw_origen
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_desc_moneda
this.Control[iCurrent+2]=this.st_desc_und
this.Control[iCurrent+3]=this.st_descripcion
this.Control[iCurrent+4]=this.sle_und
this.Control[iCurrent+5]=this.sle_moneda
this.Control[iCurrent+6]=this.sle_especie
this.Control[iCurrent+7]=this.uo_fecha
this.Control[iCurrent+8]=this.cbx_especie
this.Control[iCurrent+9]=this.dw_origen
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
end on

on w_ap717_ingreso_materia_prima.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_desc_moneda)
destroy(this.st_desc_und)
destroy(this.st_descripcion)
destroy(this.sle_und)
destroy(this.sle_moneda)
destroy(this.sle_especie)
destroy(this.uo_fecha)
destroy(this.cbx_especie)
destroy(this.dw_origen)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;long ll_row

idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

// Para mostrar los origenes
dw_origen.SetTransObject(sqlca)
dw_origen.Retrieve()
  
ll_row = dw_origen.Find ("cod_origen = '" + gs_origen +"'", 1, dw_origen.RowCount())

dw_origen.object.chec[ll_row] = '1'

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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;string ls_rango_fecha, ls_especie, ls_cod_moneda, ls_cod_und
date   ld_fecha_ini, ld_fecha_fin
dec    ld_tipo_cambio 


// Llama a la función para verificar
IF NOT of_verificar() THEN RETURN

ls_cod_und   	= sle_und.text
ls_cod_moneda	= sle_moneda.text
ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))

idw_1.SetRedraw(false)

//Recupera los datos del reporte
IF cbx_especie.Checked THEN
	ls_especie = '%%'
ELSE
	ls_especie = Trim(sle_especie.Text)
END IF


idw_1.Retrieve(ls_cod_und, ls_cod_moneda, ld_fecha_ini, ld_fecha_fin, ls_especie, is_cod_origen)

ls_rango_fecha = 'Del ' + string(ld_fecha_ini) + ' Al ' + string (ld_fecha_fin)

idw_1.object.usuario_t.text 		= gs_user
idw_1.object.p_logo.filename 		= gs_logo
idw_1.object.rango_1.text			= ls_rango_fecha
idw_1.object.peso_t.text			= 'Peso'+'~n~r'+ls_cod_und
idw_1.object.precio_t.text			= 'Precio'+'~n~r'+ls_cod_moneda

// para printpreview

idw_1.Visible = True
idw_1.SetRedraw(true)

end event

type st_desc_moneda from statictext within w_ap717_ingreso_materia_prima
integer x = 1568
integer y = 72
integer width = 553
integer height = 76
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

type st_desc_und from statictext within w_ap717_ingreso_materia_prima
integer x = 1568
integer y = 228
integer width = 553
integer height = 76
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

type st_descripcion from statictext within w_ap717_ingreso_materia_prima
integer x = 585
integer y = 228
integer width = 699
integer height = 76
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

type sle_und from singlelineedit within w_ap717_ingreso_materia_prima
event dobleclick pbm_lbuttondblclk
integer x = 1385
integer y = 228
integer width = 169
integer height = 76
integer taborder = 50
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
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT UND AS COD_UND, " &
		  + "DESC_UNIDAD AS DESCRIPCION_UNIDAD " &
		  + "FROM UNIDAD " 
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
IF ls_codigo <> '' THEN
	THIS.text 			= ls_codigo
	st_desc_und.text  = ls_data
END IF


end event

event modified;String 	ls_unidad, ls_desc

ls_unidad = sle_und.text

SELECT desc_unidad
	INTO :ls_desc
FROM unidad
WHERE und = :ls_unidad;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Unidad no existe')
	This.text 			= ''
	st_desc_und.text  = ''
	return
END IF

st_desc_und.text = ls_desc

end event

type sle_moneda from singlelineedit within w_ap717_ingreso_materia_prima
event dobleclick pbm_lbuttondblclk
integer x = 1385
integer y = 72
integer width = 169
integer height = 76
integer taborder = 60
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
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT COD_MONEDA AS CODIGO_MONEDA, " &
		  + "DESCRIPCION AS DESCRIPCION_MONEDA " &
		  + "FROM MONEDA " &
		  + "WHERE FLAG_ESTADO = '1'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
IF ls_codigo <> '' THEN
	THIS.text 				= ls_codigo
	st_desc_moneda.text  = ls_data
END IF

end event

event modified;String 	ls_moneda, ls_desc

ls_moneda = sle_moneda.text

SELECT descripcion
	INTO :ls_desc
FROM moneda
WHERE cod_moneda = :ls_moneda;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Moneda no existe')
	This.text 			  = ''
	st_desc_moneda.text = ''
	return
END IF

st_desc_moneda.text = ls_desc


end event

type sle_especie from singlelineedit within w_ap717_ingreso_materia_prima
event dobleclick pbm_lbuttondblclk
integer x = 297
integer y = 228
integer width = 283
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT ESPECIE AS COD_ESPECIE, " &
		  + "DESCR_ESPECIE AS DESCRIPCION_ESPECIE " &
		  + "FROM TG_ESPECIES " &
		  + "WHERE FLAG_ESTADO = '1'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text 				= ls_codigo
	st_descripcion.text = ls_data
end if

end event

event modified;String 	ls_especie, ls_desc

ls_especie = sle_especie.text
if ls_especie = '' or IsNull(ls_especie) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de especie')
	return
end if

SELECT descr_especie
	INTO :ls_desc
FROM tg_especies
WHERE especie = :ls_especie;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Especie no existe')
	This.text 				= ''
	st_descripcion.text  = ''
	return
end if

st_descripcion.text = ls_desc

end event

type uo_fecha from u_ingreso_rango_fechas within w_ap717_ingreso_materia_prima
integer x = 23
integer y = 56
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(RelativeDate(today(),-31) , today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas


end event

type cbx_especie from checkbox within w_ap717_ingreso_materia_prima
integer x = 50
integer y = 236
integer width = 247
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todas"
boolean checked = true
end type

event clicked;IF THIS.CHECKED THEN
	sle_especie.Enabled 	= False
	sle_especie.Text 		= ''
	st_descripcion.Text  = ''
ELSE
	sle_especie.Enabled = True
END IF
end event

type dw_origen from u_dw_abc within w_ap717_ingreso_materia_prima
integer x = 2185
integer y = 56
integer width = 1001
integer height = 260
string dataobject = "d_ap_origen_liq_pesca_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type pb_1 from picturebutton within w_ap717_ingreso_materia_prima
integer x = 3214
integer y = 76
integer width = 306
integer height = 148
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_ap717_ingreso_materia_prima
integer x = 46
integer y = 384
integer width = 2565
integer height = 1592
integer taborder = 30
string dataobject = "d_ap_ingreso_materia_prima_grp"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ap717_ingreso_materia_prima
integer x = 1362
integer y = 20
integer width = 786
integer height = 152
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Moneda"
end type

type gb_2 from groupbox within w_ap717_ingreso_materia_prima
integer x = 37
integer y = 168
integer width = 1271
integer height = 164
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Especie:"
end type

type gb_3 from groupbox within w_ap717_ingreso_materia_prima
integer x = 1362
integer y = 172
integer width = 786
integer height = 156
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Unidad"
end type

