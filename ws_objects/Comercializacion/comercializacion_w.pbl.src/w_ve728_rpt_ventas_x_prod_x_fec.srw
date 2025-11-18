$PBExportHeader$w_ve728_rpt_ventas_x_prod_x_fec.srw
forward
global type w_ve728_rpt_ventas_x_prod_x_fec from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_ve728_rpt_ventas_x_prod_x_fec
end type
type cb_3 from commandbutton within w_ve728_rpt_ventas_x_prod_x_fec
end type
type dw_report from u_dw_rpt within w_ve728_rpt_ventas_x_prod_x_fec
end type
type cb_1 from commandbutton within w_ve728_rpt_ventas_x_prod_x_fec
end type
type gb_1 from groupbox within w_ve728_rpt_ventas_x_prod_x_fec
end type
end forward

global type w_ve728_rpt_ventas_x_prod_x_fec from w_rpt
integer width = 3589
integer height = 1504
string title = "[VE728] Reporte de Variación x Fechas"
string menuname = "m_reporte"
long backcolor = 12632256
uo_1 uo_1
cb_3 cb_3
dw_report dw_report
cb_1 cb_1
gb_1 gb_1
end type
global w_ve728_rpt_ventas_x_prod_x_fec w_ve728_rpt_ventas_x_prod_x_fec

type variables
str_seleccionar istr_seleccionar
end variables

on w_ve728_rpt_ventas_x_prod_x_fec.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cb_3=create cb_3
this.dw_report=create dw_report
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.gb_1
end on

on w_ve728_rpt_ventas_x_prod_x_fec.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()
//
//
// ii_help = 101           // help topic


end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type uo_1 from u_ingreso_rango_fechas within w_ve728_rpt_ventas_x_prod_x_fec
integer x = 73
integer y = 96
integer taborder = 50
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
//of_set_fecha(date('01/01/1900'), date('31/12/9999') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cb_3 from commandbutton within w_ve728_rpt_ventas_x_prod_x_fec
integer x = 3026
integer y = 16
integer width = 494
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Grupo de Articulos "
end type

event clicked;Long ll_count
str_parametros sl_param 


delete from tt_fin_rpt_art ;

sl_param.dw1		= 'd_abc_lista_grupo_art_tbl'
sl_param.titulo	= 'Grupo de Articulo'
sl_param.opcion   = 18
sl_param.db1 		= 1100
sl_param.string1 	= '1GAR'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type dw_report from u_dw_rpt within w_ve728_rpt_ventas_x_prod_x_fec
integer x = 23
integer y = 408
integer width = 3511
integer height = 844
integer taborder = 120
string dataobject = "d_rpt_venta_x_variacion_precio_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_ve728_rpt_ventas_x_prod_x_fec
integer x = 3026
integer y = 136
integer width = 494
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;Date   ld_fecha_inicio,ld_fecha_final


ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()



SetPointer(hourglass!)

dw_report.Retrieve(String(ld_fecha_inicio,'yyyymmdd'),String(ld_fecha_final,'yyyymmdd'),gs_empresa,gs_user)
dw_report.Object.p_logo.filename = gs_logo

rollback ;

SetPointer(Arrow!)

end event

type gb_1 from groupbox within w_ve728_rpt_ventas_x_prod_x_fec
integer x = 37
integer y = 32
integer width = 1353
integer height = 192
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

