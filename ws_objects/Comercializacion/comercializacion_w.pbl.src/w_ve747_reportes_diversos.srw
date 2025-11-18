$PBExportHeader$w_ve747_reportes_diversos.srw
forward
global type w_ve747_reportes_diversos from w_rpt
end type
type sle_origen from singlelineedit within w_ve747_reportes_diversos
end type
type cb_3 from commandbutton within w_ve747_reportes_diversos
end type
type cbx_origenes from checkbox within w_ve747_reportes_diversos
end type
type st_3 from statictext within w_ve747_reportes_diversos
end type
type tab_1 from tab within w_ve747_reportes_diversos
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
type tabpage_5 from userobject within tab_1
end type
type dw_reporte5 from u_dw_rpt within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_reporte5 dw_reporte5
end type
type tabpage_8 from userobject within tab_1
end type
type dw_reporte8 from u_dw_rpt within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_reporte8 dw_reporte8
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
type tabpage_4 from userobject within tab_1
end type
type dw_reporte4 from u_dw_rpt within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_reporte4 dw_reporte4
end type
type tab_1 from tab within w_ve747_reportes_diversos
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_5 tabpage_5
tabpage_8 tabpage_8
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_4 tabpage_4
end type
type uo_fechas from u_ingreso_rango_fechas within w_ve747_reportes_diversos
end type
type cb_aceptar from commandbutton within w_ve747_reportes_diversos
end type
type gb_1 from groupbox within w_ve747_reportes_diversos
end type
end forward

global type w_ve747_reportes_diversos from w_rpt
integer width = 3767
integer height = 2224
string title = "[VE747] Reportes de Facturacion Simplificada"
string menuname = "m_impresion"
sle_origen sle_origen
cb_3 cb_3
cbx_origenes cbx_origenes
st_3 st_3
tab_1 tab_1
uo_fechas uo_fechas
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_ve747_reportes_diversos w_ve747_reportes_diversos

type variables
u_dw_rpt 	idw_reporte1, idw_reporte2, idw_reporte3, idw_reporte4, idw_reporte5, &
				idw_reporte6, idw_reporte7, idw_reporte8

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
idw_reporte8 = tab_1.tabpage_8.dw_reporte8
end subroutine

on w_ve747_reportes_diversos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_origen=create sle_origen
this.cb_3=create cb_3
this.cbx_origenes=create cbx_origenes
this.st_3=create st_3
this.tab_1=create tab_1
this.uo_fechas=create uo_fechas
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_origen
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cbx_origenes
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.tab_1
this.Control[iCurrent+6]=this.uo_fechas
this.Control[iCurrent+7]=this.cb_aceptar
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve747_reportes_diversos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_origen)
destroy(this.cb_3)
destroy(this.cbx_origenes)
destroy(this.st_3)
destroy(this.tab_1)
destroy(this.uo_fechas)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

idw_reporte1.setTransObject(SQLCA)
idw_reporte2.setTransObject(SQLCA)
idw_reporte3.setTransObject(SQLCA)
idw_reporte4.setTransObject(SQLCA)
idw_reporte5.setTransObject(SQLCA)
idw_reporte6.setTransObject(SQLCA)
idw_reporte7.setTransObject(SQLCA)
idw_reporte8.setTransObject(SQLCA)

 string ls_origenalt , ls_tipoorigen
 string ls_o
 
 select flag_origen, origen_alt 
 into  :ls_tipoorigen, :ls_origenalt
 from usuario 
 where cod_usr = :gs_user;
 
 if ls_tipoorigen = 'A' then
 	sle_origen.text = ls_origenalt
	cb_3.enabled=false
	cbx_origenes.checked = false
end if;

idw_1 = idw_reporte1
idw_1.BorderStyle 	= StyleLowered!
end event

event ue_retrieve;call super::ue_retrieve;date 	ld_fecha1, ld_fecha2
string ls_origen

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()
if cbx_origenes.checked  then
	ls_origen = '%'
else
	ls_origen =sle_origen.text
end if

//Reporte 1
yield()
idw_reporte1.Retrieve(ld_fecha1, ld_Fecha2, ls_origen)

idw_reporte1.Object.p_logo.filename = gs_logo
idw_reporte1.Object.t_empresa.text 	= gs_empresa
idw_reporte1.Object.t_ventana.text 	= 'd_rpt_ventas_diversas1_tbl'
idw_reporte1.Object.t_user.text 		= gs_user
yield()

//Reporte 2
yield()
idw_reporte2.Retrieve(ld_fecha1, ld_Fecha2, ls_origen)

idw_reporte2.Object.p_logo.filename = gs_logo
idw_reporte2.Object.t_empresa.text 	= gs_empresa
idw_reporte2.Object.t_ventana.text 	= 'd_rpt_ventas_diversas2_tbl'
idw_reporte2.Object.t_user.text 		= gs_user
yield()

//Reporte 3
yield()
idw_reporte3.Retrieve(ld_fecha1, ld_Fecha2, ls_origen)

idw_reporte3.Object.p_logo.filename = gs_logo
idw_reporte3.Object.t_empresa.text 	= gs_empresa
idw_reporte3.Object.t_ventana.text 	= 'd_rpt_ventas_diversas3_tbl'
idw_reporte3.Object.t_user.text 		= gs_user
yield()

//Reporte 4
/*yield()
idw_reporte4.Retrieve(ld_fecha1, ld_Fecha2)

idw_reporte4.Object.p_logo.filename = gs_logo
idw_reporte4.Object.t_empresa.text 	= gs_empresa
idw_reporte4.Object.t_ventana.text 	= 'd_rpt_ventas_diversas4_tbl'
idw_reporte4.Object.t_user.text 		= gs_user
yield()
*/
//Reporte 5
yield()
idw_reporte5.Retrieve(ld_fecha1, ld_Fecha2, ls_origen)

idw_reporte5.Object.p_logo.filename = gs_logo
idw_reporte5.Object.t_empresa.text 	= gs_empresa
idw_reporte5.Object.t_ventana.text 	= 'd_rpt_ventas_diversas5_tbl'
idw_reporte5.Object.t_user.text 		= gs_user
yield()

//Reporte 6
/*
yield()
idw_reporte6.Retrieve(ld_fecha1, ld_Fecha2)

idw_reporte6.Object.p_logo.filename = gs_logo
idw_reporte6.Object.t_empresa.text 	= gs_empresa
idw_reporte6.Object.t_ventana.text 	= 'd_rpt_ventas_diversas6_tbl'
idw_reporte6.Object.t_user.text 		= gs_user
yield()

//Reporte 7
yield()
idw_reporte7.Retrieve(ld_fecha1, ld_Fecha2)

idw_reporte7.Object.p_logo.filename = gs_logo
idw_reporte7.Object.t_empresa.text 	= gs_empresa
idw_reporte7.Object.t_ventana.text 	= 'd_rpt_ventas_diversas7_tbl'
idw_reporte7.Object.t_user.text 		= gs_user
yield()
*/
//Reporte 8
yield()
idw_reporte8.Retrieve(ld_fecha1, ld_Fecha2, ls_origen)

idw_reporte8.Object.p_logo.filename = gs_logo
idw_reporte8.Object.t_empresa.text 	= gs_empresa
idw_reporte8.Object.t_ventana.text 	= 'd_rpt_ventas_diversas8_tbl'
idw_reporte8.Object.t_user.text 		= gs_user
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

idw_reporte8.width 	= tab_1.tabpage_8.width - idw_reporte8.x
idw_reporte8.height 	= tab_1.tabpage_8.height - idw_reporte8.y

end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type sle_origen from singlelineedit within w_ve747_reportes_diversos
integer x = 306
integer y = 144
integer width = 343
integer height = 76
integer taborder = 90
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

type cb_3 from commandbutton within w_ve747_reportes_diversos
integer x = 686
integer y = 148
integer width = 114
integer height = 80
integer taborder = 90
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

ls_sql = "SELECT COD_ORIGEN AS CODIGO_ORIGEN, " &
		  + "NOMBRE AS NOMBRE_ORIGEN " &
		  + "FROM ORIGEN " 
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	sle_origen.text		= ls_codigo
end if
end event

type cbx_origenes from checkbox within w_ve747_reportes_diversos
integer x = 846
integer y = 156
integer width = 645
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_origen.Enabled 	= FALSE
	sle_origen.Text	  	= '%'
	cb_3.enabled 			= false
else
	sle_origen.Enabled = TRUE
	sle_origen.Text	  = ''
	cb_3.enabled 			= true
end if
end event

type st_3 from statictext within w_ve747_reportes_diversos
integer x = 41
integer y = 156
integer width = 215
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ORIGEN :"
boolean focusrectangle = false
end type

type tab_1 from tab within w_ve747_reportes_diversos
integer y = 268
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
tabpage_5 tabpage_5
tabpage_8 tabpage_8
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_5=create tabpage_5
this.tabpage_8=create tabpage_8
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_5,&
this.tabpage_8,&
this.tabpage_6,&
this.tabpage_7,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_5)
destroy(this.tabpage_8)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3493
integer height = 1664
long backcolor = 67108864
string text = "REPORTE VENTAS POR VENDEDOR"
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
string dataobject = "d_rpt_ventas_diversas1_tbl"
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
string text = "DETALLE DE VENTAS"
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
string dataobject = "d_rpt_ventas_diversas2_tbl"
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
string text = "REPORTE VENTAS POR DIFERENCIA DE PRECIO"
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
string dataobject = "d_rpt_ventas_diversas3_tbl"
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
string text = "REPORTE COMPARATIVO VENTAS CON EL AÑO ANTERIOR"
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
string dataobject = "d_rpt_ventas_diversas5_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle 	= StyleRaised!
idw_1 					= THIS
idw_1.BorderStyle 	= StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3493
integer height = 1664
long backcolor = 67108864
string text = "REPORTE DE RESUMEN DE DOCUMENTOS"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_reporte8 dw_reporte8
end type

on tabpage_8.create
this.dw_reporte8=create dw_reporte8
this.Control[]={this.dw_reporte8}
end on

on tabpage_8.destroy
destroy(this.dw_reporte8)
end on

type dw_reporte8 from u_dw_rpt within tabpage_8
integer width = 3077
integer height = 1432
string dataobject = "d_rpt_ventas_diversas8_tbl"
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
string dataobject = "d_rpt_ventas_diversas6_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle 	= StyleRaised!
idw_1 					= THIS
idw_1.BorderStyle 	= StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type tabpage_7 from userobject within tab_1
boolean visible = false
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
string dataobject = "d_rpt_ventas_diversas7_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle 	= StyleRaised!
idw_1 					= THIS
idw_1.BorderStyle 	= StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type tabpage_4 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 104
integer width = 3493
integer height = 1664
long backcolor = 67108864
string text = "RESUMEN DE FACTURACION SIMPLIFICADA"
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
string dataobject = "d_rpt_ventas_diversas4_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle 	= StyleRaised!
idw_1 					= THIS
idw_1.BorderStyle 	= StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type uo_fechas from u_ingreso_rango_fechas within w_ve747_reportes_diversos
event destroy ( )
integer x = 37
integer y = 52
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

type cb_aceptar from commandbutton within w_ve747_reportes_diversos
integer x = 2098
integer y = 28
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

type gb_1 from groupbox within w_ve747_reportes_diversos
integer width = 2071
integer height = 252
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

