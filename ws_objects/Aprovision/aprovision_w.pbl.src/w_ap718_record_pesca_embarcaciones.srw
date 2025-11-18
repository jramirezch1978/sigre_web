$PBExportHeader$w_ap718_record_pesca_embarcaciones.srw
$PBExportComments$Record de pesca de embarcaciones
forward
global type w_ap718_record_pesca_embarcaciones from w_rpt
end type
type rb_cap_bod_3 from radiobutton within w_ap718_record_pesca_embarcaciones
end type
type rb_cap_bod_2 from radiobutton within w_ap718_record_pesca_embarcaciones
end type
type rb_cap_bod_1 from radiobutton within w_ap718_record_pesca_embarcaciones
end type
type rb_1 from radiobutton within w_ap718_record_pesca_embarcaciones
end type
type rb_2 from radiobutton within w_ap718_record_pesca_embarcaciones
end type
type rb_3 from radiobutton within w_ap718_record_pesca_embarcaciones
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_ap718_record_pesca_embarcaciones
end type
type dw_origen from u_dw_abc within w_ap718_record_pesca_embarcaciones
end type
type pb_1 from picturebutton within w_ap718_record_pesca_embarcaciones
end type
type dw_report from u_dw_rpt within w_ap718_record_pesca_embarcaciones
end type
type gb_1 from groupbox within w_ap718_record_pesca_embarcaciones
end type
type gb_2 from groupbox within w_ap718_record_pesca_embarcaciones
end type
end forward

global type w_ap718_record_pesca_embarcaciones from w_rpt
integer width = 4050
integer height = 2668
string title = "Record de Pesca Por Embarcacion   (AP718)"
string menuname = "m_rpt"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_query_retrieve ( )
rb_cap_bod_3 rb_cap_bod_3
rb_cap_bod_2 rb_cap_bod_2
rb_cap_bod_1 rb_cap_bod_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
uo_fecha uo_fecha
dw_origen dw_origen
pb_1 pb_1
dw_report dw_report
gb_1 gb_1
gb_2 gb_2
end type
global w_ap718_record_pesca_embarcaciones w_ap718_record_pesca_embarcaciones

type variables
string is_cod_origen
end variables

forward prototypes
public function boolean of_verificar ()
end prototypes

event ue_query_retrieve();This.event Dynamic ue_retrieve()
end event

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

long 		ll_i
String 	ls_separador
boolean	lb_ok

is_cod_origen = ''
ls_separador  = ''
lb_ok			  = True


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

on w_ap718_record_pesca_embarcaciones.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.rb_cap_bod_3=create rb_cap_bod_3
this.rb_cap_bod_2=create rb_cap_bod_2
this.rb_cap_bod_1=create rb_cap_bod_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.uo_fecha=create uo_fecha
this.dw_origen=create dw_origen
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_cap_bod_3
this.Control[iCurrent+2]=this.rb_cap_bod_2
this.Control[iCurrent+3]=this.rb_cap_bod_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.uo_fecha
this.Control[iCurrent+8]=this.dw_origen
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.dw_report
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_ap718_record_pesca_embarcaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_cap_bod_3)
destroy(this.rb_cap_bod_2)
destroy(this.rb_cap_bod_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.uo_fecha)
destroy(this.dw_origen)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_1)
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

event ue_retrieve;call super::ue_retrieve;string ls_rango_fecha, ls_tipo_flota
date   ld_fecha_ini, ld_fecha_fin


IF NOT of_verificar() THEN RETURN

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))

idw_1.SetRedraw(false)

//Recupera los datos del reporte

IF rb_1.Checked THEN     					//Flota Propia
	ls_tipo_flota = 'P'
ELSEIF rb_2.Checked THEN
	ls_tipo_flota = 'T'						//Flota Terceros
ELSE
	ls_tipo_flota = '%%'
END IF


idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin, is_cod_origen, ls_tipo_flota)

idw_1.GroupCalc()

ls_rango_fecha = 'Del ' + string(ld_fecha_ini) + ' Al ' + string (ld_fecha_fin)

idw_1.object.usuario_t.text 		= gs_user
idw_1.object.p_logo.filename 		= gs_logo
idw_1.object.rango_1.text			= ls_rango_fecha


// Filtra la data de acuerdo a la capacidad de bodega seleccionada
IF rb_cap_bod_1.checked THEN
	rb_cap_bod_1.TriggerEvent(Clicked!)
ELSEIF rb_cap_bod_2.checked THEN
	rb_cap_bod_2.TriggerEvent(Clicked!)
ELSE
	rb_cap_bod_3.TriggerEvent(Clicked!)
END IF

// para printpreview
idw_1.Visible = True
idw_1.SetRedraw(true)

end event

type rb_cap_bod_3 from radiobutton within w_ap718_record_pesca_embarcaciones
integer x = 2327
integer y = 188
integer width = 375
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "cb > 110 TN"
end type

event clicked;String ls_filtro

ls_filtro = ""
dw_report.setfilter( ls_filtro )
dw_report.Filter( )

ls_filtro = "capac_bodega > 110"
dw_report.setfilter( ls_filtro )
dw_report.Filter( )
	
end event

type rb_cap_bod_2 from radiobutton within w_ap718_record_pesca_embarcaciones
integer x = 2327
integer y = 136
integer width = 389
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "cb <= 110 TN"
end type

event clicked;String ls_filtro

ls_filtro = ""
dw_report.setfilter( ls_filtro )
dw_report.Filter( )

ls_filtro = "capac_bodega > 50 and capac_bodega <= 110"
dw_report.setfilter( ls_filtro )
dw_report.Filter( )
	

end event

type rb_cap_bod_1 from radiobutton within w_ap718_record_pesca_embarcaciones
integer x = 2327
integer y = 84
integer width = 393
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "cb <= 50 TN"
boolean checked = true
end type

event clicked;String ls_filtro

ls_filtro = ""
dw_report.setfilter( ls_filtro )
dw_report.Filter( )

ls_filtro = "capac_bodega <= 50"
dw_report.setfilter( ls_filtro )
dw_report.Filter( )
	
end event

type rb_1 from radiobutton within w_ap718_record_pesca_embarcaciones
integer x = 768
integer y = 84
integer width = 320
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Propia"
boolean checked = true
end type

type rb_2 from radiobutton within w_ap718_record_pesca_embarcaciones
integer x = 768
integer y = 136
integer width = 366
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Terceros"
end type

type rb_3 from radiobutton within w_ap718_record_pesca_embarcaciones
integer x = 768
integer y = 188
integer width = 279
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ambas"
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_ap718_record_pesca_embarcaciones
event destroy ( )
integer x = 55
integer y = 60
integer taborder = 30
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(RelativeDate(today(),-31) , today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas


end event

type dw_origen from u_dw_abc within w_ap718_record_pesca_embarcaciones
integer x = 1207
integer y = 36
integer width = 1001
integer height = 260
integer taborder = 50
string dataobject = "d_ap_origen_liq_pesca_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type pb_1 from picturebutton within w_ap718_record_pesca_embarcaciones
integer x = 2816
integer y = 72
integer width = 306
integer height = 148
integer taborder = 60
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

type dw_report from u_dw_rpt within w_ap718_record_pesca_embarcaciones
integer x = 46
integer y = 328
integer width = 2565
integer height = 1648
integer taborder = 70
string dataobject = "d_ap_record_pesca_embarcacion_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ap718_record_pesca_embarcaciones
integer x = 731
integer y = 36
integer width = 421
integer height = 228
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Flota"
end type

type gb_2 from groupbox within w_ap718_record_pesca_embarcaciones
integer x = 2299
integer y = 36
integer width = 443
integer height = 228
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cap_Bod"
end type

