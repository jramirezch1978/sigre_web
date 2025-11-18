$PBExportHeader$w_pt711_ppto_materiales.srw
forward
global type w_pt711_ppto_materiales from w_rpt_list
end type
type gb_fechas from groupbox within w_pt711_ppto_materiales
end type
type cb_3 from commandbutton within w_pt711_ppto_materiales
end type
type em_ano from editmask within w_pt711_ppto_materiales
end type
end forward

global type w_pt711_ppto_materiales from w_rpt_list
integer width = 3415
integer height = 2000
string title = "Presupuesto de materiales"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
gb_fechas gb_fechas
cb_3 cb_3
em_ano em_ano
end type
global w_pt711_ppto_materiales w_pt711_ppto_materiales

type variables
Int ii_index = 0
end variables

on w_pt711_ppto_materiales.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.cb_3=create cb_3
this.em_ano=create em_ano
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.em_ano
end on

on w_pt711_ppto_materiales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.cb_3)
destroy(this.em_ano)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_retrieve();call super::ue_retrieve;Long 	 ll_row, ll_ano, ll_mes
String ls_cencos[]

ll_ano = Long( em_ano.text)
dw_report.SetTransObject( sqlca)

dw_report.setfilter('')
// Llena datos de dw seleccionados a tabla temporal	
FOR ll_row = 1 to dw_2.rowcount()		
	ls_cencos[ll_row]    = dw_2.object.cencos[ll_row]	
NEXT	

	dw_1.visible = false
	dw_2.visible = false
	pb_1.visible = false
	pb_2.visible = false
	this.Event ue_preview()
	dw_report.visible = true	
	dw_report.retrieve(ll_ano, ls_cencos)		
	dw_report.object.p_logo.filename = gs_logo
	dw_report.object.t_usuario.text = gs_user
//	dw_report.object.t_titulo1.text = 'DEL ' + STRING( ld_fec_ini, 'dd/mm/yyyy') + &
//	  ' AL ' + string( ld_fec_fin, 'dd/mm/yyyy')

end event

type dw_report from w_rpt_list`dw_report within w_pt711_ppto_materiales
boolean visible = false
integer x = 0
integer y = 284
integer width = 3319
integer height = 1960
string dataobject = "d_rpt_presup_materiales"
end type

type dw_1 from w_rpt_list`dw_1 within w_pt711_ppto_materiales
integer y = 256
integer width = 1586
integer height = 772
integer taborder = 50
string dataobject = "d_sel_pto_materiales_x_cencos"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;
ii_ck[1] = 1 
//ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
end event

type pb_1 from w_rpt_list`pb_1 within w_pt711_ppto_materiales
integer x = 1678
integer y = 484
integer taborder = 70
end type

event pb_1::clicked;call super::clicked;if dw_2.rowcount() > 0 then
	cb_report.enabled = true
end if
end event

type pb_2 from w_rpt_list`pb_2 within w_pt711_ppto_materiales
integer x = 1687
integer y = 728
integer taborder = 100
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;if dw_2.rowcount() = 0 then
	cb_report.enabled = false
end if
end event

type dw_2 from w_rpt_list`dw_2 within w_pt711_ppto_materiales
integer x = 1888
integer y = 256
integer width = 1586
integer height = 764
integer taborder = 90
string dataobject = "d_sel_pto_materiales_x_cencos"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
//ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
end event

type cb_report from w_rpt_list`cb_report within w_pt711_ppto_materiales
integer x = 2363
integer y = 56
integer width = 457
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 700
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;parent.event ue_retrieve()
end event

type gb_fechas from groupbox within w_pt711_ppto_materiales
integer x = 18
integer y = 8
integer width = 334
integer height = 224
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
end type

type cb_3 from commandbutton within w_pt711_ppto_materiales
integer x = 393
integer y = 80
integer width = 457
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Carga datos"
end type

event clicked;Long ll_ano

ll_ano = Long( em_ano.text)
SetPointer( HourGlass!)

dw_1.SetTransObject(sqlca)

dw_1.visible = true
dw_2.visible = true
pb_1.visible = true
pb_2.visible = true
dw_report.visible = false	
dw_1.reset()
dw_2.reset()

dw_1.retrieve(ll_ano)

return 1
end event

type em_ano from editmask within w_pt711_ppto_materiales
integer x = 37
integer y = 76
integer width = 288
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

