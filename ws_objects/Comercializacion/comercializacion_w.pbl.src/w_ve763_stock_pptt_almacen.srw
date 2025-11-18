$PBExportHeader$w_ve763_stock_pptt_almacen.srw
forward
global type w_ve763_stock_pptt_almacen from w_rpt
end type
type sle_desc_sub_cat from singlelineedit within w_ve763_stock_pptt_almacen
end type
type cb_subcateg from commandbutton within w_ve763_stock_pptt_almacen
end type
type sle_cod_sub_cat from singlelineedit within w_ve763_stock_pptt_almacen
end type
type cbx_sub_categ from checkbox within w_ve763_stock_pptt_almacen
end type
type sle_desc_categoria from singlelineedit within w_ve763_stock_pptt_almacen
end type
type sle_mes from singlelineedit within w_ve763_stock_pptt_almacen
end type
type sle_year from singlelineedit within w_ve763_stock_pptt_almacen
end type
type st_3 from statictext within w_ve763_stock_pptt_almacen
end type
type cb_1 from commandbutton within w_ve763_stock_pptt_almacen
end type
type sle_categoria from singlelineedit within w_ve763_stock_pptt_almacen
end type
type cb_categoria from commandbutton within w_ve763_stock_pptt_almacen
end type
type cbx_categorias from checkbox within w_ve763_stock_pptt_almacen
end type
type dw_report from u_dw_rpt within w_ve763_stock_pptt_almacen
end type
type gb_1 from groupbox within w_ve763_stock_pptt_almacen
end type
end forward

global type w_ve763_stock_pptt_almacen from w_rpt
integer width = 3799
integer height = 2404
string title = "[VE763] Stock de Producto Terminado por Almacen"
string menuname = "m_reporte"
sle_desc_sub_cat sle_desc_sub_cat
cb_subcateg cb_subcateg
sle_cod_sub_cat sle_cod_sub_cat
cbx_sub_categ cbx_sub_categ
sle_desc_categoria sle_desc_categoria
sle_mes sle_mes
sle_year sle_year
st_3 st_3
cb_1 cb_1
sle_categoria sle_categoria
cb_categoria cb_categoria
cbx_categorias cbx_categorias
dw_report dw_report
gb_1 gb_1
end type
global w_ve763_stock_pptt_almacen w_ve763_stock_pptt_almacen

on w_ve763_stock_pptt_almacen.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_desc_sub_cat=create sle_desc_sub_cat
this.cb_subcateg=create cb_subcateg
this.sle_cod_sub_cat=create sle_cod_sub_cat
this.cbx_sub_categ=create cbx_sub_categ
this.sle_desc_categoria=create sle_desc_categoria
this.sle_mes=create sle_mes
this.sle_year=create sle_year
this.st_3=create st_3
this.cb_1=create cb_1
this.sle_categoria=create sle_categoria
this.cb_categoria=create cb_categoria
this.cbx_categorias=create cbx_categorias
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_desc_sub_cat
this.Control[iCurrent+2]=this.cb_subcateg
this.Control[iCurrent+3]=this.sle_cod_sub_cat
this.Control[iCurrent+4]=this.cbx_sub_categ
this.Control[iCurrent+5]=this.sle_desc_categoria
this.Control[iCurrent+6]=this.sle_mes
this.Control[iCurrent+7]=this.sle_year
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.sle_categoria
this.Control[iCurrent+11]=this.cb_categoria
this.Control[iCurrent+12]=this.cbx_categorias
this.Control[iCurrent+13]=this.dw_report
this.Control[iCurrent+14]=this.gb_1
end on

on w_ve763_stock_pptt_almacen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_desc_sub_cat)
destroy(this.cb_subcateg)
destroy(this.sle_cod_sub_cat)
destroy(this.cbx_sub_categ)
destroy(this.sle_desc_categoria)
destroy(this.sle_mes)
destroy(this.sle_year)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.sle_categoria)
destroy(this.cb_categoria)
destroy(this.cbx_categorias)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Date	ld_hoy

idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)



//datos de reporte
ib_preview = true
This.Event ue_preview()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user



ld_hoy = Date(gnvo_app.of_fecha_actual())
sle_year.text = string(ld_hoy, 'yyyy')
sle_mes.text = string(ld_hoy, 'mm')
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

event ue_retrieve;call super::ue_retrieve;Integer	li_year, li_mes
string 	ls_categorias, ls_sub_categ, ls_tiempo
DateTime	ldt_fecha1, ldt_fecha2
Decimal	ldc_dif_tiempo

li_year 	= Integer(sle_year.text)
li_mes	= Integer(sle_mes.text)

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
dw_report.Retrieve(li_year, li_mes, ls_Categorias, ls_sub_Categ)
ldt_fecha2 = gnvo_app.of_fecha_Actual()

select (:ldt_fecha2 - :ldt_fecha1) 
	into :ldc_dif_tiempo
from dual;

ls_tiempo = gnvo_app.utilitario.of_time_to_string(ldc_dif_tiempo)

MessageBox('Aviso', 'Reporte generado satisfactoriamente en ' + ls_tiempo, Information!)
end event

type sle_desc_sub_cat from singlelineedit within w_ve763_stock_pptt_almacen
integer x = 1193
integer y = 220
integer width = 855
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

type cb_subcateg from commandbutton within w_ve763_stock_pptt_almacen
integer x = 1079
integer y = 216
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

type sle_cod_sub_cat from singlelineedit within w_ve763_stock_pptt_almacen
integer x = 731
integer y = 220
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

type cbx_sub_categ from checkbox within w_ve763_stock_pptt_almacen
integer x = 32
integer y = 220
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

type sle_desc_categoria from singlelineedit within w_ve763_stock_pptt_almacen
integer x = 1193
integer y = 136
integer width = 855
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

type sle_mes from singlelineedit within w_ve763_stock_pptt_almacen
integer x = 622
integer y = 48
integer width = 155
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_year from singlelineedit within w_ve763_stock_pptt_almacen
integer x = 375
integer y = 48
integer width = 229
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_ve763_stock_pptt_almacen
integer x = 114
integer y = 52
integer width = 251
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ve763_stock_pptt_almacen
integer x = 2770
integer y = 44
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

type sle_categoria from singlelineedit within w_ve763_stock_pptt_almacen
integer x = 731
integer y = 136
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

type cb_categoria from commandbutton within w_ve763_stock_pptt_almacen
integer x = 1079
integer y = 132
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

type cbx_categorias from checkbox within w_ve763_stock_pptt_almacen
integer x = 32
integer y = 136
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

type dw_report from u_dw_rpt within w_ve763_stock_pptt_almacen
integer y = 384
integer width = 3310
integer height = 1748
string dataobject = "d_rpt_stock_articulos_x_almacen_crt"
boolean livescroll = false
end type

event getfocus;call super::getfocus;gnvo_app.of_select_current_row( this )
end event

type gb_1 from groupbox within w_ve763_stock_pptt_almacen
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

