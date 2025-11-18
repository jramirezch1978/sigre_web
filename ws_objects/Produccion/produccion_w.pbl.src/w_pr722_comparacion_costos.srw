$PBExportHeader$w_pr722_comparacion_costos.srw
forward
global type w_pr722_comparacion_costos from w_rpt
end type
type sle_desc_almacen from singlelineedit within w_pr722_comparacion_costos
end type
type sle_almacen from singlelineedit within w_pr722_comparacion_costos
end type
type st_2 from statictext within w_pr722_comparacion_costos
end type
type st_1 from statictext within w_pr722_comparacion_costos
end type
type sle_desc_art from singlelineedit within w_pr722_comparacion_costos
end type
type sle_cod_art from singlelineedit within w_pr722_comparacion_costos
end type
type cb_2 from commandbutton within w_pr722_comparacion_costos
end type
type st_3 from statictext within w_pr722_comparacion_costos
end type
type uo_fecha from u_ingreso_rango_fechas within w_pr722_comparacion_costos
end type
type dw_report from u_dw_rpt within w_pr722_comparacion_costos
end type
type gb_4 from groupbox within w_pr722_comparacion_costos
end type
end forward

global type w_pr722_comparacion_costos from w_rpt
integer width = 3858
integer height = 2892
string title = "Comparación de Costos - Gráfico (PR722)"
string menuname = "m_reporte"
long backcolor = 67108864
sle_desc_almacen sle_desc_almacen
sle_almacen sle_almacen
st_2 st_2
st_1 st_1
sle_desc_art sle_desc_art
sle_cod_art sle_cod_art
cb_2 cb_2
st_3 st_3
uo_fecha uo_fecha
dw_report dw_report
gb_4 gb_4
end type
global w_pr722_comparacion_costos w_pr722_comparacion_costos

on w_pr722_comparacion_costos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_desc_almacen=create sle_desc_almacen
this.sle_almacen=create sle_almacen
this.st_2=create st_2
this.st_1=create st_1
this.sle_desc_art=create sle_desc_art
this.sle_cod_art=create sle_cod_art
this.cb_2=create cb_2
this.st_3=create st_3
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_desc_almacen
this.Control[iCurrent+2]=this.sle_almacen
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_desc_art
this.Control[iCurrent+6]=this.sle_cod_art
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.uo_fecha
this.Control[iCurrent+10]=this.dw_report
this.Control[iCurrent+11]=this.gb_4
end on

on w_pr722_comparacion_costos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_desc_almacen)
destroy(this.sle_almacen)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_desc_art)
destroy(this.sle_cod_art)
destroy(this.cb_2)
destroy(this.st_3)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.gb_4)
end on

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;date 		ld_fecha1, ld_fecha2
string	ls_almacen, ls_cod_art
Decimal	ldc_cambio

ld_fecha1 	 = uo_fecha.of_get_fecha1( )
ld_fecha2	 = uo_fecha.of_get_fecha2( )
ls_cod_art	 = sle_cod_art.text
ls_almacen	 = sle_almacen.text

ib_preview = false
event ue_preview()
idw_1.ii_zoom_actual = 100
idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))

idw_1.Retrieve(ls_cod_art, ls_almacen, ld_fecha1, ld_fecha2)
idw_1.Visible = True
idw_1.Object.p_logo.filename 		= gs_logo
idw_1.Object.t_empresa.text		= gs_empresa
idw_1.object.Datawindow.Print.Orientation = 2


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

type sle_desc_almacen from singlelineedit within w_pr722_comparacion_costos
integer x = 672
integer y = 100
integer width = 1211
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_almacen from singlelineedit within w_pr722_comparacion_costos
event dobleclick pbm_lbuttondblclk
integer x = 347
integer y = 100
integer width = 315
integer height = 88
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
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT DISTINCT a.almacen AS CODIGO_almacen, " &
	  	 + "a.DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen a, " &
		 + "prod_costos_diarios b " &
		 + "WHERE a.almacen = b.almacen " &
		 + "AND a.flag_estado = '1' " &
		 + "ORDER BY a.almacen "
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 				   = ls_codigo
	sle_desc_almacen.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_desc_almacen.text = ls_desc

end event

type st_2 from statictext within w_pr722_comparacion_costos
integer x = 78
integer y = 216
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Artículo"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pr722_comparacion_costos
integer x = 82
integer y = 116
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Almacén"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_desc_art from singlelineedit within w_pr722_comparacion_costos
integer x = 672
integer y = 200
integer width = 1211
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_cod_art from singlelineedit within w_pr722_comparacion_costos
event dobleclick pbm_lbuttondblclk
integer x = 347
integer y = 200
integer width = 315
integer height = 88
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
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_almacen

ls_almacen = sle_almacen.text

if ls_almacen = '' then
	MessageBox('AViso', 'Debe indicar un almacen primero')
	return
end if

ls_sql = "SELECT DISTINCT a.cod_art AS CODIGO_articulo, " &
	  	 + "a.DESC_art AS DESCRIPCION_articulo " &
	    + "FROM articulo a, " &
		 + "prod_costos_diarios b " &
		 + "WHERE a.cod_art = b.cod_art " &
		 + "AND a.flag_estado = '1' " &
		 + "AND b.almacen = '" + ls_almacen + "' " &
		 + "ORDER BY a.cod_art "
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_desc_art.text 	= ls_data
end if

end event

event modified;String 	ls_cod_art, ls_desc

ls_cod_art = sle_almacen.text
if ls_cod_art = '' or IsNull(ls_cod_art) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de artículo')
	return
end if

SELECT desc_art 
	INTO :ls_desc
FROM articulo 
where cod_art = :ls_cod_art ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Artículo no existe')
	return
end if

sle_desc_art.text = ls_desc
Parent.event dynamic ue_seleccionar()


end event

type cb_2 from commandbutton within w_pr722_comparacion_costos
integer x = 2455
integer y = 76
integer width = 462
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type st_3 from statictext within w_pr722_comparacion_costos
integer x = 82
integer y = 288
integer width = 256
integer height = 108
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Rango de Fechas"
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas within w_pr722_comparacion_costos
integer x = 343
integer y = 296
integer taborder = 20
end type

event constructor;call super::constructor; of_set_label('Del:','Al:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 
 of_get_fecha1()
 of_get_fecha2()
 



end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_pr722_comparacion_costos
integer x = 14
integer y = 432
integer width = 3598
integer height = 1180
string dataobject = "d_rpt_costo_prod_cntbl_cmp"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_4 from groupbox within w_pr722_comparacion_costos
integer x = 27
integer y = 20
integer width = 3095
integer height = 392
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Parámetros "
end type

