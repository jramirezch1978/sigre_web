$PBExportHeader$w_ve768_detalle_ov.srw
forward
global type w_ve768_detalle_ov from w_rpt
end type
type sle_desc_art from singlelineedit within w_ve768_detalle_ov
end type
type cb_articulo from commandbutton within w_ve768_detalle_ov
end type
type sle_cod_art from singlelineedit within w_ve768_detalle_ov
end type
type cbx_articulos from checkbox within w_ve768_detalle_ov
end type
type cbx_sub_categ from checkbox within w_ve768_detalle_ov
end type
type sle_cod_sub_cat from singlelineedit within w_ve768_detalle_ov
end type
type cb_subcateg from commandbutton within w_ve768_detalle_ov
end type
type sle_desc_sub_cat from singlelineedit within w_ve768_detalle_ov
end type
type sle_desc_categoria from singlelineedit within w_ve768_detalle_ov
end type
type cb_categoria from commandbutton within w_ve768_detalle_ov
end type
type sle_categoria from singlelineedit within w_ve768_detalle_ov
end type
type cbx_categorias from checkbox within w_ve768_detalle_ov
end type
type sle_razon_social from singlelineedit within w_ve768_detalle_ov
end type
type cb_1 from commandbutton within w_ve768_detalle_ov
end type
type sle_cliente from singlelineedit within w_ve768_detalle_ov
end type
type cb_3 from commandbutton within w_ve768_detalle_ov
end type
type cbx_clientes from checkbox within w_ve768_detalle_ov
end type
type dw_report from u_dw_rpt within w_ve768_detalle_ov
end type
type uo_fechas from u_ingreso_rango_fechas within w_ve768_detalle_ov
end type
type gb_1 from groupbox within w_ve768_detalle_ov
end type
end forward

global type w_ve768_detalle_ov from w_rpt
integer width = 3799
integer height = 2404
string title = "[VE768] Orden de venta detallado"
string menuname = "m_reporte"
sle_desc_art sle_desc_art
cb_articulo cb_articulo
sle_cod_art sle_cod_art
cbx_articulos cbx_articulos
cbx_sub_categ cbx_sub_categ
sle_cod_sub_cat sle_cod_sub_cat
cb_subcateg cb_subcateg
sle_desc_sub_cat sle_desc_sub_cat
sle_desc_categoria sle_desc_categoria
cb_categoria cb_categoria
sle_categoria sle_categoria
cbx_categorias cbx_categorias
sle_razon_social sle_razon_social
cb_1 cb_1
sle_cliente sle_cliente
cb_3 cb_3
cbx_clientes cbx_clientes
dw_report dw_report
uo_fechas uo_fechas
gb_1 gb_1
end type
global w_ve768_detalle_ov w_ve768_detalle_ov

on w_ve768_detalle_ov.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_desc_art=create sle_desc_art
this.cb_articulo=create cb_articulo
this.sle_cod_art=create sle_cod_art
this.cbx_articulos=create cbx_articulos
this.cbx_sub_categ=create cbx_sub_categ
this.sle_cod_sub_cat=create sle_cod_sub_cat
this.cb_subcateg=create cb_subcateg
this.sle_desc_sub_cat=create sle_desc_sub_cat
this.sle_desc_categoria=create sle_desc_categoria
this.cb_categoria=create cb_categoria
this.sle_categoria=create sle_categoria
this.cbx_categorias=create cbx_categorias
this.sle_razon_social=create sle_razon_social
this.cb_1=create cb_1
this.sle_cliente=create sle_cliente
this.cb_3=create cb_3
this.cbx_clientes=create cbx_clientes
this.dw_report=create dw_report
this.uo_fechas=create uo_fechas
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_desc_art
this.Control[iCurrent+2]=this.cb_articulo
this.Control[iCurrent+3]=this.sle_cod_art
this.Control[iCurrent+4]=this.cbx_articulos
this.Control[iCurrent+5]=this.cbx_sub_categ
this.Control[iCurrent+6]=this.sle_cod_sub_cat
this.Control[iCurrent+7]=this.cb_subcateg
this.Control[iCurrent+8]=this.sle_desc_sub_cat
this.Control[iCurrent+9]=this.sle_desc_categoria
this.Control[iCurrent+10]=this.cb_categoria
this.Control[iCurrent+11]=this.sle_categoria
this.Control[iCurrent+12]=this.cbx_categorias
this.Control[iCurrent+13]=this.sle_razon_social
this.Control[iCurrent+14]=this.cb_1
this.Control[iCurrent+15]=this.sle_cliente
this.Control[iCurrent+16]=this.cb_3
this.Control[iCurrent+17]=this.cbx_clientes
this.Control[iCurrent+18]=this.dw_report
this.Control[iCurrent+19]=this.uo_fechas
this.Control[iCurrent+20]=this.gb_1
end on

on w_ve768_detalle_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_desc_art)
destroy(this.cb_articulo)
destroy(this.sle_cod_art)
destroy(this.cbx_articulos)
destroy(this.cbx_sub_categ)
destroy(this.sle_cod_sub_cat)
destroy(this.cb_subcateg)
destroy(this.sle_desc_sub_cat)
destroy(this.sle_desc_categoria)
destroy(this.cb_categoria)
destroy(this.sle_categoria)
destroy(this.cbx_categorias)
destroy(this.sle_razon_social)
destroy(this.cb_1)
destroy(this.sle_cliente)
destroy(this.cb_3)
destroy(this.cbx_clientes)
destroy(this.dw_report)
destroy(this.uo_fechas)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;

idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)



//datos de reporte
ib_preview = true
This.Event ue_preview()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user



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

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_fecha2
string 	ls_cliente, ls_categorias, ls_sub_categ, ls_cod_art

//gnvo_app.almacen.of_actualiza_saldos()

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()

if cbx_clientes.checked then
	ls_cliente = '%%'
else
	if trim(sle_cliente.text) = '' then
		gnvo_app.of_mensaje_error("Debe seleccionar una CLIENTE")
		sle_cliente.setFocus()
		return
	end if
	
	ls_cliente = trim(sle_cliente.text) + '%'
end if

if cbx_categorias.checked then
	ls_categorias = '%%'
else
	if trim(sle_categoria.text) = '' then
		gnvo_app.of_mensaje_error("Debe seleccionar una categoria")
		sle_categoria.setFocus()
		return
	end if
	
	ls_categorias = trim(sle_categoria.text) + '%'
end if

if cbx_sub_categ.checked then
	ls_sub_categ = '%%'
else
	if trim(sle_cod_sub_cat.text) = '' then
		gnvo_app.of_mensaje_error("Debe seleccionar una Sub categoria")
		sle_cod_sub_cat.setFocus()
		return
	end if
	
	ls_sub_categ = trim(sle_cod_sub_cat.text) + '%'
end if

if cbx_articulos.checked then
	ls_cod_art = '%%'
else
	if trim(sle_cod_art.text) = '' then
		gnvo_app.of_mensaje_error("Debe seleccionar un ARTICULO")
		sle_cod_art.setFocus()
		return
	end if
	
	ls_cod_art = trim(sle_cod_art.text) + '%'
end if

dw_report.Retrieve(ls_cliente, ld_fecha1, ld_fecha2, ls_categorias, ls_sub_categ, ls_cod_art)
end event

type sle_desc_art from singlelineedit within w_ve768_detalle_ov
integer x = 1184
integer y = 400
integer width = 2021
integer height = 76
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_articulo from commandbutton within w_ve768_detalle_ov
integer x = 1070
integer y = 396
integer width = 114
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data, ls_cod_Cat, ls_sub_cat
boolean lb_ret

if cbx_categorias.checked then
	ls_cod_cat = '%%'
else
	ls_cod_cat = trim(sle_categoria.text) + '%'
end if

if cbx_sub_categ.checked then
	ls_sub_cat = '%%'
else
	ls_sub_cat = trim(sle_cod_sub_cat.text) + '%'
end if


ls_sql = "select distinct " &
		 + "       a.cod_art as codigo_articulo, " &
		 + "       a.desc_art as descripcion_articulo, " &
		 + "       a.und as und " &
		 + "from vale_mov       vm," &
		 + "     articulo_mov   am, " &
		 + "     articulo       a," &
		 + "     articulo_sub_categ a2 " &
		 + "where vm.nro_Vale    = am.nro_Vale " &
		 + "  and am.cod_art     = a.cod_art" &
		 + "  and a.sub_cat_art  = a2.cod_sub_cat" &
		 + "  and a2.cat_art     like '" + ls_cod_cat + "'" &
		 + "  and a2.cod_sub_cat like '" + ls_sub_cat + "'" &
		 + "  and vm.flag_estado <> '0'" &
		 + "  and am.flag_estado <> '0'" 
			 

	
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	
	sle_cod_art.text	= ls_codigo
	sle_desc_art.text	= ls_Data
	
end if
end event

type sle_cod_art from singlelineedit within w_ve768_detalle_ov
integer x = 722
integer y = 400
integer width = 343
integer height = 76
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "%"
borderstyle borderstyle = stylelowered!
end type

type cbx_articulos from checkbox within w_ve768_detalle_ov
integer x = 23
integer y = 400
integer width = 686
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los articulos"
boolean checked = true
end type

event clicked;if this.checked then
	cb_articulo.Enabled = FALSE
	sle_cod_art.Text	  = '%'
else
	cb_articulo.Enabled = TRUE
	sle_cod_art.Text	  = ''
end if
end event

type cbx_sub_categ from checkbox within w_ve768_detalle_ov
integer x = 23
integer y = 316
integer width = 686
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas las subcategorias"
boolean checked = true
end type

event clicked;if this.checked then
	cb_subcateg.Enabled = FALSE
	sle_cod_sub_cat.Text	  = '%'
else
	cb_subcateg.Enabled = TRUE
	sle_cod_sub_cat.Text	  = ''
end if
end event

type sle_cod_sub_cat from singlelineedit within w_ve768_detalle_ov
integer x = 722
integer y = 316
integer width = 343
integer height = 76
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "%"
borderstyle borderstyle = stylelowered!
end type

type cb_subcateg from commandbutton within w_ve768_detalle_ov
integer x = 1070
integer y = 312
integer width = 114
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data, ls_cod_Cat
boolean lb_ret

if cbx_categorias.checked then
	ls_cod_cat = '%%'
else
	ls_cod_cat = trim(sle_categoria.text) + '%'
end if

ls_sql = "select a2.cod_sub_cat as codigo_sub_Categoria, " &
		 + "       a2.desc_sub_Cat as descripcion_subcategoria " &
		 + "from articulo_sub_categ a2 " &
		 + "where a2.cat_art    like '" + ls_cod_cat + "'" 
			 

	
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	
	sle_cod_sub_cat.text		= ls_codigo
	sle_desc_sub_cat.text	= ls_Data
	
end if
end event

type sle_desc_sub_cat from singlelineedit within w_ve768_detalle_ov
integer x = 1184
integer y = 316
integer width = 2021
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_desc_categoria from singlelineedit within w_ve768_detalle_ov
integer x = 1184
integer y = 232
integer width = 2021
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_categoria from commandbutton within w_ve768_detalle_ov
integer x = 1070
integer y = 228
integer width = 114
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "select a1.cat_art as codigo_Categoria, " &
		 + "       a1.desc_categoria as descripcion_categoria " &
		 + "from articulo_categ a1 "
	
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	
	sle_categoria.text		= ls_codigo
	sle_Desc_categoria.text	= ls_Data
	
end if
end event

type sle_categoria from singlelineedit within w_ve768_detalle_ov
integer x = 722
integer y = 232
integer width = 343
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "%"
borderstyle borderstyle = stylelowered!
end type

type cbx_categorias from checkbox within w_ve768_detalle_ov
integer x = 23
integer y = 232
integer width = 594
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos las categorias"
boolean checked = true
end type

event clicked;if this.checked then
	sle_categoria.Text	  = '%'
	cb_categoria.enabled = false
else
	sle_categoria.Text	  = ''
	cb_categoria.enabled = true
end if
end event

type sle_razon_social from singlelineedit within w_ve768_detalle_ov
integer x = 1184
integer y = 148
integer width = 2021
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ve768_detalle_ov
integer x = 2757
integer y = 40
integer width = 443
integer height = 104
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type sle_cliente from singlelineedit within w_ve768_detalle_ov
integer x = 722
integer y = 148
integer width = 343
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "%"
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_ve768_detalle_ov
integer x = 1070
integer y = 144
integer width = 114
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "select distinct " &
		 + "       p.proveedor as cod_cliente, " &
		 + "       p.nom_proveedor as nom_cliente, " &
		 + "       decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni " &
		 + "from orden_venta ov, " &
		 + "     proveedor   p " &
		 + "where ov.cliente = p.proveedor " &
		 + "  and ov.flag_estado <> '0'" 
			 

	
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	
	sle_cliente.text			= ls_codigo
	sle_razon_social.text	= ls_Data
	
end if
end event

type cbx_clientes from checkbox within w_ve768_detalle_ov
integer x = 27
integer y = 152
integer width = 562
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas los clientes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_cliente.Enabled = FALSE
	sle_cliente.Text	  = '%'
	cb_3.enabled = false
else
	sle_cliente.Enabled = TRUE
	sle_cliente.Text	  = ''
	cb_3.enabled = true
end if
end event

type dw_report from u_dw_rpt within w_ve768_detalle_ov
integer y = 504
integer width = 3310
integer height = 1572
string dataobject = "d_rpt_ordenes_venta_tbl"
boolean livescroll = false
end type

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type uo_fechas from u_ingreso_rango_fechas within w_ve768_detalle_ov
event destroy ( )
integer x = 41
integer y = 56
integer taborder = 60
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:')// para seatear el titulo del boton 
of_set_fecha(Date('01/'+string(today(),'mm/yyyy')), date(gd_fecha)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/2002')) // rango inicial
of_set_rango_fin(date(gd_fecha)) // rango final

end event

type gb_1 from groupbox within w_ve768_detalle_ov
integer width = 3666
integer height = 496
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos"
end type

