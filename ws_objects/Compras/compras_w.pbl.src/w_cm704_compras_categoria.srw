$PBExportHeader$w_cm704_compras_categoria.srw
forward
global type w_cm704_compras_categoria from w_rpt_list
end type
type gb_fechas from groupbox within w_cm704_compras_categoria
end type
type uo_1 from u_ingreso_rango_fechas_v within w_cm704_compras_categoria
end type
type rb_categoria from radiobutton within w_cm704_compras_categoria
end type
type rb_subcategoria from radiobutton within w_cm704_compras_categoria
end type
type rb_articulo from radiobutton within w_cm704_compras_categoria
end type
type cb_3 from commandbutton within w_cm704_compras_categoria
end type
type rb_1 from radiobutton within w_cm704_compras_categoria
end type
type gb_tipo_reporte from groupbox within w_cm704_compras_categoria
end type
end forward

global type w_cm704_compras_categoria from w_rpt_list
integer width = 3415
integer height = 2000
string title = "Compras por Categorías / Sub Categorías / Artículos [CM704]"
string menuname = "m_impresion"
gb_fechas gb_fechas
uo_1 uo_1
rb_categoria rb_categoria
rb_subcategoria rb_subcategoria
rb_articulo rb_articulo
cb_3 cb_3
rb_1 rb_1
gb_tipo_reporte gb_tipo_reporte
end type
global w_cm704_compras_categoria w_cm704_compras_categoria

on w_cm704_compras_categoria.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.uo_1=create uo_1
this.rb_categoria=create rb_categoria
this.rb_subcategoria=create rb_subcategoria
this.rb_articulo=create rb_articulo
this.cb_3=create cb_3
this.rb_1=create rb_1
this.gb_tipo_reporte=create gb_tipo_reporte
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.rb_categoria
this.Control[iCurrent+4]=this.rb_subcategoria
this.Control[iCurrent+5]=this.rb_articulo
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.gb_tipo_reporte
end on

on w_cm704_compras_categoria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.uo_1)
destroy(this.rb_categoria)
destroy(this.rb_subcategoria)
destroy(this.rb_articulo)
destroy(this.cb_3)
destroy(this.rb_1)
destroy(this.gb_tipo_reporte)
end on

event ue_open_pre();call super::ue_open_pre;idw_1.Visible = False


end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_retrieve;call super::ue_retrieve;Date 		ld_desde, ld_hasta
Long 		ll_row
String 	ls_cod, ls_mensaje

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

dw_1.visible = false
dw_2.visible = false
this.Event ue_preview()		
dw_report.visible = true

SetPointer( Hourglass!)

if dw_2.rowcount() = 0 then return

// Llena datos de dw seleccionados a tabla temporal
delete from tt_articulos_cmp;
commit;

FOR ll_row = 1 to dw_2.rowcount()
	ls_cod = dw_2.object.codigo[ll_row]		
	Insert into tt_articulos_cmp(codigo) values (:ls_cod);
NEXT	
commit;

dw_report.retrieve(ld_desde, ld_hasta)

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_codigo.text   = dw_report.dataobject
dw_report.object.t_fechas.text = "Del: " + STRING(LD_DESDE, "DD/MM/YYYY") &
		+ " AL " + STRING(LD_HASTA, "DD/MM/YYYY")


end event

type dw_report from w_rpt_list`dw_report within w_cm704_compras_categoria
boolean visible = false
integer x = 23
integer y = 364
integer width = 3319
integer height = 1908
end type

type dw_1 from w_rpt_list`dw_1 within w_cm704_compras_categoria
integer x = 32
integer y = 400
integer width = 1522
integer height = 1308
integer taborder = 50
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;
ii_ck[1] = 1 



end event

event dw_1::ue_selected_row_pro;// Ancestor Script has been Override
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

type pb_1 from w_rpt_list`pb_1 within w_cm704_compras_categoria
integer x = 1627
integer y = 724
integer taborder = 70
end type

event pb_1::clicked;call super::clicked;IF dw_2.RowCount() > 0 then
	cb_report.enabled = TRUE
END IF
end event

type pb_2 from w_rpt_list`pb_2 within w_cm704_compras_categoria
integer x = 1627
integer y = 1248
integer taborder = 100
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;IF dw_2.RowCount() = 0 then
	cb_report.enabled = false
END IF
end event

type dw_2 from w_rpt_list`dw_2 within w_cm704_compras_categoria
integer x = 1847
integer y = 400
integer width = 1522
integer height = 1308
integer taborder = 90
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1



end event

event dw_2::ue_selected_row_pro;// Ancestor Script has been Override
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

type cb_report from w_rpt_list`cb_report within w_cm704_compras_categoria
integer x = 2386
integer y = 176
integer width = 581
integer height = 92
integer taborder = 40
integer weight = 700
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;parent.event ue_retrieve()
end event

type gb_fechas from groupbox within w_cm704_compras_categoria
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

type uo_1 from u_ingreso_rango_fechas_v within w_cm704_compras_categoria
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

type rb_categoria from radiobutton within w_cm704_compras_categoria
integer x = 887
integer y = 60
integer width = 722
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Por Categorías"
boolean lefttext = true
end type

event clicked;Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

dw_report.visible = false	
dw_1.visible = true
dw_2.visible = true
	
dw_1.reset()
dw_2.reset()

SetPointer( Hourglass!)


dw_1.DataObject= 'd_sel_categ_compras'
dw_2.DataObject= 'd_sel_categ_compras'
dw_report.dataobject = 'd_rpt_compras_categorias'
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_report.SetTransObject( sqlca)

dw_1.retrieve(ld_desde, ld_hasta)

SetPointer( Arrow!)
end event

type rb_subcategoria from radiobutton within w_cm704_compras_categoria
integer x = 887
integer y = 128
integer width = 722
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Por Sub Categorías"
boolean lefttext = true
end type

event clicked;Date 		ld_desde, ld_hasta
string 	ls_mensaje

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	
dw_1.reset()
dw_2.reset()

Setpointer( HourGlass!)

dw_1.DataObject= 'd_sel_subcateg_compras'
dw_2.DataObject= 'd_sel_subcateg_compras'
dw_report.dataobject = 'd_rpt_compras_sub_categorias'
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_report.SetTransObject( sqlca)

dw_1.retrieve(ld_desde, ld_hasta)

Setpointer( Arrow!)
end event

type rb_articulo from radiobutton within w_cm704_compras_categoria
integer x = 887
integer y = 196
integer width = 722
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Por Artículo"
boolean lefttext = true
end type

event clicked;Date 		ld_desde, ld_hasta
string 	ls_mensaje

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	
dw_1.reset()
dw_2.reset()

Setpointer( HourGlass!)

dw_1.DataObject= 'd_sel_articulo_compras'
dw_2.DataObject= 'd_sel_articulo_compras'
dw_report.dataobject = 'd_rpt_compras_articulo'
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_report.SetTransObject( sqlca)

dw_1.retrieve(ld_desde, ld_hasta)

Setpointer( Arrow!)
end event

type cb_3 from commandbutton within w_cm704_compras_categoria
integer x = 2386
integer y = 24
integer width = 581
integer height = 104
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Carga datos"
end type

event clicked;Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

dw_report.visible = false
cb_report.enabled = false
dw_report.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_1.retrieve(ld_desde, ld_hasta)

end event

type rb_1 from radiobutton within w_cm704_compras_categoria
integer x = 887
integer y = 264
integer width = 722
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Por SubCateg/Proveedor"
boolean lefttext = true
end type

event clicked;Date 		ld_desde, ld_hasta
string 	ls_mensaje

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	
dw_1.reset()
dw_2.reset()

Setpointer( HourGlass!)

dw_1.DataObject= 'd_sel_subcateg_compras'
dw_2.DataObject= 'd_sel_subcateg_compras'
dw_report.dataobject = 'd_rpt_compras_subcat_proveedor'
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_report.SetTransObject( sqlca)

dw_1.retrieve(ld_desde, ld_hasta)

Setpointer( Arrow!)
end event

type gb_tipo_reporte from groupbox within w_cm704_compras_categoria
integer x = 855
integer y = 4
integer width = 795
integer height = 344
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

