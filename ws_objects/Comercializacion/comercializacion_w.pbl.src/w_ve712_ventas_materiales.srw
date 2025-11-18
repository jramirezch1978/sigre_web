$PBExportHeader$w_ve712_ventas_materiales.srw
forward
global type w_ve712_ventas_materiales from w_report_smpl
end type
type cb_aceptar from commandbutton within w_ve712_ventas_materiales
end type
type uo_1 from u_ingreso_rango_fechas within w_ve712_ventas_materiales
end type
type rb_soles from radiobutton within w_ve712_ventas_materiales
end type
type rb_dolares from radiobutton within w_ve712_ventas_materiales
end type
type rb_resumen from radiobutton within w_ve712_ventas_materiales
end type
type rb_detalle from radiobutton within w_ve712_ventas_materiales
end type
type gb_1 from groupbox within w_ve712_ventas_materiales
end type
type gb_3 from groupbox within w_ve712_ventas_materiales
end type
type gb_2 from groupbox within w_ve712_ventas_materiales
end type
end forward

global type w_ve712_ventas_materiales from w_report_smpl
integer width = 2670
integer height = 1484
string title = "[VE712] Ventas Generales de Materiales"
string menuname = "m_reporte"
long backcolor = 67108864
cb_aceptar cb_aceptar
uo_1 uo_1
rb_soles rb_soles
rb_dolares rb_dolares
rb_resumen rb_resumen
rb_detalle rb_detalle
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
end type
global w_ve712_ventas_materiales w_ve712_ventas_materiales

type variables
string is_canal, is_sub_canal, is_zona, is_distrito, is_desc_distrito, &
		 is_pais, is_dpto, is_prov, is_flag_opc, is_desc_opc, is_categ, is_serie
date id_fec_ini, id_fec_fin
end variables

on w_ve712_ventas_materiales.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_aceptar=create cb_aceptar
this.uo_1=create uo_1
this.rb_soles=create rb_soles
this.rb_dolares=create rb_dolares
this.rb_resumen=create rb_resumen
this.rb_detalle=create rb_detalle
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_aceptar
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.rb_soles
this.Control[iCurrent+4]=this.rb_dolares
this.Control[iCurrent+5]=this.rb_resumen
this.Control[iCurrent+6]=this.rb_detalle
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.gb_2
end on

on w_ve712_ventas_materiales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_aceptar)
destroy(this.uo_1)
destroy(this.rb_soles)
destroy(this.rb_dolares)
destroy(this.rb_resumen)
destroy(this.rb_detalle)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;date ld_fec_ini, ld_fec_fin
string ls_clase[2], ls_clase_productos, ls_clase_sub_productos, ls_soles, ls_dolares, ls_moneda

id_fec_ini = uo_1.of_get_fecha1( )
id_fec_fin = uo_1.of_get_fecha2( )

Select clase_prod_term, clase_sub_prod
  into :ls_clase_productos, :ls_clase_sub_productos
  From sig_agricola Where reckey = '1';
 
ls_clase [1] = ls_clase_productos
ls_clase [2] = ls_clase_sub_productos

select cod_soles, cod_dolares
  into :ls_soles, :ls_dolares
  from logparam where reckey = '1';

if rb_soles.checked = true then
	ls_moneda = ls_soles
	if rb_resumen.checked = true then
		dw_report.dataobject = 'd_rpt_ventas_materiales_soles_res'
	else
		dw_report.dataobject = 'd_rpt_ventas_materiales_soles'
	end if
else
	ls_dolares = ls_dolares
	if rb_resumen.checked = true then
		dw_report.dataobject = 'd_rpt_ventas_materiales_dolares_res'
	else
		dw_report.dataobject = 'd_rpt_ventas_materiales_dolares'
	end if
end if

dw_report.settransobject( sqlca )
dw_report.retrieve( id_fec_ini, id_fec_fin, ls_moneda, ls_clase[], gs_empresa, gs_user )
dw_report.object.p_logo.filename = gs_logo


ib_preview = false
this.event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_ve712_ventas_materiales
integer x = 37
integer y = 256
integer width = 2528
integer height = 964
string dataobject = "d_rpt_ventas_materiales_soles_res"
integer ii_zoom_actual = 100
end type

type cb_aceptar from commandbutton within w_ve712_ventas_materiales
integer x = 2231
integer y = 128
integer width = 334
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event ue_retrieve( )
end event

type uo_1 from u_ingreso_rango_fechas within w_ve712_ventas_materiales
event destroy ( )
integer x = 64
integer y = 100
integer height = 80
integer taborder = 70
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Del:','Al:') 								//	para setear la fecha inicial
of_set_fecha(date(relativedate(today(),-1)), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type rb_soles from radiobutton within w_ve712_ventas_materiales
integer x = 1454
integer y = 96
integer width = 320
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Soles"
boolean checked = true
end type

type rb_dolares from radiobutton within w_ve712_ventas_materiales
integer x = 1454
integer y = 160
integer width = 320
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dolares"
end type

type rb_resumen from radiobutton within w_ve712_ventas_materiales
integer x = 1851
integer y = 96
integer width = 320
integer height = 52
boolean bringtotop = true
integer textsize = -8
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

type rb_detalle from radiobutton within w_ve712_ventas_materiales
integer x = 1851
integer y = 160
integer width = 320
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

type gb_1 from groupbox within w_ve712_ventas_materiales
integer x = 37
integer y = 32
integer width = 1358
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

type gb_3 from groupbox within w_ve712_ventas_materiales
integer x = 1829
integer y = 32
integer width = 370
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reporte"
end type

type gb_2 from groupbox within w_ve712_ventas_materiales
integer x = 1426
integer y = 32
integer width = 370
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

