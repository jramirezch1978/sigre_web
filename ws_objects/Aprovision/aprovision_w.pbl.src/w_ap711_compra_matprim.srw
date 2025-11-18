$PBExportHeader$w_ap711_compra_matprim.srw
forward
global type w_ap711_compra_matprim from w_rpt
end type
type pb_1 from picturebutton within w_ap711_compra_matprim
end type
type st_descripcion from statictext within w_ap711_compra_matprim
end type
type cbx_1 from checkbox within w_ap711_compra_matprim
end type
type dw_origen from u_dw_abc within w_ap711_compra_matprim
end type
type cbx_especie from checkbox within w_ap711_compra_matprim
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_ap711_compra_matprim
end type
type sle_especie from singlelineedit within w_ap711_compra_matprim
end type
type dw_report from u_dw_rpt within w_ap711_compra_matprim
end type
type gb_1 from groupbox within w_ap711_compra_matprim
end type
end forward

global type w_ap711_compra_matprim from w_rpt
integer width = 4032
integer height = 2328
string title = "Reporte de Compra de Materia Prima  (AP711)"
string menuname = "m_rpt"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_query_retrieve ( )
pb_1 pb_1
st_descripcion st_descripcion
cbx_1 cbx_1
dw_origen dw_origen
cbx_especie cbx_especie
uo_fecha uo_fecha
sle_especie sle_especie
dw_report dw_report
gb_1 gb_1
end type
global w_ap711_compra_matprim w_ap711_compra_matprim

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

on w_ap711_compra_matprim.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.pb_1=create pb_1
this.st_descripcion=create st_descripcion
this.cbx_1=create cbx_1
this.dw_origen=create dw_origen
this.cbx_especie=create cbx_especie
this.uo_fecha=create uo_fecha
this.sle_especie=create sle_especie
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.st_descripcion
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.dw_origen
this.Control[iCurrent+5]=this.cbx_especie
this.Control[iCurrent+6]=this.uo_fecha
this.Control[iCurrent+7]=this.sle_especie
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.gb_1
end on

on w_ap711_compra_matprim.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.st_descripcion)
destroy(this.cbx_1)
destroy(this.dw_origen)
destroy(this.cbx_especie)
destroy(this.uo_fecha)
destroy(this.sle_especie)
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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;string ls_rango_fecha, ls_especie
date ld_fecha_ini, ld_fecha_fin


// Llama a la función para verificar

IF NOT of_verificar() THEN RETURN

ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))

idw_1.SetRedraw(false)

//Recupera los datos del reporte

IF cbx_especie.Checked THEN
	ls_especie = '%%'
ELSE
	ls_especie = Trim(sle_especie.Text)
END IF

idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin, ls_especie, is_cod_origen)

ls_rango_fecha = 'Del ' + string(ld_fecha_ini) + ' Al ' + string (ld_fecha_fin)

idw_1.object.usuario_t.text 		= gs_user
idw_1.object.p_logo.filename 		= gs_logo
idw_1.object.rango_1.text			= ls_rango_fecha

idw_1.Visible = True
idw_1.SetRedraw(true)
end event

event ue_saveas;//OVERRIDING
string 		ls_separador, ls_origen, ls_file, ls_path, ls_especie
long			ll_i, ll_rc
Date			ld_fecha_ini, ld_fecha_fin
u_ds_base	lds_datos

// leer el dw_origen con los origenes seleccionados

For ll_i = 1 To dw_origen.RowCount()
	If dw_origen.Object.Chec[ll_i] = '1' Then
		if ls_origen <>'' THEN ls_separador = ', '
		ls_origen = ls_origen + ls_separador + dw_origen.Object.cod_origen[ll_i]
	end if
Next

IF LEN(ls_origen) = 0 THEN
	messagebox('Error', 'Debe seleccionar al menos un origen para el Reporte')
	return
END IF

IF cbx_especie.Checked THEN
	ls_especie = '%%'
ELSE
	ls_especie = Trim(sle_especie.Text)
END IF

ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))

lds_datos 				= create u_ds_base
lds_datos.Dataobject = 'd_ap_pd_compra_matprim_ct'
lds_datos.SetTransObject(SQLCA)

lds_datos.Retrieve(ld_fecha_ini, ld_fecha_fin, ls_especie, ls_origen)

if lds_datos.RowCount() = 0 then
	MessageBox('Error', 'No hay datos para exportar')
	destroy lds_datos
	return
end if

ll_rc = GetFileSaveName ( "Grabar Archivo", ls_path, ls_file, 'XLS', &
    'XLS Files (*.XLS), *.XLS', "C:\",  32770)
 
IF ll_rc <> 1 Then
	return
End If

ll_rc = lds_datos.SaveAs(ls_path, Excel!, TRUE)

if ll_rc = -1 then
	MessageBox('Error', 'Ha ocurrido un error al exportar los datos a excel')
	destroy lds_datos
	return
end if
destroy lds_datos



end event

type pb_1 from picturebutton within w_ap711_compra_matprim
integer x = 3365
integer y = 124
integer width = 306
integer height = 148
integer taborder = 40
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

type st_descripcion from statictext within w_ap711_compra_matprim
integer x = 1262
integer y = 116
integer width = 960
integer height = 88
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

type cbx_1 from checkbox within w_ap711_compra_matprim
integer x = 3301
integer y = 32
integer width = 530
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Formato Vertical"
boolean checked = true
end type

event clicked;IF THIS.checked THEN
	// Para orientacion Portrait (Vertical)
	dw_report.Object.DataWindow.Print.Orientation = 2
	dw_report.Object.page_1.X 		= 2912
	dw_report.Object.date_1.X 		= 2811
	dw_report.Object.usuario_t.X 	= 3067
	dw_report.Object.titulo_1.X	= 992
	dw_report.Object.rango_1.X 	= 1024
	dw_report.Object.dw_1.width 	= 3264
ELSE
	// Para orientacion Landscape  (horizontal)
	dw_report.Object.DataWindow.Print.Orientation = 1
	dw_report.Object.page_1.X 		= 4443
	dw_report.Object.date_1.X 		= 4343
	dw_report.Object.usuario_t.X 	= 4599
	dw_report.Object.titulo_1.X	= 1541
	dw_report.Object.rango_1.X 	= 1573
	dw_report.Object.dw_1.width 	= 4855
END IF

end event

type dw_origen from u_dw_abc within w_ap711_compra_matprim
integer x = 2267
integer y = 12
integer width = 1001
integer height = 260
integer taborder = 20
string dataobject = "d_ap_origen_liq_pesca_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type cbx_especie from checkbox within w_ap711_compra_matprim
integer x = 713
integer y = 124
integer width = 261
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
	st_descripcion.Text = ''
ELSE
	sle_especie.Enabled = True
END IF
end event

type uo_fecha from u_ingreso_rango_fechas_v within w_ap711_compra_matprim
event destroy ( )
integer x = 41
integer y = 36
integer taborder = 30
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type sle_especie from singlelineedit within w_ap711_compra_matprim
event dobleclick pbm_lbuttondblclk
integer x = 969
integer y = 116
integer width = 279
integer height = 88
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
	st_descripcion.text = ''
	This.Text			  = ''
	return
end if

st_descripcion.text = ls_desc

end event

type dw_report from u_dw_rpt within w_ap711_compra_matprim
integer x = 23
integer y = 328
integer width = 3867
integer height = 1604
string dataobject = "d_ap_pd_compra_matprim_cpst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ap711_compra_matprim
integer x = 695
integer y = 28
integer width = 1563
integer height = 220
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Especie:"
end type

