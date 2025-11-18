$PBExportHeader$w_cn967_costos_contables.srw
forward
global type w_cn967_costos_contables from w_abc
end type
type cb_procesar from commandbutton within w_cn967_costos_contables
end type
type em_mes from editmask within w_cn967_costos_contables
end type
type em_year from editmask within w_cn967_costos_contables
end type
type st_3 from statictext within w_cn967_costos_contables
end type
type st_2 from statictext within w_cn967_costos_contables
end type
type st_1 from statictext within w_cn967_costos_contables
end type
type tab_1 from tab within w_cn967_costos_contables
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tab_costo_hielo from tab within tabpage_3
end type
type tabpage_10 from userobject within tab_costo_hielo
end type
type dw_costo_hielo1 from u_dw_abc within tabpage_10
end type
type tabpage_10 from userobject within tab_costo_hielo
dw_costo_hielo1 dw_costo_hielo1
end type
type tabpage_11 from userobject within tab_costo_hielo
end type
type dw_consumo_hielo2 from u_dw_abc within tabpage_11
end type
type dw_consumo_hielo from u_dw_abc within tabpage_11
end type
type st_consumo_hielo from statictext within tabpage_11
end type
type st_produc_hielo from statictext within tabpage_11
end type
type dw_produc_hielo from u_dw_abc within tabpage_11
end type
type tabpage_11 from userobject within tab_costo_hielo
dw_consumo_hielo2 dw_consumo_hielo2
dw_consumo_hielo dw_consumo_hielo
st_consumo_hielo st_consumo_hielo
st_produc_hielo st_produc_hielo
dw_produc_hielo dw_produc_hielo
end type
type tabpage_13 from userobject within tab_costo_hielo
end type
type sle_cup_hielo from singlelineedit within tabpage_13
end type
type sle_otros_egre_hielo from singlelineedit within tabpage_13
end type
type sle_venta_hielo from singlelineedit within tabpage_13
end type
type sle_consumo_hielo from singlelineedit within tabpage_13
end type
type sle_otros_ingr_hielo from singlelineedit within tabpage_13
end type
type sle_prod_hielo from singlelineedit within tabpage_13
end type
type sle_total_costo_hielo from singlelineedit within tabpage_13
end type
type st_11 from statictext within tabpage_13
end type
type cb_3 from commandbutton within tabpage_13
end type
type cb_2 from commandbutton within tabpage_13
end type
type st_10 from statictext within tabpage_13
end type
type st_9 from statictext within tabpage_13
end type
type st_8 from statictext within tabpage_13
end type
type st_7 from statictext within tabpage_13
end type
type st_6 from statictext within tabpage_13
end type
type st_5 from statictext within tabpage_13
end type
type dw_elem_costo_hielo from u_dw_abc within tabpage_13
end type
type st_4 from statictext within tabpage_13
end type
type gb_1 from groupbox within tabpage_13
end type
type tabpage_13 from userobject within tab_costo_hielo
sle_cup_hielo sle_cup_hielo
sle_otros_egre_hielo sle_otros_egre_hielo
sle_venta_hielo sle_venta_hielo
sle_consumo_hielo sle_consumo_hielo
sle_otros_ingr_hielo sle_otros_ingr_hielo
sle_prod_hielo sle_prod_hielo
sle_total_costo_hielo sle_total_costo_hielo
st_11 st_11
cb_3 cb_3
cb_2 cb_2
st_10 st_10
st_9 st_9
st_8 st_8
st_7 st_7
st_6 st_6
st_5 st_5
dw_elem_costo_hielo dw_elem_costo_hielo
st_4 st_4
gb_1 gb_1
end type
type tab_costo_hielo from tab within tabpage_3
tabpage_10 tabpage_10
tabpage_11 tabpage_11
tabpage_13 tabpage_13
end type
type tabpage_3 from userobject within tab_1
tab_costo_hielo tab_costo_hielo
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tabpage_7 from userobject within tab_1
end type
type tabpage_7 from userobject within tab_1
end type
type tabpage_8 from userobject within tab_1
end type
type tabpage_8 from userobject within tab_1
end type
type tabpage_9 from userobject within tab_1
end type
type tab_2 from tab within tabpage_9
end type
type tabpage_12 from userobject within tab_2
end type
type cb_1 from commandbutton within tabpage_12
end type
type dw_rpt_71vs9x from u_dw_rpt within tabpage_12
end type
type tabpage_12 from userobject within tab_2
cb_1 cb_1
dw_rpt_71vs9x dw_rpt_71vs9x
end type
type tab_2 from tab within tabpage_9
tabpage_12 tabpage_12
end type
type tabpage_9 from userobject within tab_1
tab_2 tab_2
end type
type tab_1 from tab within w_cn967_costos_contables
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_9 tabpage_9
end type
end forward

global type w_cn967_costos_contables from w_abc
integer width = 4581
integer height = 2804
string title = "[CN967] Calculo de Costos Contables en PPTT"
string menuname = "m_prc"
event ue_refresh_data_hielo ( )
event ue_refresh_resumen ( )
cb_procesar cb_procesar
em_mes em_mes
em_year em_year
st_3 st_3
st_2 st_2
st_1 st_1
tab_1 tab_1
end type
global w_cn967_costos_contables w_cn967_costos_contables

type variables
//Costo de Hielo
u_dw_abc 		idw_costo_hielo1, idw_produc_hielo, idw_consumo_hielo, idw_elem_costo_hielo, idw_consumo_hielo2
SingleLineEdit isle_total_costo_hielo	, isle_prod_hielo			, isle_otros_ingr_hielo	, isle_consumo_hielo, &
					isle_venta_hielo			, isle_otros_egre_hielo	, isle_cup_hielo

//Parametros
uo_costo_prod lnvo_costo 

//Resumen
u_dw_rpt	idw_rpt_71vs9x

//Etiquetas
StaticText ist_produc_hielo, ist_consumo_hielo

end variables

forward prototypes
public subroutine of_asignar_dws ()
end prototypes

event ue_refresh_data_hielo();Integer li_year, li_mes


//Obtengo el año y mes
li_year = Integer(em_year.text)
li_mes  = Integer(em_mes.text)

idw_costo_hielo1.retrieve(li_year, li_mes, lnvo_costo.is_grp_costo, lnvo_costo.is_cencos_hielo)

idw_produc_hielo.Retrieve(li_year, li_mes, lnvo_costo.of_get_cod_hielo(), lnvo_costo.is_oper_ing_prod)
idw_consumo_hielo.Retrieve(li_year, li_mes, lnvo_costo.of_get_cod_hielo(), lnvo_costo.is_mov_cons_int)
end event

event ue_refresh_resumen();Integer li_year

li_year = Integer(em_year.text)

idw_rpt_71vs9x.Retrieve(li_year, lnvo_costo.is_grp_res01)
end event

public subroutine of_asignar_dws ();//Costo Hielo
idw_costo_hielo1 		= tab_1.tabpage_3.tab_costo_hielo.tabpage_10.dw_costo_hielo1
idw_produc_hielo 		= tab_1.tabpage_3.tab_costo_hielo.tabpage_11.dw_produc_hielo
idw_consumo_hielo 	= tab_1.tabpage_3.tab_costo_hielo.tabpage_11.dw_consumo_hielo
idw_consumo_hielo2 	= tab_1.tabpage_3.tab_costo_hielo.tabpage_11.dw_consumo_hielo2

idw_elem_costo_hielo 	= tab_1.tabpage_3.tab_costo_hielo.tabpage_13.dw_elem_costo_hielo
isle_total_costo_hielo 	= tab_1.tabpage_3.tab_costo_hielo.tabpage_13.sle_total_costo_hielo
isle_prod_hielo		 	= tab_1.tabpage_3.tab_costo_hielo.tabpage_13.sle_prod_hielo
isle_otros_ingr_hielo	= tab_1.tabpage_3.tab_costo_hielo.tabpage_13.sle_otros_ingr_hielo
isle_consumo_hielo		= tab_1.tabpage_3.tab_costo_hielo.tabpage_13.sle_consumo_hielo
isle_venta_hielo			= tab_1.tabpage_3.tab_costo_hielo.tabpage_13.sle_venta_hielo
isle_otros_egre_hielo	= tab_1.tabpage_3.tab_costo_hielo.tabpage_13.sle_otros_egre_hielo
isle_cup_hielo				= tab_1.tabpage_3.tab_costo_hielo.tabpage_13.sle_cup_hielo


//Resumen
idw_rpt_71vs9x 	= tab_1.tabpage_9.tab_2.tabpage_12.dw_rpt_71vs9x

//Etiquetas
ist_produc_hielo 	= tab_1.tabpage_3.tab_costo_hielo.tabpage_11.st_produc_hielo
ist_consumo_hielo = tab_1.tabpage_3.tab_costo_hielo.tabpage_11.st_consumo_hielo

end subroutine

on w_cn967_costos_contables.create
int iCurrent
call super::create
if this.MenuName = "m_prc" then this.MenuID = create m_prc
this.cb_procesar=create cb_procesar
this.em_mes=create em_mes
this.em_year=create em_year
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_procesar
this.Control[iCurrent+2]=this.em_mes
this.Control[iCurrent+3]=this.em_year
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.tab_1
end on

on w_cn967_costos_contables.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_procesar)
destroy(this.em_mes)
destroy(this.em_year)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.tab_1)
end on

event resize;call super::resize;of_asignar_dws()

tab_1.width  = newwidth  - tab_1.x - 20
tab_1.height = newheight - tab_1.y - 20

//TAb Costo hielo
tab_1.tabpage_3.tab_costo_hielo.width = tab_1.tabpage_3.width - tab_1.tabpage_3.tab_costo_hielo.x - 20
tab_1.tabpage_3.tab_costo_hielo.height = tab_1.tabpage_3.height - tab_1.tabpage_3.tab_costo_hielo.y - 20

idw_costo_hielo1.width = tab_1.tabpage_3.tab_costo_hielo.tabpage_10.width - idw_costo_hielo1.x - 20
idw_costo_hielo1.height = tab_1.tabpage_3.tab_costo_hielo.tabpage_10.height - idw_costo_hielo1.y - 20

//Tab de Producción y Consumo de Hielo
idw_produc_hielo.width = tab_1.tabpage_3.tab_costo_hielo.tabpage_11.width * 0.4 - idw_produc_hielo.x - 20
idw_produc_hielo.height = tab_1.tabpage_3.tab_costo_hielo.tabpage_11.height - idw_produc_hielo.y - 20

idw_consumo_hielo.x		= idw_produc_hielo.x + idw_produc_hielo.width + 10
idw_consumo_hielo.width = tab_1.tabpage_3.tab_costo_hielo.tabpage_11.width - idw_consumo_hielo.x - 20

idw_consumo_hielo2.x			= idw_produc_hielo.x + idw_produc_hielo.width + 10
idw_consumo_hielo2.width 	= tab_1.tabpage_3.tab_costo_hielo.tabpage_11.width - idw_consumo_hielo2.x - 20
idw_consumo_hielo2.height 	= tab_1.tabpage_3.tab_costo_hielo.tabpage_11.height - idw_consumo_hielo2.y - 20

ist_produc_hielo.x = idw_produc_hielo.x
ist_produc_hielo.width = idw_produc_hielo.width

ist_consumo_hielo.x = idw_consumo_hielo.x
ist_consumo_hielo.width = idw_consumo_hielo.width

//Tab de Proceso de Costeo de Hielo
idw_elem_costo_hielo.height = tab_1.tabpage_3.tab_costo_hielo.tabpage_13.height - idw_elem_costo_hielo.y - 20



//Tab resumen
tab_1.tabpage_9.tab_2.width = tab_1.width - tab_1.tabpage_9.tab_2.tabpage_12.x - 20
tab_1.tabpage_9.tab_2.height = tab_1.height - tab_1.tabpage_9.tab_2.tabpage_12.y - 20

idw_rpt_71vs9x.width = tab_1.tabpage_9.tab_2.tabpage_12.width - idw_rpt_71vs9x.x - 20
idw_rpt_71vs9x.height = tab_1.tabpage_9.tab_2.tabpage_12.height - idw_rpt_71vs9x.y - 20


end event

event ue_open_pre;call super::ue_open_pre;lnvo_costo = create uo_costo_prod

em_year.text = string(Date(gnvo_app.of_fecha_actual()), 'yyyy')
em_mes.text	 = String(Date(gnvo_app.of_fecha_actual( )), 'mm')

idw_costo_hielo1.setTransObject(SQLCA)
idw_rpt_71vs9x.setTransObject(SQLCA)
end event

event close;call super::close;destroy lnvo_costo
end event

type cb_procesar from commandbutton within w_cn967_costos_contables
integer x = 1115
integer y = 280
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;parent.event ue_refresh_data_hielo( )
parent.event ue_refresh_resumen( )
end event

type em_mes from editmask within w_cn967_costos_contables
integer x = 869
integer y = 288
integer width = 233
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

type em_year from editmask within w_cn967_costos_contables
integer x = 553
integer y = 288
integer width = 315
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

type st_3 from statictext within w_cn967_costos_contables
integer x = 233
integer y = 288
integer width = 297
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn967_costos_contables
integer x = 37
integer y = 140
integer width = 3090
integer height = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por favor revise la pestaña de requisitos para ver si todo esta ok, en tal caso si faltase algo por favor confirmelo antes de continuar el proceso de calculo de costos de producción"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn967_costos_contables
integer x = 37
integer width = 3090
integer height = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Esta Ventana permite relizar el proceso de calculo del costo contable de producción, se sugiere que previamente se hayan cerrado los almacenes de materiales e insumos, y se hayan generado los asientos respectivos."
boolean focusrectangle = false
end type

type tab_1 from tab within w_cn967_costos_contables
integer y = 420
integer width = 4462
integer height = 2148
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
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
tabpage_8 tabpage_8
tabpage_9 tabpage_9
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
this.tabpage_9=create tabpage_9
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7,&
this.tabpage_8,&
this.tabpage_9}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
destroy(this.tabpage_9)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4425
integer height = 2028
long backcolor = 79741120
string text = "Requisitos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4425
integer height = 2028
long backcolor = 79741120
string text = "Costos de Parada"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4425
integer height = 2028
long backcolor = 79741120
string text = "Producción de Hielo"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
tab_costo_hielo tab_costo_hielo
end type

on tabpage_3.create
this.tab_costo_hielo=create tab_costo_hielo
this.Control[]={this.tab_costo_hielo}
end on

on tabpage_3.destroy
destroy(this.tab_costo_hielo)
end on

type tab_costo_hielo from tab within tabpage_3
integer width = 4402
integer height = 1992
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_10 tabpage_10
tabpage_11 tabpage_11
tabpage_13 tabpage_13
end type

on tab_costo_hielo.create
this.tabpage_10=create tabpage_10
this.tabpage_11=create tabpage_11
this.tabpage_13=create tabpage_13
this.Control[]={this.tabpage_10,&
this.tabpage_11,&
this.tabpage_13}
end on

on tab_costo_hielo.destroy
destroy(this.tabpage_10)
destroy(this.tabpage_11)
destroy(this.tabpage_13)
end on

type tabpage_10 from userobject within tab_costo_hielo
integer x = 18
integer y = 104
integer width = 4366
integer height = 1872
long backcolor = 79741120
string text = "Requisitos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_costo_hielo1 dw_costo_hielo1
end type

on tabpage_10.create
this.dw_costo_hielo1=create dw_costo_hielo1
this.Control[]={this.dw_costo_hielo1}
end on

on tabpage_10.destroy
destroy(this.dw_costo_hielo1)
end on

type dw_costo_hielo1 from u_dw_abc within tabpage_10
integer width = 2939
integer height = 1464
integer taborder = 20
string dataobject = "d_rpt_costo_hielo1_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1	
end event

type tabpage_11 from userobject within tab_costo_hielo
integer x = 18
integer y = 104
integer width = 4366
integer height = 1872
long backcolor = 79741120
string text = "Producción / Consumos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_consumo_hielo2 dw_consumo_hielo2
dw_consumo_hielo dw_consumo_hielo
st_consumo_hielo st_consumo_hielo
st_produc_hielo st_produc_hielo
dw_produc_hielo dw_produc_hielo
end type

on tabpage_11.create
this.dw_consumo_hielo2=create dw_consumo_hielo2
this.dw_consumo_hielo=create dw_consumo_hielo
this.st_consumo_hielo=create st_consumo_hielo
this.st_produc_hielo=create st_produc_hielo
this.dw_produc_hielo=create dw_produc_hielo
this.Control[]={this.dw_consumo_hielo2,&
this.dw_consumo_hielo,&
this.st_consumo_hielo,&
this.st_produc_hielo,&
this.dw_produc_hielo}
end on

on tabpage_11.destroy
destroy(this.dw_consumo_hielo2)
destroy(this.dw_consumo_hielo)
destroy(this.st_consumo_hielo)
destroy(this.st_produc_hielo)
destroy(this.dw_produc_hielo)
end on

type dw_consumo_hielo2 from u_dw_abc within tabpage_11
integer x = 1390
integer y = 792
integer width = 1271
integer height = 668
integer taborder = 40
string dataobject = "d_salidas_hielo_crt"
end type

event constructor;call super::constructor;ii_ck[1] = 1	
end event

type dw_consumo_hielo from u_dw_abc within tabpage_11
integer x = 1394
integer y = 104
integer width = 1271
integer height = 668
integer taborder = 30
string dataobject = "d_rpt_consumo_articulo_tv"
end type

event constructor;call super::constructor;ii_ck[1] = 1	
end event

type st_consumo_hielo from statictext within tabpage_11
integer x = 1509
integer width = 1262
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Salidas de Hielo"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_produc_hielo from statictext within tabpage_11
integer width = 1262
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Ingreso por producción"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_produc_hielo from u_dw_abc within tabpage_11
integer y = 104
integer width = 1271
integer height = 1276
string dataobject = "d_list_produccion_x_art_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1	
end event

type tabpage_13 from userobject within tab_costo_hielo
integer x = 18
integer y = 104
integer width = 4366
integer height = 1872
long backcolor = 79741120
string text = "Proceso de Costeo del Hielo"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
sle_cup_hielo sle_cup_hielo
sle_otros_egre_hielo sle_otros_egre_hielo
sle_venta_hielo sle_venta_hielo
sle_consumo_hielo sle_consumo_hielo
sle_otros_ingr_hielo sle_otros_ingr_hielo
sle_prod_hielo sle_prod_hielo
sle_total_costo_hielo sle_total_costo_hielo
st_11 st_11
cb_3 cb_3
cb_2 cb_2
st_10 st_10
st_9 st_9
st_8 st_8
st_7 st_7
st_6 st_6
st_5 st_5
dw_elem_costo_hielo dw_elem_costo_hielo
st_4 st_4
gb_1 gb_1
end type

on tabpage_13.create
this.sle_cup_hielo=create sle_cup_hielo
this.sle_otros_egre_hielo=create sle_otros_egre_hielo
this.sle_venta_hielo=create sle_venta_hielo
this.sle_consumo_hielo=create sle_consumo_hielo
this.sle_otros_ingr_hielo=create sle_otros_ingr_hielo
this.sle_prod_hielo=create sle_prod_hielo
this.sle_total_costo_hielo=create sle_total_costo_hielo
this.st_11=create st_11
this.cb_3=create cb_3
this.cb_2=create cb_2
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.dw_elem_costo_hielo=create dw_elem_costo_hielo
this.st_4=create st_4
this.gb_1=create gb_1
this.Control[]={this.sle_cup_hielo,&
this.sle_otros_egre_hielo,&
this.sle_venta_hielo,&
this.sle_consumo_hielo,&
this.sle_otros_ingr_hielo,&
this.sle_prod_hielo,&
this.sle_total_costo_hielo,&
this.st_11,&
this.cb_3,&
this.cb_2,&
this.st_10,&
this.st_9,&
this.st_8,&
this.st_7,&
this.st_6,&
this.st_5,&
this.dw_elem_costo_hielo,&
this.st_4,&
this.gb_1}
end on

on tabpage_13.destroy
destroy(this.sle_cup_hielo)
destroy(this.sle_otros_egre_hielo)
destroy(this.sle_venta_hielo)
destroy(this.sle_consumo_hielo)
destroy(this.sle_otros_ingr_hielo)
destroy(this.sle_prod_hielo)
destroy(this.sle_total_costo_hielo)
destroy(this.st_11)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.dw_elem_costo_hielo)
destroy(this.st_4)
destroy(this.gb_1)
end on

type sle_cup_hielo from singlelineedit within tabpage_13
integer x = 3625
integer y = 724
integer width = 526
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_otros_egre_hielo from singlelineedit within tabpage_13
integer x = 3625
integer y = 620
integer width = 526
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_venta_hielo from singlelineedit within tabpage_13
integer x = 3625
integer y = 516
integer width = 526
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_consumo_hielo from singlelineedit within tabpage_13
integer x = 3625
integer y = 412
integer width = 526
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_otros_ingr_hielo from singlelineedit within tabpage_13
integer x = 3625
integer y = 308
integer width = 526
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_prod_hielo from singlelineedit within tabpage_13
integer x = 3625
integer y = 204
integer width = 526
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_total_costo_hielo from singlelineedit within tabpage_13
integer x = 3621
integer y = 100
integer width = 526
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_11 from statictext within tabpage_13
integer x = 2866
integer y = 724
integer width = 750
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Precio Promedio : "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_3 from commandbutton within tabpage_13
integer x = 3474
integer y = 920
integer width = 507
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refrescar Datos"
end type

event clicked;event ue_refresh_data_hielo( )
end event

type cb_2 from commandbutton within tabpage_13
integer x = 2976
integer y = 920
integer width = 489
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar Costo"
end type

event clicked;Integer 	li_year, li_mes
String	ls_msj

//Obtengo el año y mes
li_year = Integer(em_year.text)
li_mes  = Integer(em_mes.text)

// Generacion de asientos contables de devengado de planilla
//create or replace procedure up_costo_hielo(ani_year number, ani_mes number)
//) is
//

DECLARE up_costo_hielo PROCEDURE FOR 
	PKG_CNTBL_COSTO.up_costo_hielo ( :li_year,
								 				:li_mes ) ;

EXECUTE up_costo_hielo  ;

IF sqlca.sqlcode = -1 THEN
	ls_msj = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error PKG_CNTBL_COSTO.up_costo_hielo ', 'Se produjo un error al ejecutar el procedure PKG_CNTBL_COSTO.up_costo_hielo : ' + ls_msj, StopSign! )
	return
END IF

Close up_costo_hielo;

MessageBox( 'Mensaje', "Proceso de costeo de hielo terminado, por favor reprocese el DESCUADRE DE VALORIZACIÓN DE ALMACEN" )

idw_elem_costo_hielo.retrieve( )
end event

type st_10 from statictext within tabpage_13
integer x = 2866
integer y = 620
integer width = 750
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Otras Salidas : "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_9 from statictext within tabpage_13
integer x = 2866
integer y = 516
integer width = 750
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Salidas por Venta : "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_8 from statictext within tabpage_13
integer x = 2866
integer y = 412
integer width = 750
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Salidas por Consumo : "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_7 from statictext within tabpage_13
integer x = 2866
integer y = 308
integer width = 750
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Otros Ingresos : "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within tabpage_13
integer x = 2866
integer y = 204
integer width = 750
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Ingreso por producción : "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within tabpage_13
integer x = 2866
integer y = 100
integer width = 750
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Total Costo : "
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_elem_costo_hielo from u_dw_abc within tabpage_13
integer y = 104
integer width = 2784
integer height = 1636
integer taborder = 40
string dataobject = "d_rpt_consumo_articulo_tv"
end type

event constructor;call super::constructor;ii_ck[1] = 1	
end event

type st_4 from statictext within tabpage_13
integer width = 2784
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Elementos del costo"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type gb_1 from groupbox within tabpage_13
integer x = 2798
integer width = 1422
integer height = 1368
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Resumen y proceso de costeo"
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4425
integer height = 2028
long backcolor = 79741120
string text = "Costos de Extracción"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4425
integer height = 2028
long backcolor = 79741120
string text = "Costos de Congelado"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4425
integer height = 2028
long backcolor = 79741120
string text = "Costos de Harina"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4425
integer height = 2028
long backcolor = 79741120
string text = "Costos Comunes"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4425
integer height = 2028
long backcolor = 79741120
string text = "Costos por Tranformación"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_9 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4425
integer height = 2028
long backcolor = 79741120
string text = "Resumen"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
tab_2 tab_2
end type

on tabpage_9.create
this.tab_2=create tab_2
this.Control[]={this.tab_2}
end on

on tabpage_9.destroy
destroy(this.tab_2)
end on

type tab_2 from tab within tabpage_9
integer width = 3159
integer height = 1708
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_12 tabpage_12
end type

on tab_2.create
this.tabpage_12=create tabpage_12
this.Control[]={this.tabpage_12}
end on

on tab_2.destroy
destroy(this.tabpage_12)
end on

type tabpage_12 from userobject within tab_2
integer x = 18
integer y = 104
integer width = 3122
integer height = 1588
long backcolor = 79741120
string text = "Resumen 71 vs 9x (Costo)"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_1 cb_1
dw_rpt_71vs9x dw_rpt_71vs9x
end type

on tabpage_12.create
this.cb_1=create cb_1
this.dw_rpt_71vs9x=create dw_rpt_71vs9x
this.Control[]={this.cb_1,&
this.dw_rpt_71vs9x}
end on

on tabpage_12.destroy
destroy(this.cb_1)
destroy(this.dw_rpt_71vs9x)
end on

type cb_1 from commandbutton within tabpage_12
integer x = 5
integer y = 12
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refrescar"
end type

event clicked;event ue_refresh_resumen()
end event

type dw_rpt_71vs9x from u_dw_rpt within tabpage_12
integer y = 116
integer width = 3058
integer height = 1348
integer taborder = 20
string dataobject = "d_rpt_resumen_costo1_tbl"
end type

