$PBExportHeader$w_pt707_ejecucion_acum_cnta_prsp.srw
$PBExportComments$Control presupuestario por centro de costo
forward
global type w_pt707_ejecucion_acum_cnta_prsp from w_rpt_list
end type
type gb_fechas from groupbox within w_pt707_ejecucion_acum_cnta_prsp
end type
type cb_3 from commandbutton within w_pt707_ejecucion_acum_cnta_prsp
end type
type dw_3 from u_dw_abc within w_pt707_ejecucion_acum_cnta_prsp
end type
type dw_4 from u_dw_abc within w_pt707_ejecucion_acum_cnta_prsp
end type
type cb_4 from commandbutton within w_pt707_ejecucion_acum_cnta_prsp
end type
type cb_5 from commandbutton within w_pt707_ejecucion_acum_cnta_prsp
end type
type uo_1 from u_ingreso_fecha within w_pt707_ejecucion_acum_cnta_prsp
end type
end forward

global type w_pt707_ejecucion_acum_cnta_prsp from w_rpt_list
integer width = 3415
integer height = 2000
string title = "Ejecucion Acumulada x cuenta presupuestal (PT707)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
gb_fechas gb_fechas
cb_3 cb_3
dw_3 dw_3
dw_4 dw_4
cb_4 cb_4
cb_5 cb_5
uo_1 uo_1
end type
global w_pt707_ejecucion_acum_cnta_prsp w_pt707_ejecucion_acum_cnta_prsp

type variables
Int ii_index = 0
end variables

forward prototypes
public function integer wf_retrieve_cencos ()
end prototypes

public function integer wf_retrieve_cencos ();Long j
String ls_cnta[]
Date ld_fec_ini, ld_fec_fin

ld_fec_ini = date( '01/01/' + string(year(ld_fec_ini)))
ld_fec_fin = uo_1.of_get_fecha()  

For j = 1 to dw_2.Rowcount()
	ls_cnta[j] = dw_2.object.cnta_prsp[j]
next

dw_3.retrieve(ld_fec_ini, ld_fec_fin, ls_cnta)
return 0
end function

on w_pt707_ejecucion_acum_cnta_prsp.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.cb_3=create cb_3
this.dw_3=create dw_3
this.dw_4=create dw_4
this.cb_4=create cb_4
this.cb_5=create cb_5
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.dw_4
this.Control[iCurrent+5]=this.cb_4
this.Control[iCurrent+6]=this.cb_5
this.Control[iCurrent+7]=this.uo_1
end on

on w_pt707_ejecucion_acum_cnta_prsp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.cb_3)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.uo_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
//dw_1.height = newheight - dw_1.y
//dw_2.height = newheight - dw_2.y
end event

event ue_retrieve();call super::ue_retrieve;Long 	 j,k, ll_ano, ll_mes
String ls_cnta, ls_cencos
Date ld_fec_ini, ld_fec_fin

ld_fec_ini = date( '01/01/' + string(year(ld_fec_ini)))
ld_fec_fin = uo_1.of_get_fecha() 

dw_report.SetTransObject( sqlca)
SetPointer(Hourglass!)

// Llena datos de dw seleccionados a tabla temporal	
FOR j = 1 to dw_2.rowcount()	
	ls_cnta = dw_2.object.cnta_prsp[j]	
	FOR k = 1 to dw_4.rowcount()		
		ls_cencos = dw_4.object.cencos[k]	
		insert into tt_pto_seleccion (cencos, cnta_prsp)
		values(:ls_cencos, :ls_cnta);
	NEXT		
NEXT	

DECLARE USP_proc PROCEDURE FOR USP_PTO_EJECUCION_ACUM_CTA(:ld_fec_fin);
EXECUTE USP_PROC;
If sqlca.sqlcode = -1 then
	messagebox("Error", sqlca.sqlerrtext)
	return 
end if

	dw_1.visible = false
	dw_2.visible = false
	this.Event ue_preview()
	dw_report.visible = true	
	dw_report.retrieve(ld_fec_ini, ld_fec_fin,ls_cnta, ls_cencos)		
	dw_report.object.p_logo.filename = gs_logo
	dw_report.object.t_usuario.text = gs_user
	dw_report.object.t_titulo1.text = 'DEL ' + STRING( ld_fec_ini, 'dd/mm/yyyy') + &
	  ' AL ' + string( ld_fec_fin, 'dd/mm/yyyy')

end event

type dw_report from w_rpt_list`dw_report within w_pt707_ejecucion_acum_cnta_prsp
boolean visible = false
integer x = 0
integer y = 284
integer width = 3319
integer height = 1960
string dataobject = "d_rpt_ejecucion_acum_x_cta"
end type

type dw_1 from w_rpt_list`dw_1 within w_pt707_ejecucion_acum_cnta_prsp
integer x = 5
integer y = 260
integer width = 1586
integer height = 772
integer taborder = 30
string dataobject = "d_sel_ejecucion_x_cnta_prsp"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1 
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2


ii_rk[1] = 1
ii_rk[2] = 2

end event

type pb_1 from w_rpt_list`pb_1 within w_pt707_ejecucion_acum_cnta_prsp
integer x = 1678
integer y = 484
integer taborder = 80
end type

event pb_1::clicked;call super::clicked;if dw_2.rowcount() > 0 then
	cb_report.enabled = true
end if
wf_retrieve_cencos()
end event

type pb_2 from w_rpt_list`pb_2 within w_pt707_ejecucion_acum_cnta_prsp
integer x = 1687
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

type dw_2 from w_rpt_list`dw_2 within w_pt707_ejecucion_acum_cnta_prsp
integer x = 1888
integer y = 256
integer width = 1586
integer height = 764
integer taborder = 120
string dataobject = "d_sel_ejecucion_x_cnta_prsp"
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

type cb_report from w_rpt_list`cb_report within w_pt707_ejecucion_acum_cnta_prsp
integer x = 2903
integer y = 60
integer width = 457
integer height = 92
integer taborder = 20
integer weight = 700
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;parent.event ue_retrieve()
end event

type gb_fechas from groupbox within w_pt707_ejecucion_acum_cnta_prsp
integer x = 18
integer y = 8
integer width = 754
integer height = 224
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha"
end type

type cb_3 from commandbutton within w_pt707_ejecucion_acum_cnta_prsp
integer x = 2363
integer y = 56
integer width = 457
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar"
end type

event clicked;Date ld_fec_ini, ld_fec_fin

ld_fec_ini = date( '01/01/' + string(year(ld_fec_ini)))
ld_fec_fin = uo_1.of_get_fecha()  

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

type dw_3 from u_dw_abc within w_pt707_ejecucion_acum_cnta_prsp
integer y = 1100
integer width = 1586
integer height = 720
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_sel_ejecucion_cencos_x_cnta"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1 
ii_ck[2] = 2

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

type dw_4 from u_dw_abc within w_pt707_ejecucion_acum_cnta_prsp
integer x = 1897
integer y = 1116
integer width = 1586
integer height = 764
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sel_ejecucion_cencos_x_cnta"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1 
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2

is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
idw_det = dw_3
 

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

type cb_4 from commandbutton within w_pt707_ejecucion_acum_cnta_prsp
event ue_clicked_pre ( )
integer x = 1669
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

type cb_5 from commandbutton within w_pt707_ejecucion_acum_cnta_prsp
event ue_clicked_pre ( )
integer x = 1669
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

type uo_1 from u_ingreso_fecha within w_pt707_ejecucion_acum_cnta_prsp
integer x = 78
integer y = 92
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor; string ls_inicio 

 of_set_label('Hasta el:') //para setear la fecha inicial

//Obtenemos el Primer dia del Mes

ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 of_set_fecha(today())
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas
 

end event

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

