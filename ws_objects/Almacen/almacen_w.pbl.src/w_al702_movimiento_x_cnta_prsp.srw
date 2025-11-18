$PBExportHeader$w_al702_movimiento_x_cnta_prsp.srw
forward
global type w_al702_movimiento_x_cnta_prsp from w_rpt_list
end type
type gb_fechas from groupbox within w_al702_movimiento_x_cnta_prsp
end type
type uo_1 from u_ingreso_rango_fechas_v within w_al702_movimiento_x_cnta_prsp
end type
type rb_1 from radiobutton within w_al702_movimiento_x_cnta_prsp
end type
type rb_2 from radiobutton within w_al702_movimiento_x_cnta_prsp
end type
type rb_3 from radiobutton within w_al702_movimiento_x_cnta_prsp
end type
type rb_4 from radiobutton within w_al702_movimiento_x_cnta_prsp
end type
type st_1 from statictext within w_al702_movimiento_x_cnta_prsp
end type
type cb_3 from commandbutton within w_al702_movimiento_x_cnta_prsp
end type
type sle_descrip from singlelineedit within w_al702_movimiento_x_cnta_prsp
end type
type sle_almacen from singlelineedit within w_al702_movimiento_x_cnta_prsp
end type
type gb_2 from groupbox within w_al702_movimiento_x_cnta_prsp
end type
type gb_3 from groupbox within w_al702_movimiento_x_cnta_prsp
end type
type gb_1 from groupbox within w_al702_movimiento_x_cnta_prsp
end type
end forward

global type w_al702_movimiento_x_cnta_prsp from w_rpt_list
integer width = 3739
integer height = 1280
string title = "Movimientos por Cuenta Presupuestal [AL702]"
string menuname = "m_impresion"
windowstate windowstate = maximized!
gb_fechas gb_fechas
uo_1 uo_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
st_1 st_1
cb_3 cb_3
sle_descrip sle_descrip
sle_almacen sle_almacen
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_al702_movimiento_x_cnta_prsp w_al702_movimiento_x_cnta_prsp

type variables
Int ii_index = 0
end variables

on w_al702_movimiento_x_cnta_prsp.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.uo_1=create uo_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.st_1=create st_1
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
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.sle_descrip
this.Control[iCurrent+10]=this.sle_almacen
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_3
this.Control[iCurrent+13]=this.gb_1
end on

on w_al702_movimiento_x_cnta_prsp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.uo_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.st_1)
destroy(this.cb_3)
destroy(this.sle_descrip)
destroy(this.sle_almacen)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

type dw_report from w_rpt_list`dw_report within w_al702_movimiento_x_cnta_prsp
boolean visible = false
integer x = 23
integer y = 312
integer width = 3319
integer height = 1960
end type

type dw_1 from w_rpt_list`dw_1 within w_al702_movimiento_x_cnta_prsp
integer x = 41
integer y = 432
integer width = 1605
integer height = 596
integer taborder = 50
string dataobject = "d_sel_mov_almacen_x_cta_presup"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;
ii_ck[1] = 1 
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2

end event

type pb_1 from w_rpt_list`pb_1 within w_al702_movimiento_x_cnta_prsp
integer x = 1710
integer y = 592
integer taborder = 70
end type

event pb_1::clicked;call super::clicked;if dw_2.rowcount() > 0 then
	cb_report.enabled = true
end if
end event

type pb_2 from w_rpt_list`pb_2 within w_al702_movimiento_x_cnta_prsp
integer x = 1710
integer y = 728
integer taborder = 100
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;if dw_2.rowcount() = 0 then
	cb_report.enabled = false
end if
end event

type dw_2 from w_rpt_list`dw_2 within w_al702_movimiento_x_cnta_prsp
integer x = 1906
integer y = 432
integer width = 1669
integer height = 596
integer taborder = 90
string dataobject = "d_sel_mov_almacen_x_cta_presup"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2
end event

type cb_report from w_rpt_list`cb_report within w_al702_movimiento_x_cnta_prsp
integer x = 3291
integer y = 192
integer width = 361
integer height = 92
integer taborder = 40
integer weight = 700
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;Long 	ll_row
String ls_acod[], ls_alm, ls_tipo_mov  // ls_cod, 
Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()
ls_alm = sle_almacen.text

if rb_3.checked = true then ls_tipo_mov = 'I'
if rb_4.checked = true then ls_tipo_mov = 'S'

if rb_2.checked = true then   // Resumen	
	dw_report.dataobject = 'd_rpt_mov_x_cta_presup_res'
else
	dw_report.dataobject = 'd_rpt_mov_x_cta_presup'	
end if
dw_report.SetTransObject( sqlca)

// Llena datos de dw seleccionados a tabla temporal	
FOR ll_row = 1 to dw_2.rowcount()
	ls_acod[ll_row] = dw_2.object.cnta_prsp[ll_row]
NEXT	

dw_1.visible = false
dw_2.visible = false
	
dw_report.Object.Datawindow.Print.Preview = 'Yes'
dw_report.Object.Datawindow.Print.Paper.Size = 9
dw_report.Object.Datawindow.Print.Orientation = 2
	
dw_report.visible = true
dw_report.retrieve(ld_desde, ld_hasta, ls_alm, ls_tipo_mov, ls_acod)	
dw_report.object.fec_ini.text = STRING(uo_1.of_get_fecha1(), "DD/MM/YYYY")
dw_report.object.fec_fin.text = STRING(uo_1.of_get_fecha2(), "DD/MM/YYYY")
dw_report.object.t_user.text = gs_user
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_objeto.text = 'AL702'
dw_report.object.t_almacen.text = sle_descrip.text
if rb_3.checked = true then
	dw_report.object.titulo.text = "Ingresos - En Nuevos Soles"
else
	dw_report.object.titulo.text = "Salidas - En Nuevos Soles"
end if
end event

type gb_fechas from groupbox within w_al702_movimiento_x_cnta_prsp
integer x = 46
integer y = 8
integer width = 704
integer height = 300
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Fechas"
end type

type uo_1 from u_ingreso_rango_fechas_v within w_al702_movimiento_x_cnta_prsp
integer x = 73
integer y = 92
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

type rb_1 from radiobutton within w_al702_movimiento_x_cnta_prsp
integer x = 795
integer y = 104
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
long backcolor = 12632256
string text = "  Detalle"
boolean checked = true
boolean righttoleft = true
end type

type rb_2 from radiobutton within w_al702_movimiento_x_cnta_prsp
integer x = 795
integer y = 200
integer width = 370
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "  Resumen"
boolean righttoleft = true
end type

type rb_3 from radiobutton within w_al702_movimiento_x_cnta_prsp
integer x = 1271
integer y = 112
integer width = 347
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "  Ingresos"
boolean checked = true
boolean righttoleft = true
end type

type rb_4 from radiobutton within w_al702_movimiento_x_cnta_prsp
integer x = 1271
integer y = 212
integer width = 352
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = " Salidas  "
boolean righttoleft = true
end type

type st_1 from statictext within w_al702_movimiento_x_cnta_prsp
integer x = 50
integer y = 356
integer width = 873
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
string text = "Cuentas Presupuestales"
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_al702_movimiento_x_cnta_prsp
integer x = 3291
integer y = 56
integer width = 361
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

type sle_descrip from singlelineedit within w_al702_movimiento_x_cnta_prsp
integer x = 2112
integer y = 148
integer width = 1111
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

type sle_almacen from singlelineedit within w_al702_movimiento_x_cnta_prsp
event dobleclick pbm_lbuttondblclk
integer x = 1874
integer y = 152
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

type gb_2 from groupbox within w_al702_movimiento_x_cnta_prsp
integer x = 759
integer y = 8
integer width = 457
integer height = 300
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "  Formato  : "
end type

type gb_3 from groupbox within w_al702_movimiento_x_cnta_prsp
integer x = 1225
integer y = 8
integer width = 613
integer height = 300
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Tipo Movimiento:  "
end type

type gb_1 from groupbox within w_al702_movimiento_x_cnta_prsp
integer x = 1851
integer y = 20
integer width = 1394
integer height = 284
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Almacen"
end type

