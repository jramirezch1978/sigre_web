$PBExportHeader$w_al701_movimiento_x_cencos.srw
forward
global type w_al701_movimiento_x_cencos from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_al701_movimiento_x_cencos
end type
type sle_descrip from singlelineedit within w_al701_movimiento_x_cencos
end type
type sle_almacen from singlelineedit within w_al701_movimiento_x_cencos
end type
type rb_detalle from radiobutton within w_al701_movimiento_x_cencos
end type
type rb_resumen from radiobutton within w_al701_movimiento_x_cencos
end type
type cb_reporte from commandbutton within w_al701_movimiento_x_cencos
end type
type cbx_todos from checkbox within w_al701_movimiento_x_cencos
end type
type rb_1 from radiobutton within w_al701_movimiento_x_cencos
end type
type rb_2 from radiobutton within w_al701_movimiento_x_cencos
end type
type gb_fechas from groupbox within w_al701_movimiento_x_cencos
end type
type gb_2 from groupbox within w_al701_movimiento_x_cencos
end type
type gb_1 from groupbox within w_al701_movimiento_x_cencos
end type
type gb_3 from groupbox within w_al701_movimiento_x_cencos
end type
end forward

global type w_al701_movimiento_x_cencos from w_report_smpl
integer width = 4667
integer height = 2148
string title = "[AL701] Gastos por Centros de Costo"
string menuname = "m_impresion"
uo_fecha uo_fecha
sle_descrip sle_descrip
sle_almacen sle_almacen
rb_detalle rb_detalle
rb_resumen rb_resumen
cb_reporte cb_reporte
cbx_todos cbx_todos
rb_1 rb_1
rb_2 rb_2
gb_fechas gb_fechas
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
end type
global w_al701_movimiento_x_cencos w_al701_movimiento_x_cencos

on w_al701_movimiento_x_cencos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.sle_descrip=create sle_descrip
this.sle_almacen=create sle_almacen
this.rb_detalle=create rb_detalle
this.rb_resumen=create rb_resumen
this.cb_reporte=create cb_reporte
this.cbx_todos=create cbx_todos
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_fechas=create gb_fechas
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.sle_descrip
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.rb_detalle
this.Control[iCurrent+5]=this.rb_resumen
this.Control[iCurrent+6]=this.cb_reporte
this.Control[iCurrent+7]=this.cbx_todos
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.gb_fechas
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_3
end on

on w_al701_movimiento_x_cencos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.sle_descrip)
destroy(this.sle_almacen)
destroy(this.rb_detalle)
destroy(this.rb_resumen)
destroy(this.cb_reporte)
destroy(this.cbx_todos)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_fechas)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;Long 		ll_row
String 	ls_alm
Date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()
if cbx_todos.checked then
	ls_alm = '%%'
else
	if trim(sle_almacen.text) = '' then
		gnvo_app.of_mensaje_error( "Error, debe seleccionar un almacén primero")
		sle_almacen.setFocus( )
		return
	end if

	ls_alm = trim(sle_almacen.text) +'%'
end if

if not rb_1.checked and not rb_2.checked then
	gnvo_app.of_mensaje_error( "Error, Debe seleccionar el tipo de filtro de centros de costos")
	rb_1.setFocus( )
	return
end if


if rb_resumen.checked = true then   // Resumen	
	dw_report.dataobject = 'd_rpt_gastos_ccosto_resumen_tbl'
else
	dw_report.dataobject = 'd_rpt_gastos_ccosto_detalle_tbl'
end if

dw_report.SetTransObject( sqlca)

// Llena datos de dw seleccionados a tabla temporal	
dw_report.visible = true	
dw_report.retrieve(ld_Fecha1, ld_fecha2, ls_alm)

dw_report.object.t_almacen.text = sle_descrip.text
dw_report.Object.p_logo.filename = gs_logo

ib_preview = false

this.Event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_al701_movimiento_x_cencos
integer x = 0
integer y = 296
integer width = 2661
integer height = 1160
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_al701_movimiento_x_cencos
integer x = 14
integer y = 68
integer taborder = 30
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

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

type sle_descrip from singlelineedit within w_al701_movimiento_x_cencos
integer x = 1367
integer y = 68
integer width = 1211
integer height = 88
integer taborder = 60
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

type sle_almacen from singlelineedit within w_al701_movimiento_x_cencos
event dobleclick pbm_lbuttondblclk
integer x = 1129
integer y = 72
integer width = 224
integer height = 88
integer taborder = 50
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

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " &
		 + "where flag_tipo_almacen <> 'O'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
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
cb_reporte.visible = true

end event

type rb_detalle from radiobutton within w_al701_movimiento_x_cencos
integer x = 699
integer y = 72
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
string text = "Detalle"
end type

type rb_resumen from radiobutton within w_al701_movimiento_x_cencos
integer x = 699
integer y = 160
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
string text = "Resumen"
boolean checked = true
end type

type cb_reporte from commandbutton within w_al701_movimiento_x_cencos
integer x = 3131
integer y = 48
integer width = 343
integer height = 172
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve()
end event

type cbx_todos from checkbox within w_al701_movimiento_x_cencos
integer x = 1134
integer y = 168
integer width = 581
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los almacenes"
boolean checked = true
end type

event clicked;if cbx_todos.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if

end event

type rb_1 from radiobutton within w_al701_movimiento_x_cencos
integer x = 2647
integer y = 84
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;// Inserta todos los registros en tabla temporal
Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2
String	ls_almacen

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

if cbx_todos.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		gnvo_app.of_message_error("Debe Ingresar un almacen primero, por favor verifique!")
		sle_almacen.setFocus( )
		return
	end if
end if

delete from tt_pto_cencos;

insert into tt_pto_cencos ( cencos) 
	SELECT DISTINCT am.CENCOS
	FROM articulo_mov  am,
		  vale_mov		 vm
	WHERE vm.nro_vale	= am.nro_Vale
	  and am.cencos	is not null
	  and vm.almacen	like :ls_almacen
	  and trunc(vm.fec_registro) between trunc(:ld_fecha1) and trunc(:ld_fecha2);

Commit;
end event

type rb_2 from radiobutton within w_al701_movimiento_x_cencos
integer x = 2647
integer y = 164
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;// Inserta todos los registros en tabla temporal
Date		ld_fecha1, ld_fecha2
String	ls_almacen
str_parametros	lstr_param

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

if cbx_todos.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		gnvo_app.of_message_error("Debe Ingresar un almacen primero, por favor verifique!")
		sle_almacen.setFocus( )
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if

delete from tt_pto_cencos;
commit;

// Asigna valores a structura 
lstr_param.dw1 = "d_lista_cencos_am_tbl"	
lstr_param.tipo = '1D2D1S'	
lstr_param.fecha1 = ld_fecha1
lstr_param.fecha2 = ld_fecha2
lstr_param.string1 = ls_almacen
lstr_param.titulo = "Centros de costo"
lstr_param.opcion = 12

OpenWithParm( w_abc_seleccion, lstr_param)
end event

type gb_fechas from groupbox within w_al701_movimiento_x_cencos
integer width = 667
integer height = 284
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

type gb_2 from groupbox within w_al701_movimiento_x_cencos
integer x = 667
integer width = 439
integer height = 284
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "  Formato"
end type

type gb_1 from groupbox within w_al701_movimiento_x_cencos
integer x = 1111
integer width = 1495
integer height = 284
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen"
end type

type gb_3 from groupbox within w_al701_movimiento_x_cencos
integer x = 2610
integer width = 498
integer height = 284
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "C.Costo"
end type

