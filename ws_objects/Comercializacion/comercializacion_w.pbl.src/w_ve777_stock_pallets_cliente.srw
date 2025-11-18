$PBExportHeader$w_ve777_stock_pallets_cliente.srw
forward
global type w_ve777_stock_pallets_cliente from w_rpt
end type
type uo_fecha from u_ingreso_fecha within w_ve777_stock_pallets_cliente
end type
type sle_desc_almacen from singlelineedit within w_ve777_stock_pallets_cliente
end type
type cb_almacen from commandbutton within w_ve777_stock_pallets_cliente
end type
type sle_almacen from singlelineedit within w_ve777_stock_pallets_cliente
end type
type cbx_almacen from checkbox within w_ve777_stock_pallets_cliente
end type
type sle_desc_sub_cat from singlelineedit within w_ve777_stock_pallets_cliente
end type
type cb_subcateg from commandbutton within w_ve777_stock_pallets_cliente
end type
type sle_cod_sub_cat from singlelineedit within w_ve777_stock_pallets_cliente
end type
type cbx_sub_categ from checkbox within w_ve777_stock_pallets_cliente
end type
type sle_desc_categoria from singlelineedit within w_ve777_stock_pallets_cliente
end type
type cb_1 from commandbutton within w_ve777_stock_pallets_cliente
end type
type sle_categoria from singlelineedit within w_ve777_stock_pallets_cliente
end type
type cb_categoria from commandbutton within w_ve777_stock_pallets_cliente
end type
type cbx_categorias from checkbox within w_ve777_stock_pallets_cliente
end type
type dw_report from u_dw_rpt within w_ve777_stock_pallets_cliente
end type
type gb_1 from groupbox within w_ve777_stock_pallets_cliente
end type
end forward

global type w_ve777_stock_pallets_cliente from w_rpt
integer width = 3799
integer height = 2404
string title = "[VE777] Stock por Pallets y Cliente"
string menuname = "m_reporte"
uo_fecha uo_fecha
sle_desc_almacen sle_desc_almacen
cb_almacen cb_almacen
sle_almacen sle_almacen
cbx_almacen cbx_almacen
sle_desc_sub_cat sle_desc_sub_cat
cb_subcateg cb_subcateg
sle_cod_sub_cat sle_cod_sub_cat
cbx_sub_categ cbx_sub_categ
sle_desc_categoria sle_desc_categoria
cb_1 cb_1
sle_categoria sle_categoria
cb_categoria cb_categoria
cbx_categorias cbx_categorias
dw_report dw_report
gb_1 gb_1
end type
global w_ve777_stock_pallets_cliente w_ve777_stock_pallets_cliente

on w_ve777_stock_pallets_cliente.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_fecha=create uo_fecha
this.sle_desc_almacen=create sle_desc_almacen
this.cb_almacen=create cb_almacen
this.sle_almacen=create sle_almacen
this.cbx_almacen=create cbx_almacen
this.sle_desc_sub_cat=create sle_desc_sub_cat
this.cb_subcateg=create cb_subcateg
this.sle_cod_sub_cat=create sle_cod_sub_cat
this.cbx_sub_categ=create cbx_sub_categ
this.sle_desc_categoria=create sle_desc_categoria
this.cb_1=create cb_1
this.sle_categoria=create sle_categoria
this.cb_categoria=create cb_categoria
this.cbx_categorias=create cbx_categorias
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.sle_desc_almacen
this.Control[iCurrent+3]=this.cb_almacen
this.Control[iCurrent+4]=this.sle_almacen
this.Control[iCurrent+5]=this.cbx_almacen
this.Control[iCurrent+6]=this.sle_desc_sub_cat
this.Control[iCurrent+7]=this.cb_subcateg
this.Control[iCurrent+8]=this.sle_cod_sub_cat
this.Control[iCurrent+9]=this.cbx_sub_categ
this.Control[iCurrent+10]=this.sle_desc_categoria
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.sle_categoria
this.Control[iCurrent+13]=this.cb_categoria
this.Control[iCurrent+14]=this.cbx_categorias
this.Control[iCurrent+15]=this.dw_report
this.Control[iCurrent+16]=this.gb_1
end on

on w_ve777_stock_pallets_cliente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.sle_desc_almacen)
destroy(this.cb_almacen)
destroy(this.sle_almacen)
destroy(this.cbx_almacen)
destroy(this.sle_desc_sub_cat)
destroy(this.cb_subcateg)
destroy(this.sle_cod_sub_cat)
destroy(this.cbx_sub_categ)
destroy(this.sle_desc_categoria)
destroy(this.cb_1)
destroy(this.sle_categoria)
destroy(this.cb_categoria)
destroy(this.cbx_categorias)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
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

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha
string 	ls_categorias, ls_sub_categ, ls_tiempo, ls_almacen
DateTime	ldt_fecha1, ldt_fecha2
Decimal	ldc_dif_tiempo

ld_fecha = uo_Fecha.of_get_fecha()

if cbx_almacen.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		gnvo_app.of_mensaje_error("Debe seleccionar una ALMACEN")
		sle_almacen.setFocus()
		return
	end if
	
	ls_almacen = trim(sle_almacen.text) + '%'
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

ldt_Fecha1 = gnvo_app.of_fecha_Actual()
dw_report.Retrieve(ld_fecha, ls_almacen, ls_Categorias, ls_sub_Categ)
ldt_fecha2 = gnvo_app.of_fecha_Actual()

select (:ldt_fecha2 - :ldt_fecha1) 
	into :ldc_dif_tiempo
from dual;

ls_tiempo = gnvo_app.utilitario.of_time_to_string(ldc_dif_tiempo)

MessageBox('Aviso', 'Reporte generado satisfactoriamente en ' + ls_tiempo, Information!)
end event

type uo_fecha from u_ingreso_fecha within w_ve777_stock_pallets_cliente
event destroy ( )
integer x = 55
integer y = 80
integer taborder = 60
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:') // para seatear el titulo del boton
 of_set_fecha(date(gnvo_app.of_fecha_actual())) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

type sle_desc_almacen from singlelineedit within w_ve777_stock_pallets_cliente
integer x = 1952
integer y = 48
integer width = 891
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
borderstyle borderstyle = stylelowered!
end type

type cb_almacen from commandbutton within w_ve777_stock_pallets_cliente
integer x = 1838
integer y = 44
integer width = 114
integer height = 80
integer taborder = 30
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

ls_sql = "select al.almacen as almacen, " &
		 + "       al.desc_almacen as descripcion_almacen " &
		 + "from almacen     al " &
		 + "where al.flag_estado = '1'" 
			 

	
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	
	sle_almacen.text			= ls_codigo
	sle_desc_almacen.text	= ls_Data
	
end if
end event

type sle_almacen from singlelineedit within w_ve777_stock_pallets_cliente
integer x = 1490
integer y = 48
integer width = 343
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

type cbx_almacen from checkbox within w_ve777_stock_pallets_cliente
integer x = 791
integer y = 48
integer width = 608
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los almacenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.Text	  = '%'
	cb_almacen.enabled = false
else
	sle_almacen.Text	  = ''
	cb_almacen.enabled = true
end if
end event

type sle_desc_sub_cat from singlelineedit within w_ve777_stock_pallets_cliente
integer x = 1952
integer y = 216
integer width = 891
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
borderstyle borderstyle = stylelowered!
end type

type cb_subcateg from commandbutton within w_ve777_stock_pallets_cliente
integer x = 1838
integer y = 212
integer width = 114
integer height = 80
integer taborder = 30
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

ls_sql = "select distinct " &
		 + "       a2.cod_sub_cat as codigo_sub_Categoria, " &
		 + "       a2.desc_sub_Cat as descripcion_subcategoria " &
		 + "from vale_mov       vm," &
		 + "     articulo_mov   am, " &
		 + "     articulo       a," &
		 + "     articulo_sub_categ a2 " &
		 + "where vm.nro_Vale = am.nro_Vale " &
		 + "  and am.cod_art  = a.cod_art" &
		 + "  and a.sub_cat_art = a2.cod_sub_cat" &
		 + "  and a2.cat_art    like '" + ls_cod_cat + "'" &
		 + "  and vm.flag_estado <> '0'" &
		 + "  and am.flag_estado <> '0'" 
			 

	
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	
	sle_cod_sub_cat.text		= ls_codigo
	sle_desc_sub_cat.text	= ls_Data
	
end if
end event

type sle_cod_sub_cat from singlelineedit within w_ve777_stock_pallets_cliente
integer x = 1490
integer y = 216
integer width = 343
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

type cbx_sub_categ from checkbox within w_ve777_stock_pallets_cliente
integer x = 791
integer y = 216
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

type sle_desc_categoria from singlelineedit within w_ve777_stock_pallets_cliente
integer x = 1952
integer y = 132
integer width = 891
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

type cb_1 from commandbutton within w_ve777_stock_pallets_cliente
integer x = 2875
integer y = 52
integer width = 443
integer height = 180
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

event clicked;Parent.Event ue_retrieve()
end event

type sle_categoria from singlelineedit within w_ve777_stock_pallets_cliente
integer x = 1490
integer y = 132
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
borderstyle borderstyle = stylelowered!
end type

type cb_categoria from commandbutton within w_ve777_stock_pallets_cliente
integer x = 1838
integer y = 128
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

ls_sql = "select a1.cat_art as codigo_Categoria, " &
		 + "       a1.desc_categoria as descripcion_categoria " &
		 + "from articulo_categ     a1 " &
		 + "where a1.flag_estado = '1'" 
			 

	
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	
	sle_categoria.text		= ls_codigo
	sle_Desc_categoria.text	= ls_Data
	
end if
end event

type cbx_categorias from checkbox within w_ve777_stock_pallets_cliente
integer x = 791
integer y = 132
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

type dw_report from u_dw_rpt within w_ve777_stock_pallets_cliente
integer x = 5
integer y = 384
integer width = 3310
integer height = 1748
string dataobject = "d_rpt_stock_pallets_cliente_tbl"
boolean livescroll = false
end type

event getfocus;call super::getfocus;gnvo_app.of_select_current_row( this )
end event

type gb_1 from groupbox within w_ve777_stock_pallets_cliente
integer width = 3570
integer height = 356
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

