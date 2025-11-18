$PBExportHeader$w_ve749_reporte_gerencial_vehiculos.srw
forward
global type w_ve749_reporte_gerencial_vehiculos from w_rpt
end type
type tab_1 from tab within w_ve749_reporte_gerencial_vehiculos
end type
type tabpage_1 from userobject within tab_1
end type
type dw_reporte1 from u_dw_rpt within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_reporte1 dw_reporte1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_reporte2 from u_dw_rpt within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_reporte2 dw_reporte2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_reporte3 from u_dw_rpt within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_reporte3 dw_reporte3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_reporte4 from u_dw_rpt within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_reporte4 dw_reporte4
end type
type tabpage_5 from userobject within tab_1
end type
type dw_reporte5 from u_dw_rpt within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_reporte5 dw_reporte5
end type
type tabpage_6 from userobject within tab_1
end type
type dw_reporte6 from u_dw_rpt within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_reporte6 dw_reporte6
end type
type tabpage_7 from userobject within tab_1
end type
type dw_reporte7 from u_dw_rpt within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_reporte7 dw_reporte7
end type
type tab_1 from tab within w_ve749_reporte_gerencial_vehiculos
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type
type uo_fechas from u_ingreso_rango_fechas within w_ve749_reporte_gerencial_vehiculos
end type
type cb_aceptar from commandbutton within w_ve749_reporte_gerencial_vehiculos
end type
type gb_1 from groupbox within w_ve749_reporte_gerencial_vehiculos
end type
end forward

global type w_ve749_reporte_gerencial_vehiculos from w_rpt
integer width = 3767
integer height = 2224
string title = "[VE749] Reporte Gerencial de vehiculos"
string menuname = "m_impresion"
tab_1 tab_1
uo_fechas uo_fechas
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_ve749_reporte_gerencial_vehiculos w_ve749_reporte_gerencial_vehiculos

type variables
u_dw_rpt 	idw_reporte1, idw_reporte2, idw_reporte3, idw_reporte4, idw_reporte5, &
				idw_reporte6, idw_reporte7
String		is_clase_eq_fuerza

end variables

forward prototypes
public subroutine of_asigna_dws ()
end prototypes

public subroutine of_asigna_dws ();idw_reporte1 = tab_1.tabpage_1.dw_reporte1
idw_reporte2 = tab_1.tabpage_2.dw_reporte2
idw_reporte3 = tab_1.tabpage_3.dw_reporte3
idw_reporte4 = tab_1.tabpage_4.dw_reporte4
idw_reporte5 = tab_1.tabpage_5.dw_reporte5
idw_reporte6 = tab_1.tabpage_6.dw_reporte6
idw_reporte7 = tab_1.tabpage_7.dw_reporte7
end subroutine

on w_ve749_reporte_gerencial_vehiculos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.tab_1=create tab_1
this.uo_fechas=create uo_fechas
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.cb_aceptar
this.Control[iCurrent+4]=this.gb_1
end on

on w_ve749_reporte_gerencial_vehiculos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.uo_fechas)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;try 
	of_asigna_dws()
	
	idw_reporte1.setTransObject(SQLCA)
	idw_reporte2.setTransObject(SQLCA)
	idw_reporte3.setTransObject(SQLCA)
	idw_reporte4.setTransObject(SQLCA)
	idw_reporte5.setTransObject(SQLCA)
	idw_reporte6.setTransObject(SQLCA)
	idw_reporte7.setTransObject(SQLCA)
	
	idw_1 = idw_reporte1
	idw_1.BorderStyle 	= StyleLowered!
	
	//Cargando las clases por defecto
	is_clase_eq_fuerza = gnvo_app.of_get_parametro('CLASE_EQUIPOS_DE_FUERZA', '12')

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')

end try


end event

event ue_retrieve;call super::ue_retrieve;date 	ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()

//Reporte 1
yield()
idw_reporte1.Retrieve(ld_fecha1, ld_Fecha2)

idw_reporte1.Object.p_logo.filename = gs_logo
idw_reporte1.Object.t_empresa.text 	= gs_empresa
idw_reporte1.Object.t_ventana.text 	= 'd_rpt_ventas_diversas1_tbl'
idw_reporte1.Object.t_user.text 		= gs_user
yield()

//Reporte 2
yield()
idw_reporte2.Retrieve(ld_fecha1, ld_Fecha2)

idw_reporte2.Object.p_logo.filename = gs_logo
idw_reporte2.Object.t_empresa.text 	= gs_empresa
idw_reporte2.Object.t_ventana.text 	= 'd_rpt_ventas_diversas2_tbl'
idw_reporte2.Object.t_user.text 		= gs_user
yield()

//Reporte 3
yield()
idw_reporte3.Retrieve(ld_fecha1, ld_Fecha2)

idw_reporte3.Object.p_logo.filename = gs_logo
idw_reporte3.Object.t_empresa.text 	= gs_empresa
idw_reporte3.Object.t_ventana.text 	= 'd_rpt_ventas_diversas3_tbl'
idw_reporte3.Object.t_user.text 		= gs_user
yield()

//Reporte 4
yield()
idw_reporte4.Retrieve(ld_fecha1, ld_Fecha2, is_clase_eq_fuerza)

idw_reporte4.Object.p_logo.filename = gs_logo
idw_reporte4.Object.t_empresa.text 	= gs_empresa
idw_reporte4.Object.t_ventana.text 	= 'd_rpt_ventas_diversas4_tbl'
idw_reporte4.Object.t_user.text 		= gs_user
yield()

//Reporte 5
yield()
idw_reporte5.Retrieve(ld_fecha1, ld_Fecha2)

idw_reporte5.Object.p_logo.filename = gs_logo
idw_reporte5.Object.t_empresa.text 	= gs_empresa
idw_reporte5.Object.t_ventana.text 	= 'd_rpt_ventas_diversas4_tbl'
idw_reporte5.Object.t_user.text 		= gs_user
yield()


//Reporte por defecto
idw_1 = idw_reporte1
idw_1.BorderStyle 	= StyleLowered!
tab_1.SelectedTab = 1

end event

event resize;call super::resize;of_asigna_dws()

tab_1.width = newwidth - tab_1.x
tab_1.height = newheight - tab_1.y

idw_reporte1.width 	= tab_1.tabpage_1.width - idw_reporte1.x
idw_reporte1.height 	= tab_1.tabpage_1.height - idw_reporte1.y

idw_reporte2.width 	= tab_1.tabpage_2.width - idw_reporte2.x
idw_reporte2.height 	= tab_1.tabpage_2.height - idw_reporte2.y

idw_reporte3.width 	= tab_1.tabpage_3.width - idw_reporte3.x
idw_reporte3.height 	= tab_1.tabpage_3.height - idw_reporte3.y

idw_reporte4.width 	= tab_1.tabpage_4.width - idw_reporte4.x
idw_reporte4.height 	= tab_1.tabpage_4.height - idw_reporte4.y

idw_reporte5.width 	= tab_1.tabpage_5.width - idw_reporte5.x
idw_reporte5.height 	= tab_1.tabpage_5.height - idw_reporte5.y

idw_reporte6.width 	= tab_1.tabpage_6.width - idw_reporte6.x
idw_reporte6.height 	= tab_1.tabpage_6.height - idw_reporte6.y

idw_reporte7.width 	= tab_1.tabpage_7.width - idw_reporte7.x
idw_reporte7.height 	= tab_1.tabpage_7.height - idw_reporte7.y

end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type tab_1 from tab within w_ve749_reporte_gerencial_vehiculos
string tag = "d_rpt_resumen_gerencial_f8_tbl"
integer y = 212
integer width = 3529
integer height = 1784
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3493
integer height = 1664
long backcolor = 67108864
string text = "RESUMEN GENERAL DE VENTAS"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_reporte1 dw_reporte1
end type

on tabpage_1.create
this.dw_reporte1=create dw_reporte1
this.Control[]={this.dw_reporte1}
end on

on tabpage_1.destroy
destroy(this.dw_reporte1)
end on

type dw_reporte1 from u_dw_rpt within tabpage_1
integer width = 3077
integer height = 1432
integer taborder = 100
string dataobject = "d_rpt_resumen_gerencial_cmp"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle 	= StyleRaised!
idw_1 					= THIS
idw_1.BorderStyle 	= StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3493
integer height = 1664
long backcolor = 67108864
string text = "DETALLE DE VENTA DE REPUESTOS"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_reporte2 dw_reporte2
end type

on tabpage_2.create
this.dw_reporte2=create dw_reporte2
this.Control[]={this.dw_reporte2}
end on

on tabpage_2.destroy
destroy(this.dw_reporte2)
end on

type dw_reporte2 from u_dw_rpt within tabpage_2
integer width = 3077
integer height = 1432
string dataobject = "d_rpt_resumen_gerencial_f5_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle 	= StyleRaised!
idw_1 					= THIS
idw_1.BorderStyle 	= StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3493
integer height = 1664
long backcolor = 67108864
string text = "DETALLE DE VENTAS DE VEHICULOS"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_reporte3 dw_reporte3
end type

on tabpage_3.create
this.dw_reporte3=create dw_reporte3
this.Control[]={this.dw_reporte3}
end on

on tabpage_3.destroy
destroy(this.dw_reporte3)
end on

type dw_reporte3 from u_dw_rpt within tabpage_3
integer width = 3077
integer height = 1432
string dataobject = "d_rpt_resumen_gerencial_f6_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle 	= StyleRaised!
idw_1 					= THIS
idw_1.BorderStyle 	= StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3493
integer height = 1664
long backcolor = 67108864
string text = "DETALLE VENTAS EQUIPOS DE FUERZA"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_reporte4 dw_reporte4
end type

on tabpage_4.create
this.dw_reporte4=create dw_reporte4
this.Control[]={this.dw_reporte4}
end on

on tabpage_4.destroy
destroy(this.dw_reporte4)
end on

type dw_reporte4 from u_dw_rpt within tabpage_4
integer width = 3077
integer height = 1432
string dataobject = "d_rpt_resumen_gerencial_f7_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle 	= StyleRaised!
idw_1 					= THIS
idw_1.BorderStyle 	= StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3493
integer height = 1664
long backcolor = 67108864
string text = "DETALLE VENTA MOTORES FUERA DE BORDA"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_reporte5 dw_reporte5
end type

on tabpage_5.create
this.dw_reporte5=create dw_reporte5
this.Control[]={this.dw_reporte5}
end on

on tabpage_5.destroy
destroy(this.dw_reporte5)
end on

type dw_reporte5 from u_dw_rpt within tabpage_5
integer width = 3077
integer height = 1432
string dataobject = "d_rpt_resumen_gerencial_f8_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle 	= StyleRaised!
idw_1 					= THIS
idw_1.BorderStyle 	= StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3493
integer height = 1664
long backcolor = 67108864
string text = "REPORTE DE CUENTAS POR COBRAR"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_reporte6 dw_reporte6
end type

on tabpage_6.create
this.dw_reporte6=create dw_reporte6
this.Control[]={this.dw_reporte6}
end on

on tabpage_6.destroy
destroy(this.dw_reporte6)
end on

type dw_reporte6 from u_dw_rpt within tabpage_6
integer width = 3077
integer height = 1432
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle 	= StyleRaised!
idw_1 					= THIS
idw_1.BorderStyle 	= StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3493
integer height = 1664
long backcolor = 67108864
string text = "REPORTE DIARIO DE VENTAS"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_reporte7 dw_reporte7
end type

on tabpage_7.create
this.dw_reporte7=create dw_reporte7
this.Control[]={this.dw_reporte7}
end on

on tabpage_7.destroy
destroy(this.dw_reporte7)
end on

type dw_reporte7 from u_dw_rpt within tabpage_7
integer width = 3077
integer height = 1432
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle 	= StyleRaised!
idw_1 					= THIS
idw_1.BorderStyle 	= StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type uo_fechas from u_ingreso_rango_fechas within w_ve749_reporte_gerencial_vehiculos
event destroy ( )
integer x = 27
integer y = 68
integer height = 80
integer taborder = 80
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Del:','Al:') 								//	para setear la fecha inicial
of_set_fecha(date(relativedate(today(),-1)), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_aceptar from commandbutton within w_ve749_reporte_gerencial_vehiculos
integer x = 1381
integer width = 352
integer height = 196
integer taborder = 10
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

type gb_1 from groupbox within w_ve749_reporte_gerencial_vehiculos
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

