$PBExportHeader$w_ve711_ventas_sub_productos.srw
forward
global type w_ve711_ventas_sub_productos from w_report_smpl
end type
type cb_aceptar from commandbutton within w_ve711_ventas_sub_productos
end type
type uo_1 from u_ingreso_rango_fechas within w_ve711_ventas_sub_productos
end type
type gb_1 from groupbox within w_ve711_ventas_sub_productos
end type
end forward

global type w_ve711_ventas_sub_productos from w_report_smpl
integer width = 1861
integer height = 1488
string title = "[VE710] Ventas Generales de Sub - Productos"
string menuname = "m_reporte"
long backcolor = 67108864
cb_aceptar cb_aceptar
uo_1 uo_1
gb_1 gb_1
end type
global w_ve711_ventas_sub_productos w_ve711_ventas_sub_productos

type variables
string is_canal, is_sub_canal, is_zona, is_distrito, is_desc_distrito, &
		 is_pais, is_dpto, is_prov, is_flag_opc, is_desc_opc, is_categ, is_serie
date id_fec_ini, id_fec_fin
end variables

on w_ve711_ventas_sub_productos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_aceptar=create cb_aceptar
this.uo_1=create uo_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_aceptar
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_ve711_ventas_sub_productos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_aceptar)
destroy(this.uo_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;date ld_fec_ini, ld_fec_fin

id_fec_ini = uo_1.of_get_fecha1( )
id_fec_fin = uo_1.of_get_fecha2( )

dw_report.settransobject( sqlca )
dw_report.retrieve( id_fec_ini, id_fec_fin, gs_empresa, gs_user )
dw_report.object.p_logo.filename = gs_logo


ib_preview = false
this.event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_ve711_ventas_sub_productos
integer x = 37
integer y = 256
integer width = 1723
integer height = 964
string dataobject = "d_rpt_ventas_sub_productos"
integer ii_zoom_actual = 100
end type

type cb_aceptar from commandbutton within w_ve711_ventas_sub_productos
integer x = 1426
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

type uo_1 from u_ingreso_rango_fechas within w_ve711_ventas_sub_productos
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

type gb_1 from groupbox within w_ve711_ventas_sub_productos
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

