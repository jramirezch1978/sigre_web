$PBExportHeader$w_pt709_gastos_x_ccosto.srw
$PBExportComments$Control presupuestario por centro de costo
forward
global type w_pt709_gastos_x_ccosto from w_rpt_list
end type
type gb_fechas from groupbox within w_pt709_gastos_x_ccosto
end type
type cb_3 from commandbutton within w_pt709_gastos_x_ccosto
end type
type uo_fechas from u_ingreso_rango_fechas within w_pt709_gastos_x_ccosto
end type
type rb_soles from radiobutton within w_pt709_gastos_x_ccosto
end type
type rb_dolares from radiobutton within w_pt709_gastos_x_ccosto
end type
end forward

global type w_pt709_gastos_x_ccosto from w_rpt_list
integer width = 3415
integer height = 2000
string title = "Gastos x Centro de Costo (PT709)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
gb_fechas gb_fechas
cb_3 cb_3
uo_fechas uo_fechas
rb_soles rb_soles
rb_dolares rb_dolares
end type
global w_pt709_gastos_x_ccosto w_pt709_gastos_x_ccosto

type variables
Int ii_index = 0
end variables

on w_pt709_gastos_x_ccosto.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.cb_3=create cb_3
this.uo_fechas=create uo_fechas
this.rb_soles=create rb_soles
this.rb_dolares=create rb_dolares
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.uo_fechas
this.Control[iCurrent+4]=this.rb_soles
this.Control[iCurrent+5]=this.rb_dolares
end on

on w_pt709_gastos_x_ccosto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.cb_3)
destroy(this.uo_fechas)
destroy(this.rb_soles)
destroy(this.rb_dolares)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_retrieve;call super::ue_retrieve;Long ll_row
String ls_cencos[], ls_moneda
Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_fechas.of_get_fecha1()  //, 'DD/MM/YYYY')
ld_fec_fin = uo_fechas.of_get_fecha2() //, 'DD/MM/YYYY')

if rb_soles.checked then
	ls_moneda = gnvo_app.is_soles
else
	ls_moneda = gnvo_app.is_dolares
end if

dw_report.SetTransObject(sqlca)

// Llena datos de dw seleccionados a tabla temporal	
FOR ll_row = 1 to dw_2.rowcount()		
	ls_cencos[ll_row]    = dw_2.object.cencos[ll_row]	
NEXT	

dw_1.visible = false
dw_2.visible = false
pb_1.visible = false
pb_2.visible = false
//this.Event ue_preview()

dw_report.retrieve(ld_fec_ini, ld_fec_fin, ls_cencos, ls_moneda)		

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_usuario.text 	= gs_user
dw_report.object.t_titulo1.text 	= 'DEL ' + STRING( ld_fec_ini, 'dd/mm/yyyy') + &
  ' AL ' + string( ld_fec_fin, 'dd/mm/yyyy')
dw_report.object.t_titulo2.text 	= 'MONEDA: ' + ls_moneda

dw_report.visible = true	

end event

type dw_report from w_rpt_list`dw_report within w_pt709_gastos_x_ccosto
boolean visible = false
integer x = 0
integer y = 236
integer width = 3319
integer height = 1960
string dataobject = "d_cns_ejecucion_x_ccosto"
end type

type dw_1 from w_rpt_list`dw_1 within w_pt709_gastos_x_ccosto
integer y = 256
integer width = 1586
integer height = 772
integer taborder = 50
string dataobject = "d_sel_ejecucion_x_ccosto"
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

type pb_1 from w_rpt_list`pb_1 within w_pt709_gastos_x_ccosto
integer x = 1678
integer y = 484
integer taborder = 70
end type

event pb_1::clicked;call super::clicked;if dw_2.rowcount() > 0 then
	cb_report.enabled = true
end if
end event

type pb_2 from w_rpt_list`pb_2 within w_pt709_gastos_x_ccosto
integer x = 1687
integer y = 728
integer taborder = 100
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;if dw_2.rowcount() = 0 then
	cb_report.enabled = false
end if
end event

type dw_2 from w_rpt_list`dw_2 within w_pt709_gastos_x_ccosto
integer x = 1888
integer y = 256
integer width = 1586
integer height = 764
integer taborder = 90
string dataobject = "d_sel_ejecucion_x_ccosto"
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

type cb_report from w_rpt_list`cb_report within w_pt709_gastos_x_ccosto
integer x = 2295
integer y = 72
integer width = 457
integer height = 92
integer taborder = 40
integer weight = 700
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;parent.event ue_retrieve()
end event

type gb_fechas from groupbox within w_pt709_gastos_x_ccosto
integer width = 2971
integer height = 216
integer taborder = 80
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

type cb_3 from commandbutton within w_pt709_gastos_x_ccosto
integer x = 1833
integer y = 72
integer width = 457
integer height = 92
integer taborder = 60
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

ld_fec_ini = uo_fechas.of_get_fecha1()  //, 'DD/MM/YYYY')
ld_fec_fin = uo_fechas.of_get_fecha2() //, 'DD/MM/YYYY')

SetPointer( HourGlass!)

dw_1.SetTransObject(sqlca)

dw_1.visible = true
dw_2.visible = true
pb_1.visible = true
pb_2.visible = true
dw_report.visible = false	
dw_1.reset()
dw_2.reset()

dw_1.retrieve(ld_fec_ini, ld_fec_fin)

return 1
end event

type uo_fechas from u_ingreso_rango_fechas within w_pt709_gastos_x_ccosto
integer x = 50
integer y = 52
integer taborder = 50
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

type rb_soles from radiobutton within w_pt709_gastos_x_ccosto
integer x = 1399
integer y = 44
integer width = 402
integer height = 80
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

type rb_dolares from radiobutton within w_pt709_gastos_x_ccosto
integer x = 1394
integer y = 120
integer width = 402
integer height = 80
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

