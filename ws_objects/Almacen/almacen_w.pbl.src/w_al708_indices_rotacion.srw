$PBExportHeader$w_al708_indices_rotacion.srw
forward
global type w_al708_indices_rotacion from w_rpt_list
end type
type gb_fechas from groupbox within w_al708_indices_rotacion
end type
type uo_1 from u_ingreso_rango_fechas_v within w_al708_indices_rotacion
end type
type rb_categoria from radiobutton within w_al708_indices_rotacion
end type
type rb_subcategoria from radiobutton within w_al708_indices_rotacion
end type
type rb_articulo from radiobutton within w_al708_indices_rotacion
end type
type cb_3 from commandbutton within w_al708_indices_rotacion
end type
type sle_almacen from singlelineedit within w_al708_indices_rotacion
end type
type sle_descrip from singlelineedit within w_al708_indices_rotacion
end type
type gb_tipo_reporte from groupbox within w_al708_indices_rotacion
end type
type gb_1 from groupbox within w_al708_indices_rotacion
end type
end forward

global type w_al708_indices_rotacion from w_rpt_list
integer width = 3634
integer height = 2000
string title = "Indices de Rotacion (al708)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
gb_fechas gb_fechas
uo_1 uo_1
rb_categoria rb_categoria
rb_subcategoria rb_subcategoria
rb_articulo rb_articulo
cb_3 cb_3
sle_almacen sle_almacen
sle_descrip sle_descrip
gb_tipo_reporte gb_tipo_reporte
gb_1 gb_1
end type
global w_al708_indices_rotacion w_al708_indices_rotacion

type variables
Integer ii_index
end variables

on w_al708_indices_rotacion.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.uo_1=create uo_1
this.rb_categoria=create rb_categoria
this.rb_subcategoria=create rb_subcategoria
this.rb_articulo=create rb_articulo
this.cb_3=create cb_3
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.gb_tipo_reporte=create gb_tipo_reporte
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.rb_categoria
this.Control[iCurrent+4]=this.rb_subcategoria
this.Control[iCurrent+5]=this.rb_articulo
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.sle_almacen
this.Control[iCurrent+8]=this.sle_descrip
this.Control[iCurrent+9]=this.gb_tipo_reporte
this.Control[iCurrent+10]=this.gb_1
end on

on w_al708_indices_rotacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.uo_1)
destroy(this.rb_categoria)
destroy(this.rb_subcategoria)
destroy(this.rb_articulo)
destroy(this.cb_3)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.gb_tipo_reporte)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_retrieve;call super::ue_retrieve;Date ld_desde, ld_hasta
String ls_alm

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()
ls_alm = sle_almacen.text

SetPointer( Hourglass!)
if dw_2.rowcount() = 0 then return
	// Llena datos de dw seleccionados a tabla temporal
	Long 	ll_row
	String ls_cod 
   delete from tt_alm_seleccion;
	FOR ll_row = 1 to dw_2.rowcount()
		If rb_articulo.checked = true then
			ls_cod = dw_2.object.cod_art[ll_row]
		ElseIf rb_subcategoria.checked = true then
			ls_cod = dw_2.object.cod_sub_cat[ll_row]
		Elseif rb_categoria.checked = true then
			ls_cod = dw_2.object.cat_Art[ll_row]
		end if
		
		Insert into tt_alm_seleccion( cod_Art, fecha1, fecha2) values ( :ls_cod, :ld_desde, :ld_hasta);		
		If sqlca.sqlcode = -1 then
			messagebox("Error al insertar registro",sqlca.sqlerrtext)
		END IF
	NEXT		
//	commit;
	If rb_articulo.checked = true then
		DECLARE PB_USP_CMP_COMPRAS_ARTICULOS PROCEDURE FOR USP_ALM_IND_ROT_ART(:ls_alm);
		EXECUTE PB_USP_CMP_COMPRAS_ARTICULOS;	
	ElseIf rb_subcategoria.checked = true then
		DECLARE PB_USP_CMP_COMPRAS_SUBCATEGORIA PROCEDURE FOR USP_ALM_IND_ROT_SUBCAT
				  (:ls_alm);
		EXECUTE PB_USP_CMP_COMPRAS_SUBCATEGORIA;
	Elseif rb_categoria.checked = true then
		DECLARE PB_USP_CMP_COMPRAS_CATEGORIA PROCEDURE FOR USP_ALM_IND_ROT_CATEG
				  (:ld_desde, :ld_hasta, :ls_alm);
	   EXECUTE PB_USP_CMP_COMPRAS_CATEGORIA;	
	end if
	If sqlca.sqlcode = -1 then
		messagebox("Error en el Store Procedure",sqlca.sqlerrtext)
	Else		
		dw_report.SetTransObject( sqlca)
		dw_1.visible = false
		dw_2.visible = false
		this.Event ue_preview()
		dw_report.visible = true
		dw_report.retrieve()	
		dw_report.object.t_tit1.text = "En Nuevos Soles - Del " + &
		    STRING(uo_1.of_get_fecha1(), "DD/MM/YYYY") + &
			 STRING(uo_1.of_get_fecha2(), "DD/MM/YYYY")	
		dw_report.object.t_user.text = gs_user
		dw_report.object.t_tit2.text = sle_descrip.text	
		dw_report.Object.p_logo.filename = gs_logo
	End If

end event

type dw_report from w_rpt_list`dw_report within w_al708_indices_rotacion
boolean visible = false
integer x = 23
integer y = 312
integer width = 3319
integer height = 1960
end type

type dw_1 from w_rpt_list`dw_1 within w_al708_indices_rotacion
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
ii_ck[2] = 2
//ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
//ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
//ii_rk[3] = 3
end event

type pb_1 from w_rpt_list`pb_1 within w_al708_indices_rotacion
integer x = 1627
integer y = 724
integer taborder = 70
end type

type pb_2 from w_rpt_list`pb_2 within w_al708_indices_rotacion
integer x = 1627
integer y = 1248
integer taborder = 100
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_al708_indices_rotacion
integer x = 1847
integer y = 400
integer width = 1522
integer height = 1308
integer taborder = 90
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
//ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
//ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
//ii_rk[3] = 3
end event

type cb_report from w_rpt_list`cb_report within w_al708_indices_rotacion
integer x = 2949
integer y = 180
integer width = 457
integer height = 92
integer taborder = 40
integer weight = 700
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;parent.event ue_retrieve()
end event

type gb_fechas from groupbox within w_al708_indices_rotacion
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
long backcolor = 67108864
end type

type uo_1 from u_ingreso_rango_fechas_v within w_al708_indices_rotacion
integer x = 73
integer y = 72
integer taborder = 20
boolean bringtotop = true
long backcolor = 67108864
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final



end event

on uo_1.destroy
call u_ingreso_rango_fechas_v::destroy
end on

type rb_categoria from radiobutton within w_al708_indices_rotacion
integer x = 759
integer y = 60
integer width = 594
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Categorías"
boolean lefttext = true
end type

type rb_subcategoria from radiobutton within w_al708_indices_rotacion
integer x = 759
integer y = 136
integer width = 594
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Sub Categorías"
boolean lefttext = true
end type

type rb_articulo from radiobutton within w_al708_indices_rotacion
integer x = 759
integer y = 212
integer width = 594
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Artículo"
boolean lefttext = true
end type

type cb_3 from commandbutton within w_al708_indices_rotacion
integer x = 2949
integer y = 52
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
string text = "Mostrar"
end type

event clicked;Date ld_desde, ld_hasta
string ls_alm

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()
SetPointer( HourGlass!)

if rb_categoria.checked = false and rb_subcategoria.checked = false &
   and rb_articulo.checked = false then
	Messagebox( "Aviso", "Indique tipo de reporte")
	return
end if
if TRIM(sle_almacen.text) = '' then 
	Messagebox( "Aviso", "Debe indicar almacen")
	return 0
end if
ls_alm = sle_almacen.text

if rb_categoria.checked = true then
	dw_1.DataObject= 'd_sel_mov_almacen_categoria'
	dw_2.DataObject= 'd_sel_mov_almacen_categoria'
	dw_report.DataObject= 'd_rpt_indice_rotac_categoria'
end if

if rb_subcategoria.checked = true then
	dw_1.DataObject= 'd_sel_mov_almacen_subcategoria'
	dw_2.DataObject= 'd_sel_mov_almacen_subcategoria'
	dw_report.DataObject= 'd_rpt_indice_rotac_subcateg'
end if
if rb_articulo.checked = true then
//	dw_1.DataObject= 'd_sel_mov_almacen_seleccion'
//	dw_2.DataObject= 'd_sel_mov_almacen_seleccion'
	dw_1.DataObject= 'd_sel_mov_articulos_fecha'
	dw_2.DataObject= 'd_sel_mov_articulos_fecha'
	dw_report.DataObject= 'd_rpt_indice_rotac_articulo'
end if

dw_1.SetTransObject(sqlca)
dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	
dw_1.reset()
dw_2.reset()
if rb_articulo.checked = true then
	dw_1.retrieve(ld_desde, ld_hasta, ls_alm)
else
	dw_1.retrieve(ls_alm)
end if
end event

type sle_almacen from singlelineedit within w_al708_indices_rotacion
event dobleclick pbm_lbuttondblclk
integer x = 1440
integer y = 116
integer width = 224
integer height = 88
integer taborder = 100
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
	    + "FROM almacen " &
		 + "where flag_tipo_almacen <> 'O'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
	Parent.event dynamic ue_seleccionar()

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
where almacen = :ls_almacen 
  and flag_tipo_almacen <> 'O';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe o es un almacén de tránsito')
	return
end if

sle_descrip.text = ls_desc
Parent.event dynamic ue_seleccionar()


end event

type sle_descrip from singlelineedit within w_al708_indices_rotacion
integer x = 1669
integer y = 116
integer width = 1211
integer height = 88
integer taborder = 110
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

type gb_tipo_reporte from groupbox within w_al708_indices_rotacion
integer x = 727
integer y = 4
integer width = 667
integer height = 300
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_al708_indices_rotacion
integer x = 1417
integer y = 4
integer width = 1513
integer height = 300
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
end type

