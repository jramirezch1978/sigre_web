$PBExportHeader$w_ve713_mov_x_facturar.srw
forward
global type w_ve713_mov_x_facturar from w_rpt_list
end type
type gb_fechas from groupbox within w_ve713_mov_x_facturar
end type
type uo_1 from u_ingreso_rango_fechas_v within w_ve713_mov_x_facturar
end type
type rb_detalle from radiobutton within w_ve713_mov_x_facturar
end type
type rb_resumen from radiobutton within w_ve713_mov_x_facturar
end type
type cb_3 from commandbutton within w_ve713_mov_x_facturar
end type
type st_1 from statictext within w_ve713_mov_x_facturar
end type
type st_2 from statictext within w_ve713_mov_x_facturar
end type
type sle_almacen from singlelineedit within w_ve713_mov_x_facturar
end type
type sle_descrip from singlelineedit within w_ve713_mov_x_facturar
end type
type sle_ope from singlelineedit within w_ve713_mov_x_facturar
end type
type sle_descrip_ope from singlelineedit within w_ve713_mov_x_facturar
end type
type gb_tipo_reporte from groupbox within w_ve713_mov_x_facturar
end type
type gb_1 from groupbox within w_ve713_mov_x_facturar
end type
end forward

global type w_ve713_mov_x_facturar from w_rpt_list
integer width = 3552
integer height = 2000
string title = "(VE713] Movimientos a facturar "
string menuname = "m_reporte"
windowstate windowstate = maximized!
gb_fechas gb_fechas
uo_1 uo_1
rb_detalle rb_detalle
rb_resumen rb_resumen
cb_3 cb_3
st_1 st_1
st_2 st_2
sle_almacen sle_almacen
sle_descrip sle_descrip
sle_ope sle_ope
sle_descrip_ope sle_descrip_ope
gb_tipo_reporte gb_tipo_reporte
gb_1 gb_1
end type
global w_ve713_mov_x_facturar w_ve713_mov_x_facturar

type variables
String is_ope_vta
Integer ii_operacion
end variables

on w_ve713_mov_x_facturar.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.gb_fechas=create gb_fechas
this.uo_1=create uo_1
this.rb_detalle=create rb_detalle
this.rb_resumen=create rb_resumen
this.cb_3=create cb_3
this.st_1=create st_1
this.st_2=create st_2
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.sle_ope=create sle_ope
this.sle_descrip_ope=create sle_descrip_ope
this.gb_tipo_reporte=create gb_tipo_reporte
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.rb_detalle
this.Control[iCurrent+4]=this.rb_resumen
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.sle_almacen
this.Control[iCurrent+9]=this.sle_descrip
this.Control[iCurrent+10]=this.sle_ope
this.Control[iCurrent+11]=this.sle_descrip_ope
this.Control[iCurrent+12]=this.gb_tipo_reporte
this.Control[iCurrent+13]=this.gb_1
end on

on w_ve713_mov_x_facturar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.uo_1)
destroy(this.rb_detalle)
destroy(this.rb_resumen)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.sle_ope)
destroy(this.sle_descrip_ope)
destroy(this.gb_tipo_reporte)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_retrieve;Date ld_fec_ini, ld_fec_fin
string ls_operacion, ls_alm, ls_acod[]
Long ll_row

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

ls_operacion = sle_ope.text
ls_alm = sle_almacen.text

// Valida el tipo de formato
if rb_detalle.checked = false and rb_resumen.checked = false then
	Messagebox( "Aviso", "Indique tipo de reporte")
	return
end if

// Llena datos de dw seleccionados a tabla temporal	
FOR ll_row = 1 to dw_2.rowcount()
	ls_acod[ll_row] = dw_2.object.proveedor[ll_row]
NEXT	

dw_report.SetTransObject( sqlca)
dw_report.retrieve(ld_fec_ini, ld_fec_fin, ls_alm, ls_operacion, ls_acod )
dw_report.object.t_user.text = gs_user
dw_report.object.t_tit1.text = "En Nuevos Soles  del: " + &
    String( ld_fec_ini, 'dd/mm/yyyy') + ' AL ' + &
	 String( ld_fec_fin, 'dd/mm/yyyy') 
dw_report.object.t_tit2.text = "Operacion: " + sle_descrip_ope.text
dw_report.object.t_tit3.text = sle_almacen.text + " : "+ sle_descrip.text
dw_report.Object.p_logo.filename = gs_logo

dw_1.visible = false
dw_2.visible = false
this.Event ue_preview()
dw_report.visible = true

end event

type dw_report from w_rpt_list`dw_report within w_ve713_mov_x_facturar
boolean visible = false
integer x = 23
integer y = 312
integer width = 3319
integer height = 1960
end type

type dw_1 from w_rpt_list`dw_1 within w_ve713_mov_x_facturar
integer x = 32
integer y = 400
integer width = 1522
integer height = 1308
integer taborder = 50
string dataobject = "d_sel_mov_almacen_x_codrel"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;
ii_ck[1] = 1 
ii_ck[2] = 2
ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
end event

event dw_1::ue_selected_row_pro;//Override
Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)
end event

type pb_1 from w_rpt_list`pb_1 within w_ve713_mov_x_facturar
integer x = 1627
integer y = 724
integer taborder = 70
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type pb_2 from w_rpt_list`pb_2 within w_ve713_mov_x_facturar
integer x = 1627
integer y = 1248
integer taborder = 100
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_ve713_mov_x_facturar
integer x = 1870
integer y = 400
integer width = 1605
integer height = 1308
integer taborder = 90
string dataobject = "d_sel_mov_almacen_x_codrel"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
end event

event dw_2::ue_selected_row_pro;//Override
Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)
end event

type cb_report from w_rpt_list`cb_report within w_ve713_mov_x_facturar
integer x = 3017
integer y = 188
integer width = 457
integer height = 92
integer taborder = 40
integer weight = 700
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;parent.event ue_retrieve()
end event

type gb_fechas from groupbox within w_ve713_mov_x_facturar
integer x = 46
integer y = 4
integer width = 667
integer height = 300
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
end type

type uo_1 from u_ingreso_rango_fechas_v within w_ve713_mov_x_facturar
integer x = 73
integer y = 72
integer taborder = 20
boolean bringtotop = true
long backcolor = 12632256
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas_v::destroy
end on

type rb_detalle from radiobutton within w_ve713_mov_x_facturar
integer x = 763
integer y = 108
integer width = 370
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Detalle"
boolean lefttext = true
end type

event clicked;dw_report.dataobject = 'd_rpt_mov_a_facturar'


end event

type rb_resumen from radiobutton within w_ve713_mov_x_facturar
integer x = 763
integer y = 184
integer width = 370
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Resumen"
boolean lefttext = true
end type

event clicked;dw_report.dataobject = 'd_rpt_mov_a_facturar_res'

end event

type cb_3 from commandbutton within w_ve713_mov_x_facturar
integer x = 3017
integer y = 60
integer width = 457
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Mostrar"
end type

event clicked;Date ld_desde, ld_hasta
String ls_tipo_mov, ls_alm, ls_operacion

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

SetPointer( HourGlass!)
if sle_almacen.text = "" then 
	Messagebox( "Aviso", "Debe indicar tipo de operacion")
	return 0
end if
if sle_ope.text = "" then 
	Messagebox( "Aviso", "Debe indicar almacen")
	return 0
end if
ls_alm = sle_almacen.text
ls_operacion = sle_ope.text

dw_1.SetTransObject(sqlca)

dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	
dw_1.reset()
dw_2.reset()

dw_1.retrieve(ld_desde, ld_hasta, ls_alm, ls_operacion)

return 1
end event

type st_1 from statictext within w_ve713_mov_x_facturar
integer x = 1216
integer y = 192
integer width = 311
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Operacion:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ve713_mov_x_facturar
integer x = 1253
integer y = 96
integer width = 274
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Almacen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_almacen from singlelineedit within w_ve713_mov_x_facturar
event dobleclick pbm_lbuttondblclk
integer x = 1559
integer y = 80
integer width = 224
integer height = 88
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
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen where flag_estado = '1' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
	sle_ope.enabled = true
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

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_ve713_mov_x_facturar
integer x = 1787
integer y = 80
integer width = 1157
integer height = 88
integer taborder = 40
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

type sle_ope from singlelineedit within w_ve713_mov_x_facturar
event dobleclick pbm_lbuttondblclk
integer x = 1559
integer y = 180
integer width = 224
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
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select atm.tipo_mov AS CODIGO, amt.desc_tipo_mov AS DESCRIPCION " & 
			+ "from almacen_tipo_mov atm, articulo_mov_tipo amt " &
			+ "where atm.tipo_mov = amt.tipo_mov and " &
			+ "atm.almacen = '" + sle_almacen.text +"'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip_ope.text 	= ls_data
	cb_3.enabled = true
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

sle_descrip.text = ls_desc

end event

type sle_descrip_ope from singlelineedit within w_ve713_mov_x_facturar
integer x = 1787
integer y = 180
integer width = 1157
integer height = 88
integer taborder = 40
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

type gb_tipo_reporte from groupbox within w_ve713_mov_x_facturar
integer x = 722
integer y = 8
integer width = 453
integer height = 300
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
end type

type gb_1 from groupbox within w_ve713_mov_x_facturar
integer x = 1193
integer y = 8
integer width = 1774
integer height = 300
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
end type

