$PBExportHeader$w_ap719_reporte_semanal_x_embarcacion.srw
$PBExportComments$Record de pesca de embarcaciones
forward
global type w_ap719_reporte_semanal_x_embarcacion from w_rpt
end type
type sle_moneda from singlelineedit within w_ap719_reporte_semanal_x_embarcacion
end type
type st_desc_moneda from statictext within w_ap719_reporte_semanal_x_embarcacion
end type
type dw_origen from u_dw_abc within w_ap719_reporte_semanal_x_embarcacion
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap719_reporte_semanal_x_embarcacion
end type
type sle_und from singlelineedit within w_ap719_reporte_semanal_x_embarcacion
end type
type st_desc_und from statictext within w_ap719_reporte_semanal_x_embarcacion
end type
type mle_observacion from multilineedit within w_ap719_reporte_semanal_x_embarcacion
end type
type st_1 from statictext within w_ap719_reporte_semanal_x_embarcacion
end type
type st_descripcion from statictext within w_ap719_reporte_semanal_x_embarcacion
end type
type sle_proveedor from singlelineedit within w_ap719_reporte_semanal_x_embarcacion
end type
type pb_1 from picturebutton within w_ap719_reporte_semanal_x_embarcacion
end type
type dw_report from u_dw_rpt within w_ap719_reporte_semanal_x_embarcacion
end type
type gb_1 from groupbox within w_ap719_reporte_semanal_x_embarcacion
end type
type gb_3 from groupbox within w_ap719_reporte_semanal_x_embarcacion
end type
type gb_2 from groupbox within w_ap719_reporte_semanal_x_embarcacion
end type
end forward

global type w_ap719_reporte_semanal_x_embarcacion from w_rpt
integer width = 4160
integer height = 3208
string title = "Reporte Semanal de Pesca por Embarcación  (AP719)"
string menuname = "m_rpt"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_query_retrieve ( )
sle_moneda sle_moneda
st_desc_moneda st_desc_moneda
dw_origen dw_origen
uo_fecha uo_fecha
sle_und sle_und
st_desc_und st_desc_und
mle_observacion mle_observacion
st_1 st_1
st_descripcion st_descripcion
sle_proveedor sle_proveedor
pb_1 pb_1
dw_report dw_report
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
end type
global w_ap719_reporte_semanal_x_embarcacion w_ap719_reporte_semanal_x_embarcacion

type variables
String  isa_cod_origen[]
end variables

forward prototypes
public function boolean of_verificar ()
end prototypes

event ue_query_retrieve();This.Event Dynamic ue_retrieve()
end event

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

boolean	lb_ok
String   ls_proveedor, lsa_array[]
Long	   ll_array, ll_i

lb_ok			  = True
ls_proveedor  = TRIM(sle_proveedor.Text)

IF IsNull(ls_proveedor) OR ls_proveedor = '' THEN
	messagebox('Aviso', 'Debe ingresar un codigo de proveedor')
	RETURN lb_ok = FALSE
END IF

IF sle_moneda.text = '' THEN
	messagebox('Aprovisionamiento', 'Por favor seleccione una moneda')
	RETURN lb_ok = False
END IF

IF sle_und.text = '' THEN
	messagebox('Aprovisionamiento', 'Por favor seleccione una unidad')
	return lb_ok = False
END IF

isa_cod_origen = lsa_array
ll_array = 1
// leer el dw_origen con los origenes seleccionados
For ll_i = 1 To dw_origen.RowCount()
	If dw_origen.Object.Chec[ll_i] = '1' Then
		isa_cod_origen [ll_array] = dw_origen.Object.cod_origen[ll_i]
		ll_array ++
	end if
Next

IF UpperBound(isa_cod_origen) = 0 THEN
	messagebox('Aprovisionamiento', 'Debe seleccionar al menos un origen para el Reporte')
	return lb_ok = False
END IF

RETURN lb_ok
end function

on w_ap719_reporte_semanal_x_embarcacion.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.sle_moneda=create sle_moneda
this.st_desc_moneda=create st_desc_moneda
this.dw_origen=create dw_origen
this.uo_fecha=create uo_fecha
this.sle_und=create sle_und
this.st_desc_und=create st_desc_und
this.mle_observacion=create mle_observacion
this.st_1=create st_1
this.st_descripcion=create st_descripcion
this.sle_proveedor=create sle_proveedor
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_moneda
this.Control[iCurrent+2]=this.st_desc_moneda
this.Control[iCurrent+3]=this.dw_origen
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.sle_und
this.Control[iCurrent+6]=this.st_desc_und
this.Control[iCurrent+7]=this.mle_observacion
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_descripcion
this.Control[iCurrent+10]=this.sle_proveedor
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.dw_report
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.gb_2
end on

on w_ap719_reporte_semanal_x_embarcacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_moneda)
destroy(this.st_desc_moneda)
destroy(this.dw_origen)
destroy(this.uo_fecha)
destroy(this.sle_und)
destroy(this.st_desc_und)
destroy(this.mle_observacion)
destroy(this.st_1)
destroy(this.st_descripcion)
destroy(this.sle_proveedor)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
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

event ue_retrieve;call super::ue_retrieve;string ls_proveedor, ls_observacion, ls_cod_und, ls_origen, ls_cod_moneda
date   ld_fecha_ini, ld_fecha_fin

IF NOT of_verificar() THEN RETURN

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))
ls_proveedor 	= TRIM(sle_proveedor.text)
ls_observacion = TRIM(mle_observacion.text)
ls_cod_moneda  = sle_moneda.text
ls_cod_und   	= sle_und.text

idw_1.SetRedraw(false)

// Obtengo el origen para el reporte 
SELECT NOMBRE
 INTO :ls_origen
FROM  ORIGEN
WHERE cod_origen = :gs_origen;

//Recupera los datos del reporte
idw_1.Retrieve(ls_proveedor, ld_fecha_ini, ld_fecha_fin, ls_cod_und, ls_cod_moneda, ls_origen, isa_cod_origen)

idw_1.object.usuario_t.text 		= gs_user
idw_1.object.p_logo.filename 		= gs_logo
idw_1.object.t_observacion.text	= ls_observacion
idw_1.object.peso_t.text			= 'Peso'+'~n~r'+'Venta' + '('+ls_cod_und+')'
idw_1.object.precio_t.text			= 'Precio'+'~n~r'+ ls_cod_moneda
idw_1.object.total_t.text			= 'Total en ' + ls_cod_und


// para printpreview
idw_1.Visible = True
idw_1.SetRedraw(true)


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.xls),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
 
end event

type sle_moneda from singlelineedit within w_ap719_reporte_semanal_x_embarcacion
event dobleclick pbm_lbuttondblclk
integer x = 1449
integer y = 52
integer width = 169
integer height = 76
integer taborder = 30
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

type st_desc_moneda from statictext within w_ap719_reporte_semanal_x_embarcacion
integer x = 1632
integer y = 52
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

type dw_origen from u_dw_abc within w_ap719_reporte_semanal_x_embarcacion
integer x = 2217
integer y = 36
integer width = 1001
integer height = 424
integer taborder = 50
string dataobject = "d_ap_origen_liq_pesca_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type uo_fecha from u_ingreso_rango_fechas within w_ap719_reporte_semanal_x_embarcacion
integer x = 55
integer y = 32
integer height = 96
integer taborder = 10
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(RelativeDate(today(),-7) , today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type sle_und from singlelineedit within w_ap719_reporte_semanal_x_embarcacion
event dobleclick pbm_lbuttondblclk
integer x = 1449
integer y = 200
integer width = 169
integer height = 76
integer taborder = 40
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

type st_desc_und from statictext within w_ap719_reporte_semanal_x_embarcacion
integer x = 1632
integer y = 200
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

type mle_observacion from multilineedit within w_ap719_reporte_semanal_x_embarcacion
integer x = 407
integer y = 312
integer width = 1760
integer height = 152
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ap719_reporte_semanal_x_embarcacion
integer x = 55
integer y = 332
integer width = 357
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Observación:"
boolean focusrectangle = false
end type

type st_descripcion from statictext within w_ap719_reporte_semanal_x_embarcacion
integer x = 320
integer y = 196
integer width = 1038
integer height = 76
integer textsize = -7
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

type sle_proveedor from singlelineedit within w_ap719_reporte_semanal_x_embarcacion
event dobleclick pbm_lbuttondblclk
integer x = 32
integer y = 200
integer width = 265
integer height = 76
integer taborder = 20
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
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT PROVEEDOR AS CODIGO, " 	&
				 + "NOM_PROVEEDOR AS NOMBRE " &
				 + "FROM PROVEEDOR " 			&
				 + "WHERE FLAG_ESTADO = '1' "

			  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
IF ls_codigo <> '' THEN
	This.text 			  = ls_codigo
	st_descripcion.text = ls_data
END IF

end event

event modified;String 	ls_proveedor, ls_desc

ls_proveedor = sle_proveedor.text

IF ls_proveedor = '' OR IsNull(ls_proveedor) THEN
	MessageBox('Aviso', 'Debe Ingresar un codigo de Proveedor')
	RETURN
END IF

SELECT  nom_proveedor
 INTO  :ls_desc
FROM proveedor
WHERE flag_estado = '1'
  AND proveedor = :ls_proveedor;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Proveedor no existe')
	st_descripcion.text = ''
	This.Text			  = ''
	RETURN
END IF

st_descripcion.text = ls_desc

end event

type pb_1 from picturebutton within w_ap719_reporte_semanal_x_embarcacion
integer x = 3255
integer y = 84
integer width = 306
integer height = 148
integer taborder = 70
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

type dw_report from u_dw_rpt within w_ap719_reporte_semanal_x_embarcacion
integer x = 37
integer y = 492
integer width = 3209
integer height = 1532
integer taborder = 80
string dataobject = "d_rpt_reporte_semanal_embarcacion_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ap719_reporte_semanal_x_embarcacion
integer x = 18
integer y = 148
integer width = 1371
integer height = 144
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Proveedor:"
end type

type gb_3 from groupbox within w_ap719_reporte_semanal_x_embarcacion
integer x = 1417
integer y = 144
integer width = 786
integer height = 148
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Unidad"
end type

type gb_2 from groupbox within w_ap719_reporte_semanal_x_embarcacion
integer x = 1417
integer width = 786
integer height = 148
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Moneda"
end type

