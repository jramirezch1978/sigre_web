$PBExportHeader$w_al701_movimiento_x_cencos_bk.srw
forward
global type w_al701_movimiento_x_cencos_bk from w_rpt_list
end type
type gb_fechas from groupbox within w_al701_movimiento_x_cencos_bk
end type
type uo_1 from u_ingreso_rango_fechas_v within w_al701_movimiento_x_cencos_bk
end type
type rb_1 from radiobutton within w_al701_movimiento_x_cencos_bk
end type
type rb_2 from radiobutton within w_al701_movimiento_x_cencos_bk
end type
type rb_3 from radiobutton within w_al701_movimiento_x_cencos_bk
end type
type rb_4 from radiobutton within w_al701_movimiento_x_cencos_bk
end type
type st_2 from statictext within w_al701_movimiento_x_cencos_bk
end type
type cb_3 from commandbutton within w_al701_movimiento_x_cencos_bk
end type
type sle_descrip from singlelineedit within w_al701_movimiento_x_cencos_bk
end type
type sle_almacen from singlelineedit within w_al701_movimiento_x_cencos_bk
end type
type gb_2 from groupbox within w_al701_movimiento_x_cencos_bk
end type
type gb_3 from groupbox within w_al701_movimiento_x_cencos_bk
end type
type gb_1 from groupbox within w_al701_movimiento_x_cencos_bk
end type
end forward

global type w_al701_movimiento_x_cencos_bk from w_rpt_list
integer width = 3648
integer height = 1496
string title = "Movimiento de Almacen por C.Costo [AL701]"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 134217739
gb_fechas gb_fechas
uo_1 uo_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
st_2 st_2
cb_3 cb_3
sle_descrip sle_descrip
sle_almacen sle_almacen
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_al701_movimiento_x_cencos_bk w_al701_movimiento_x_cencos_bk

type variables
Int ii_index = 0
end variables

on w_al701_movimiento_x_cencos_bk.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.uo_1=create uo_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.st_2=create st_2
this.cb_3=create cb_3
this.sle_descrip=create sle_descrip
this.sle_almacen=create sle_almacen
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_4
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.sle_descrip
this.Control[iCurrent+10]=this.sle_almacen
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_3
this.Control[iCurrent+13]=this.gb_1
end on

on w_al701_movimiento_x_cencos_bk.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.uo_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.st_2)
destroy(this.cb_3)
destroy(this.sle_descrip)
destroy(this.sle_almacen)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_retrieve;call super::ue_retrieve;Long 	ll_row
String ls_acod[], ls_alm, ls_tipo_mov
Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()
ls_alm = sle_almacen.text

if rb_3.checked = true then ls_tipo_mov = 'I'
if rb_4.checked = true then ls_tipo_mov = 'S'

if rb_2.checked = true then   // Resumen	
	dw_report.dataobject = 'd_rpt_mov_x_ccosto_res'
else
	dw_report.dataobject = 'd_rpt_mov_x_ccosto'
end if

dw_report.SetTransObject( sqlca)

// Llena datos de dw seleccionados a tabla temporal	
	FOR ll_row = 1 to dw_2.rowcount()		
		ls_acod[ll_row] = dw_2.object.cencos[ll_row]
	NEXT	

	dw_1.visible = false
	dw_2.visible = false
	dw_report.visible = true	
	dw_report.retrieve(ld_desde, ld_hasta, ls_alm, ls_tipo_mov, ls_acod, gs_empresa, gs_user)
	dw_report.object.t_almacen.text = sle_descrip.text
	dw_report.Object.p_logo.filename = gs_logo
	if rb_3.checked = true then
		dw_report.object.titulo.text = "Ingresos - En Nuevos Soles"
	else
		dw_report.object.titulo.text = "Salidas - En Nuevos Soles"
	end if
ib_preview = false
this.Event ue_preview()
end event

event open;call super::open;//override
// JOSE NO TE OLVIDES DE BORRAR ESTO
THIS.EVENT ue_open_pre()
end event

type dw_report from w_rpt_list`dw_report within w_al701_movimiento_x_cencos_bk
boolean visible = false
integer x = 18
integer y = 316
integer width = 3557
integer height = 944
end type

type dw_1 from w_rpt_list`dw_1 within w_al701_movimiento_x_cencos_bk
integer x = 41
integer y = 432
integer width = 1614
integer height = 744
integer taborder = 50
string dataobject = "d_dddw_cencos"
end type

event dw_1::constructor;call super::constructor;
ii_ck[1] = 1 
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2

end event

type pb_1 from w_rpt_list`pb_1 within w_al701_movimiento_x_cencos_bk
integer x = 1678
integer y = 700
integer taborder = 70
end type

event pb_1::clicked;call super::clicked;if dw_2.rowcount() > 0 then
	cb_report.enabled = true
end if
end event

type pb_2 from w_rpt_list`pb_2 within w_al701_movimiento_x_cencos_bk
integer x = 1678
integer y = 840
integer taborder = 100
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;if dw_2.rowcount() = 0 then
	cb_report.enabled = false
end if
end event

type dw_2 from w_rpt_list`dw_2 within w_al701_movimiento_x_cencos_bk
integer x = 1870
integer y = 432
integer width = 1614
integer height = 744
integer taborder = 90
string dataobject = "d_dddw_cencos"
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2
end event

type cb_report from w_rpt_list`cb_report within w_al701_movimiento_x_cencos_bk
integer x = 3241
integer y = 180
integer width = 329
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;parent.event ue_retrieve()
end event

type gb_fechas from groupbox within w_al701_movimiento_x_cencos_bk
integer x = 18
integer y = 8
integer width = 667
integer height = 284
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
string text = "Fechas"
end type

type uo_1 from u_ingreso_rango_fechas_v within w_al701_movimiento_x_cencos_bk
integer x = 46
integer y = 80
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

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas_v::destroy
end on

type rb_1 from radiobutton within w_al701_movimiento_x_cencos_bk
integer x = 731
integer y = 100
integer width = 306
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
boolean checked = true
boolean righttoleft = true
end type

type rb_2 from radiobutton within w_al701_movimiento_x_cencos_bk
integer x = 731
integer y = 188
integer width = 389
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "  Resumen"
boolean righttoleft = true
end type

type rb_3 from radiobutton within w_al701_movimiento_x_cencos_bk
integer x = 1230
integer y = 108
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "  Ingresos"
boolean checked = true
boolean righttoleft = true
end type

type rb_4 from radiobutton within w_al701_movimiento_x_cencos_bk
integer x = 1230
integer y = 192
integer width = 320
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Salidas  "
boolean righttoleft = true
end type

type st_2 from statictext within w_al701_movimiento_x_cencos_bk
integer x = 41
integer y = 356
integer width = 631
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Centro de Costos"
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_al701_movimiento_x_cencos_bk
integer x = 3241
integer y = 64
integer width = 329
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar"
end type

event clicked;// Crea archivo temporal
Date ld_desde, ld_hasta
String ls_tipo_mov, ls_alm

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

SetPointer( HourGlass!)
if rb_3.checked = true then ls_tipo_mov = 'I'
if rb_4.checked = true then ls_tipo_mov = 'S'

if sle_almacen.text = '' then 
	Messagebox( "Aviso", "Debe indicar almacen")
	return 0
end if

ls_alm = sle_almacen.text

dw_1.SetTransObject(sqlca)

dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	
dw_1.reset()
dw_2.reset()

dw_1.retrieve(ld_desde, ld_hasta, ls_alm, ls_tipo_mov)

return 1
end event

type sle_descrip from singlelineedit within w_al701_movimiento_x_cencos_bk
integer x = 1989
integer y = 132
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

type sle_almacen from singlelineedit within w_al701_movimiento_x_cencos_bk
event dobleclick pbm_lbuttondblclk
integer x = 1751
integer y = 136
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
	cb_report.visible = true
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
cb_report.visible = true

end event

type gb_2 from groupbox within w_al701_movimiento_x_cencos_bk
integer x = 695
integer y = 4
integer width = 416
integer height = 284
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "  Formato"
end type

type gb_3 from groupbox within w_al701_movimiento_x_cencos_bk
integer x = 1120
integer y = 4
integer width = 567
integer height = 284
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Tipo Movimiento"
end type

type gb_1 from groupbox within w_al701_movimiento_x_cencos_bk
integer x = 1728
integer y = 4
integer width = 1509
integer height = 284
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen"
end type

