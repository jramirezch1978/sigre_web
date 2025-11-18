$PBExportHeader$w_pt715_comparativo_cp.srw
forward
global type w_pt715_comparativo_cp from w_rpt_list
end type
type cb_3 from commandbutton within w_pt715_comparativo_cp
end type
type em_ano from editmask within w_pt715_comparativo_cp
end type
type dw_3 from u_dw_abc within w_pt715_comparativo_cp
end type
type dw_4 from u_dw_abc within w_pt715_comparativo_cp
end type
type pb_3 from pb_1 within w_pt715_comparativo_cp
end type
type pb_4 from pb_2 within w_pt715_comparativo_cp
end type
type st_2 from statictext within w_pt715_comparativo_cp
end type
type ddlb_nivelcp from dropdownlistbox within w_pt715_comparativo_cp
end type
type st_1 from statictext within w_pt715_comparativo_cp
end type
type st_3 from statictext within w_pt715_comparativo_cp
end type
type ddlb_del from dropdownlistbox within w_pt715_comparativo_cp
end type
type ddlb_al from dropdownlistbox within w_pt715_comparativo_cp
end type
type st_4 from statictext within w_pt715_comparativo_cp
end type
type gb_3 from groupbox within w_pt715_comparativo_cp
end type
type gb_5 from groupbox within w_pt715_comparativo_cp
end type
end forward

global type w_pt715_comparativo_cp from w_rpt_list
integer width = 3547
integer height = 2176
string title = "Comparativos"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
cb_3 cb_3
em_ano em_ano
dw_3 dw_3
dw_4 dw_4
pb_3 pb_3
pb_4 pb_4
st_2 st_2
ddlb_nivelcp ddlb_nivelcp
st_1 st_1
st_3 st_3
ddlb_del ddlb_del
ddlb_al ddlb_al
st_4 st_4
gb_3 gb_3
gb_5 gb_5
end type
global w_pt715_comparativo_cp w_pt715_comparativo_cp

type variables
String is_almacen, is_col = '', is_type
Integer ii_nivel_cp, ii_delmes, ii_almes


end variables

on w_pt715_comparativo_cp.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_ano=create em_ano
this.dw_3=create dw_3
this.dw_4=create dw_4
this.pb_3=create pb_3
this.pb_4=create pb_4
this.st_2=create st_2
this.ddlb_nivelcp=create ddlb_nivelcp
this.st_1=create st_1
this.st_3=create st_3
this.ddlb_del=create ddlb_del
this.ddlb_al=create ddlb_al
this.st_4=create st_4
this.gb_3=create gb_3
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.dw_4
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.pb_4
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.ddlb_nivelcp
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.ddlb_del
this.Control[iCurrent+12]=this.ddlb_al
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.gb_5
end on

on w_pt715_comparativo_cp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_ano)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.st_2)
destroy(this.ddlb_nivelcp)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.ddlb_del)
destroy(this.ddlb_al)
destroy(this.st_4)
destroy(this.gb_3)
destroy(this.gb_5)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

//dw_1.height = newheight - dw_1.y
//dw_2.height = newheight - dw_2.y
end event

event ue_open_pre();call super::ue_open_pre;dw_1.retrieve()
end event

type dw_report from w_rpt_list`dw_report within w_pt715_comparativo_cp
boolean visible = false
integer x = 27
integer y = 228
integer width = 3319
integer height = 1960
integer taborder = 30
string dataobject = "d_rpt_comparativo"
end type

type dw_1 from w_rpt_list`dw_1 within w_pt715_comparativo_cp
integer x = 23
integer y = 224
integer width = 1669
integer height = 796
integer taborder = 100
boolean titlebar = true
string title = "Centro de costos"
string dataobject = "d_sel_centro_costo_niv4_2"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;this.SettransObject( sqlca)
ii_ck[1] = 1 
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6
end event

type pb_1 from w_rpt_list`pb_1 within w_pt715_comparativo_cp
integer x = 1733
integer y = 488
integer taborder = 110
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type pb_2 from w_rpt_list`pb_2 within w_pt715_comparativo_cp
integer x = 1737
integer y = 628
integer taborder = 130
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_pt715_comparativo_cp
integer x = 1915
integer y = 224
integer width = 1669
integer height = 796
integer taborder = 120
boolean titlebar = true
string dataobject = "d_sel_centro_costo_niv4_2"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;this.SettransObject( sqlca)

ii_ck[1] = 1 
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6
end event

type cb_report from w_rpt_list`cb_report within w_pt715_comparativo_cp
integer x = 3095
integer y = 120
integer width = 334
integer height = 84
integer taborder = 80
integer textsize = -9
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;Long ll_ano, ll_row, ll_row2
String ls_niv1, ls_niv2, ls_niv3, ls_cnta1, ls_cnta2, ls_cnta3, ls_cnta4, & 
   ls_modo, is_delmes, is_almes

ib_preview = false
ll_ano = INTEGER( em_ano.text)
if ll_ano = 0 Then
	Messagebox( "Aviso", "Ingrese un año")
	return
end if

if ii_delmes = 0 then
	Messagebox( "Aviso", "Indique un mes")
	ddlb_del.SetFocus()
	return
end if

if ii_almes = 0 then
	Messagebox( "Aviso", "Indique un mes")
	ddlb_al.SetFocus()
	return
end if

if ii_nivel_cp <= 0 then
	Messagebox( "Aviso", "Indique un nivel para cuenta presupuestal")
	return
end if

is_delmes = TRIM(String( ii_delmes))
if len( is_delmes) = 1 then
	is_delmes = '0' + is_delmes
end if

is_almes = TRIM(String( ii_almes))
if len( is_almes) = 1 then
	is_almes = '0' + is_almes
end if

Setpointer(hourglass!)

// Segun niveles

Choose case ii_nivel_cp
	case 1
		ls_modo = '4_1'
		// Llena datos de dw seleccionados a tabla temporal
		delete from tt_pto_seleccion;
		FOR ll_row = 1 to dw_2.rowcount()
			ls_niv1 = dw_2.object.cencos[ll_row]					
					For ll_row2 = 1 to dw_4.RowCount()
						ls_cnta1 = dw_4.object.niv1[ll_row2]						
		
						// Llena tabla temporal con el centro de costo y todas las cuentas
						// presupuestales que tenga segun indicadores
						insert into tt_pto_seleccion(cencos, cnta1) 
						  values (:ls_niv1, :ls_cnta1);	
					Next
				NEXT
	case 2	
				ls_modo = '4_2'				
				// Llena datos de dw seleccionados a tabla temporal
				delete from tt_pto_seleccion;
				FOR ll_row = 1 to dw_2.rowcount()
					ls_niv1 = dw_2.object.cencos[ll_row]			
					For ll_row2 = 1 to dw_4.RowCount()
						ls_cnta1 = dw_4.object.niv1[ll_row2]
						ls_cnta2 = dw_4.object.niv2[ll_row2]
		
						// Llena tabla temporal con el centro de costo y todas las cuentas
						// presupuestales que tenga segun indicadores
						insert into tt_pto_seleccion(cencos, cnta1, cnta2) 
						  values (:ls_niv1, :ls_cnta1, :ls_cnta2);	
					Next
				NEXT
	case 3
				ls_modo = '4_3'				
				// Llena datos de dw seleccionados a tabla temporal
				delete from tt_pto_seleccion;
				FOR ll_row = 1 to dw_2.rowcount()
					ls_niv1 = dw_2.object.cencos[ll_row]					
					For ll_row2 = 1 to dw_4.RowCount()
						ls_cnta1 = dw_4.object.niv1[ll_row2]
						ls_cnta2 = dw_4.object.niv2[ll_row2]
						ls_cnta3 = dw_4.object.niv3[ll_row2]
		
						// Llena tabla temporal con el centro de costo y todas las cuentas
						// presupuestales que tenga segun indicadores
						insert into tt_pto_seleccion(cencos, cnta1, cnta2, cnta3) 
						  values (:ls_niv1, :ls_cnta1, :ls_cnta2, :ls_cnta3);	
					Next
				NEXT
	case 4
				ls_modo = '4_4'				
				// Llena datos de dw seleccionados a tabla temporal
				delete from tt_pto_seleccion;
				FOR ll_row = 1 to dw_2.rowcount()
					ls_niv1 = dw_2.object.cencos[ll_row]					
					For ll_row2 = 1 to dw_4.RowCount()
						ls_cnta4 = dw_4.object.cnta_prsp[ll_row2]
		
						// Llena tabla temporal con el centro de costo y todas las cuentas
						// presupuestales que tenga segun indicadores
						insert into tt_pto_seleccion(cencos, cnta_prsp) values (:ls_niv1, :ls_cnta4);
					Next
				NEXT
end choose

DECLARE PB_USP_proc PROCEDURE FOR USP_PTO_COMPARATIVO
				  (:ll_ano, :is_delmes, :is_almes, :ls_modo);
				EXECUTE PB_USP_PROC;
				If sqlca.sqlcode = -1 then
					messagebox("Error", sqlca.sqlerrtext)
					return 0
				end if
dw_report.SetTransObject(sqlca)
parent.event ue_preview()

dw_report.visible = true
dw_report.retrieve(ll_ano)
dw_report.object.p_logo.filename = gs_logo

cb_3.enabled = true
cb_3.visible = true

end event

type cb_3 from commandbutton within w_pt715_comparativo_cp
boolean visible = false
integer x = 3095
integer y = 20
integer width = 334
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccionar"
end type

event clicked;// Crea archivo temporal
//Date ld_desde, ld_hasta
//Long ln_ano, ln_mes
//

//
//ld_desde = uo_1.of_get_fecha1()
//ld_hasta = uo_1.of_get_fecha2()
//is_almacen = ddlb_almacen.ia_key[ii_index]
//ln_mes = MONTH( ld_desde)
//ln_ano = YEAR( ld_hasta)
//
//
//Setpointer( HourGlass!)
//
//dw_1.SetTransObject(sqlca)

dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	

cb_3.visible = false
//dw_1.reset()
//dw_2.reset()
//dw_1.retrieve(is_almacen, ln_ano, ln_mes)


end event

type em_ano from editmask within w_pt715_comparativo_cp
integer x = 206
integer y = 88
integer width = 178
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type dw_3 from u_dw_abc within w_pt715_comparativo_cp
integer x = 23
integer y = 1032
integer width = 1669
integer height = 796
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "Cuenta Operativa"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'
ii_ss = 0 
ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6
end event

event ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = dw_4.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = dw_4.SetItem(ll_row, dw_4.ii_rk[li_x], la_id)
NEXT

dw_4.ScrollToRow(ll_row)

end event

event ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

type dw_4 from u_dw_abc within w_pt715_comparativo_cp
integer x = 1915
integer y = 1036
integer width = 1669
integer height = 796
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'
ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6
end event

event ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = dw_3.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = dw_3.SetItem(ll_row, dw_3.ii_rk[li_x], la_id)
NEXT

dw_3.ScrollToRow(ll_row)



end event

type pb_3 from pb_1 within w_pt715_comparativo_cp
integer x = 1728
integer y = 1320
integer taborder = 120
end type

event clicked;//
THIS.EVENT ue_clicked_pre()

dw_3.EVENT ue_selected_row()

// ordenar ventana derecha
of_dw_sort()

end event

event ue_clicked_pre();//
idw_otro = dw_4
end event

type pb_4 from pb_2 within w_pt715_comparativo_cp
integer x = 1733
integer y = 1468
integer taborder = 140
end type

event clicked;//
THIS.EVENT ue_clicked_pre()

dw_4.EVENT ue_selected_row()

// ordenar ventana izquierda
of_dw_sort()
end event

event ue_clicked_pre();//
idw_otro = dw_3
end event

type st_2 from statictext within w_pt715_comparativo_cp
integer x = 1737
integer y = 100
integer width = 265
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cta.Pres.:"
boolean focusrectangle = false
end type

type ddlb_nivelcp from dropdownlistbox within w_pt715_comparativo_cp
integer x = 2016
integer y = 80
integer width = 347
integer height = 432
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"Nivel 1","Nivel 2","Nivel 3","Detalle"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;ii_nivel_cp = index

Choose case index
	case 1
		dw_3.dataobject = "d_sel_presup_cuenta_niv1"
		dw_4.dataobject = "d_sel_presup_cuenta_niv1"
	case 2
		dw_3.dataobject = "d_sel_presup_cuenta_niv2"	
		dw_4.dataobject = "d_sel_presup_cuenta_niv2"	
	case 3
		dw_3.dataobject = "d_sel_presup_cuenta_niv3"
		dw_4.dataobject = "d_sel_presup_cuenta_niv3"
	case 4
		dw_3.dataobject = "d_lista_Presupuesto_cuenta"
		dw_4.dataobject = "d_lista_Presupuesto_cuenta"
End Choose
dw_3.SetTransobject(sqlca)
dw_3.Retrieve()
end event

type st_1 from statictext within w_pt715_comparativo_cp
integer x = 69
integer y = 100
integer width = 133
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pt715_comparativo_cp
integer x = 448
integer y = 100
integer width = 142
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "De:"
boolean focusrectangle = false
end type

type ddlb_del from dropdownlistbox within w_pt715_comparativo_cp
integer x = 590
integer y = 84
integer width = 416
integer height = 800
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;ii_delmes = index
end event

type ddlb_al from dropdownlistbox within w_pt715_comparativo_cp
integer x = 1175
integer y = 80
integer width = 416
integer height = 800
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;ii_almes = index
end event

type st_4 from statictext within w_pt715_comparativo_cp
integer x = 1074
integer y = 96
integer width = 91
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "A:"
boolean focusrectangle = false
end type

type gb_3 from groupbox within w_pt715_comparativo_cp
integer x = 32
integer y = 16
integer width = 1614
integer height = 192
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo"
end type

type gb_5 from groupbox within w_pt715_comparativo_cp
integer x = 1701
integer y = 16
integer width = 722
integer height = 192
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nivel "
end type

