$PBExportHeader$w_pt710_gastos_x_cnta_prsp.srw
$PBExportComments$Control presupuestario por centro de costo
forward
global type w_pt710_gastos_x_cnta_prsp from w_rpt_list
end type
type gb_fechas from groupbox within w_pt710_gastos_x_cnta_prsp
end type
type cb_3 from commandbutton within w_pt710_gastos_x_cnta_prsp
end type
type uo_fechas from u_ingreso_rango_fechas within w_pt710_gastos_x_cnta_prsp
end type
type dw_3 from u_dw_abc within w_pt710_gastos_x_cnta_prsp
end type
type dw_4 from u_dw_abc within w_pt710_gastos_x_cnta_prsp
end type
type cb_4 from commandbutton within w_pt710_gastos_x_cnta_prsp
end type
type cb_5 from commandbutton within w_pt710_gastos_x_cnta_prsp
end type
type st_2 from statictext within w_pt710_gastos_x_cnta_prsp
end type
type sle_moneda from singlelineedit within w_pt710_gastos_x_cnta_prsp
end type
type st_1 from statictext within w_pt710_gastos_x_cnta_prsp
end type
type st_3 from statictext within w_pt710_gastos_x_cnta_prsp
end type
end forward

global type w_pt710_gastos_x_cnta_prsp from w_rpt_list
integer width = 3415
integer height = 2000
string title = "Gastos x Cuenta Presupuestal (PT710)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
gb_fechas gb_fechas
cb_3 cb_3
uo_fechas uo_fechas
dw_3 dw_3
dw_4 dw_4
cb_4 cb_4
cb_5 cb_5
st_2 st_2
sle_moneda sle_moneda
st_1 st_1
st_3 st_3
end type
global w_pt710_gastos_x_cnta_prsp w_pt710_gastos_x_cnta_prsp

type variables
Int ii_index = 0
end variables

forward prototypes
public function integer wf_retrieve_cencos ()
end prototypes

public function integer wf_retrieve_cencos ();Long j
String ls_cnta[]
Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_fechas.of_get_fecha1()  
ld_fec_fin = uo_fechas.of_get_fecha2() 


For j = 1 to dw_2.Rowcount()
	ls_cnta[j] = dw_2.object.cnta_prsp[j]
next

dw_3.retrieve(ld_fec_ini, ld_fec_fin, ls_cnta)
return 0
end function

on w_pt710_gastos_x_cnta_prsp.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.cb_3=create cb_3
this.uo_fechas=create uo_fechas
this.dw_3=create dw_3
this.dw_4=create dw_4
this.cb_4=create cb_4
this.cb_5=create cb_5
this.st_2=create st_2
this.sle_moneda=create sle_moneda
this.st_1=create st_1
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.uo_fechas
this.Control[iCurrent+4]=this.dw_3
this.Control[iCurrent+5]=this.dw_4
this.Control[iCurrent+6]=this.cb_4
this.Control[iCurrent+7]=this.cb_5
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.sle_moneda
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_3
end on

on w_pt710_gastos_x_cnta_prsp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.cb_3)
destroy(this.uo_fechas)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.st_2)
destroy(this.sle_moneda)
destroy(this.st_1)
destroy(this.st_3)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


st_3.y = (newheight - (st_1.y + st_1.height)) / 2 + st_1.y
st_3.width = newwidth - st_3.x - 10

dw_3.y = st_3.y + st_3.height + 10
dw_3.height = newheight - dw_3.y - 10

cb_4.x = newwidth / 2 - cb_4.width / 2
cb_4.y = dw_3.y + dw_3.height / 2 - cb_4.height - 10

cb_5.x = cb_4.x
cb_5.y = cb_4.y + cb_4.height + 10
dw_3.width = cb_5.x - dw_3.x - 10

dw_4.y = dw_3.y
dw_4.x = cb_5.x + cb_5.width + 10
dw_4.height = newheight - dw_4.y - 10
dw_4.width = newWidth - dw_4.x - 10


dw_1.y = st_1.y + st_1.height + 5
dw_1.height = st_3.y - dw_1.y - 5

st_1.width = newwidth - st_1.x - 10
pb_1.x = newwidth / 2 - pb_1.width / 2
pb_1.y = dw_1.y + dw_1.height / 2 - pb_1.height - 10

pb_2.x = pb_1.x
pb_2.y = pb_1.y + pb_1.height + 10

dw_1.width = pb_1.x - dw_1.x - 10

dw_2.y = dw_1.y
dw_2.x = pb_1.x + pb_1.width + 10
dw_2.height = st_3.y - dw_2.y - 10
dw_2.width = newWidth - dw_2.x - 10

//dw_1.height = newheight - dw_1.y
//dw_2.height = newheight - dw_2.y
end event

event ue_retrieve;call super::ue_retrieve;Long 	 ll_row, ll_ano, ll_mes
String ls_cnta[], ls_cencos[], ls_moneda
Date ld_fec_ini, ld_fec_fin

ld_fec_ini 	= uo_fechas.of_get_fecha1() 
ld_fec_fin 	= uo_fechas.of_get_fecha2() 
ls_moneda	= sle_moneda.text

dw_report.SetTransObject( sqlca )

// Llena datos de dw seleccionados a tabla temporal	
FOR ll_row = 1 to dw_2.rowcount()		
	ls_cnta[ll_row]    = dw_2.object.cnta_prsp[ll_row]	
NEXT	

// Llena datos de dw seleccionados a tabla temporal	
FOR ll_row = 1 to dw_4.rowcount()		
	ls_cencos[ll_row]  = dw_4.object.cencos[ll_row]	
NEXT	

dw_1.visible = false
dw_2.visible = false
this.Event ue_preview()

dw_report.visible = true	
dw_report.retrieve(ld_fec_ini, ld_fec_fin,ls_cnta, ls_cencos, ls_moneda)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_usuario.text = gs_user
dw_report.object.t_titulo1.text = 'DEL ' + STRING( ld_fec_ini, 'dd/mm/yyyy') + &
  											 ' AL ' + string( ld_fec_fin, 'dd/mm/yyyy')

end event

event ue_open_pre;call super::ue_open_pre;sle_moneda.text = gnvo_app.is_soles
end event

type dw_report from w_rpt_list`dw_report within w_pt710_gastos_x_cnta_prsp
boolean visible = false
integer x = 0
integer y = 200
integer width = 3319
integer height = 2128
string dataobject = "d_cns_ejecucion_x_cnta_prsp"
end type

type dw_1 from w_rpt_list`dw_1 within w_pt710_gastos_x_cnta_prsp
integer x = 5
integer y = 296
integer width = 1586
integer height = 772
integer taborder = 30
string dataobject = "d_sel_ejecucion_x_cnta_prsp"
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1 
//ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2
//ii_dk[3] = 3
//ii_dk[4] = 4
//ii_dk[5] = 5

ii_rk[1] = 1
ii_rk[2] = 2
//ii_rk[3] = 3
//ii_rk[4] = 4
//ii_rk[5] = 5

end event

type pb_1 from w_rpt_list`pb_1 within w_pt710_gastos_x_cnta_prsp
integer x = 1678
integer y = 484
integer taborder = 80
end type

event pb_1::clicked;call super::clicked;if dw_2.rowcount() > 0 then
	cb_report.enabled = true
end if
wf_retrieve_cencos()
end event

type pb_2 from w_rpt_list`pb_2 within w_pt710_gastos_x_cnta_prsp
integer x = 1678
integer y = 700
integer taborder = 130
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;if dw_2.rowcount() = 0 then
	cb_report.enabled = false
	dw_3.reset()
else
	wf_retrieve_cencos()
end if
end event

type dw_2 from w_rpt_list`dw_2 within w_pt710_gastos_x_cnta_prsp
integer x = 1888
integer y = 296
integer width = 1586
integer height = 772
integer taborder = 120
string dataobject = "d_sel_ejecucion_x_cnta_prsp"
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
//ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2
//ii_dk[3] = 3
//ii_dk[4] = 4
//ii_dk[5] = 5

ii_rk[1] = 1
ii_rk[2] = 2
//ii_rk[3] = 3
//ii_rk[4] = 4
//ii_rk[5] = 5
end event

type cb_report from w_rpt_list`cb_report within w_pt710_gastos_x_cnta_prsp
integer x = 2409
integer y = 76
integer width = 457
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;parent.event ue_retrieve()
end event

type gb_fechas from groupbox within w_pt710_gastos_x_cnta_prsp
integer width = 2939
integer height = 200
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo"
end type

type cb_3 from commandbutton within w_pt710_gastos_x_cnta_prsp
integer x = 1929
integer y = 76
integer width = 457
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar"
end type

event clicked;Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_fechas.of_get_fecha1()  //, 'DD/MM/YYYY')
ld_fec_fin = uo_fechas.of_get_fecha2() //, 'DD/MM/YYYY')

SetPointer( HourGlass!)

dw_1.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)

dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	
dw_1.reset()
dw_2.reset()

dw_1.retrieve(ld_fec_ini, ld_fec_fin)

return 1
end event

type uo_fechas from u_ingreso_rango_fechas within w_pt710_gastos_x_cnta_prsp
integer x = 27
integer y = 76
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor; string ls_inicio 

 of_set_label('Desde','Hasta') //para setear la fecha inicial

//Obtenemos el Primer dia del Mes

ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 of_set_fecha(date(ls_inicio),today())
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas
 
//Controles a Observar en el Windows

end event

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_3 from u_dw_abc within w_pt710_gastos_x_cnta_prsp
integer x = 5
integer y = 1164
integer width = 1586
integer height = 632
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_sel_ejecucion_cencos_x_cnta"
end type

event constructor;call super::constructor;ii_ck[1] = 1 
//ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2

is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
idw_det = dw_4
 
end event

event ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)

end event

event ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

type dw_4 from u_dw_abc within w_pt710_gastos_x_cnta_prsp
integer x = 1897
integer y = 1164
integer width = 1586
integer height = 632
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sel_ejecucion_cencos_x_cnta"
end type

event constructor;call super::constructor;ii_ck[1] = 1 
//ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2

is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
idw_det = dw_3
 
// ii_dk[1] = 1
// ii_rk[1] = 1

end event

event ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_otro.ScrollToRow(ll_row)

end event

event ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

type cb_4 from commandbutton within w_pt710_gastos_x_cnta_prsp
event ue_clicked_pre ( )
integer x = 1678
integer y = 1264
integer width = 155
integer height = 128
integer taborder = 90
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event ue_clicked_pre();idw_otro = dw_4
end event

event clicked;
THIS.EVENT ue_clicked_pre()
dw_3.EVENT ue_selected_row()

// ordenar ventana derecha
of_dw_sort()


end event

type cb_5 from commandbutton within w_pt710_gastos_x_cnta_prsp
event ue_clicked_pre ( )
integer x = 1678
integer y = 1428
integer width = 155
integer height = 128
integer taborder = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event ue_clicked_pre();idw_otro = dw_3
end event

event clicked;THIS.EVENT ue_clicked_pre()

dw_4.EVENT ue_selected_row()

// ordenar ventana izquierda
of_dw_sort()

//if dw_4.rowcount() = 0 then
//	cb_report.enabled = false	
//end if
end event

type st_2 from statictext within w_pt710_gastos_x_cnta_prsp
integer x = 1335
integer y = 88
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Moneda:"
boolean focusrectangle = false
end type

type sle_moneda from singlelineedit within w_pt710_gastos_x_cnta_prsp
event dobleclick pbm_lbuttondblclk
integer x = 1618
integer y = 80
integer width = 288
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean   lb_ret
string 	 ls_codigo, ls_data, ls_sql

ls_sql = "Select m.cod_moneda as codigo_moneda, "&
			+"m.descripcion as descripcion_moneda "&
  			+"from moneda m Where m.flag_estado = 1"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type st_1 from statictext within w_pt710_gastos_x_cnta_prsp
integer x = 5
integer y = 200
integer width = 1586
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Cuenta Presupuestal"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pt710_gastos_x_cnta_prsp
integer x = 5
integer y = 1076
integer width = 1586
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Centro de Costos"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

