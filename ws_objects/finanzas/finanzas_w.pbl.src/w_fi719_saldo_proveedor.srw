$PBExportHeader$w_fi719_saldo_proveedor.srw
forward
global type w_fi719_saldo_proveedor from w_rpt
end type
type st_nom_proveedor from statictext within w_fi719_saldo_proveedor
end type
type cbx_todos from checkbox within w_fi719_saldo_proveedor
end type
type cb_reporte from commandbutton within w_fi719_saldo_proveedor
end type
type sle_moneda from singlelineedit within w_fi719_saldo_proveedor
end type
type rb_detalle from radiobutton within w_fi719_saldo_proveedor
end type
type rb_resumen from radiobutton within w_fi719_saldo_proveedor
end type
type sle_proveedor from singlelineedit within w_fi719_saldo_proveedor
end type
type st_1 from statictext within w_fi719_saldo_proveedor
end type
type st_2 from statictext within w_fi719_saldo_proveedor
end type
type em_1 from editmask within w_fi719_saldo_proveedor
end type
type st_3 from statictext within w_fi719_saldo_proveedor
end type
type em_2 from editmask within w_fi719_saldo_proveedor
end type
type st_4 from statictext within w_fi719_saldo_proveedor
end type
type cbx_1 from checkbox within w_fi719_saldo_proveedor
end type
type dw_reporte from u_dw_rpt within w_fi719_saldo_proveedor
end type
type gb_1 from groupbox within w_fi719_saldo_proveedor
end type
type gb_3 from groupbox within w_fi719_saldo_proveedor
end type
type gb_2 from groupbox within w_fi719_saldo_proveedor
end type
end forward

global type w_fi719_saldo_proveedor from w_rpt
boolean visible = false
integer width = 4379
integer height = 2188
string title = "[FI719] Reporte de Saldos de proveedores"
string menuname = "m_reporte"
boolean resizable = false
event ue_save_rep_sunat ( )
st_nom_proveedor st_nom_proveedor
cbx_todos cbx_todos
cb_reporte cb_reporte
sle_moneda sle_moneda
rb_detalle rb_detalle
rb_resumen rb_resumen
sle_proveedor sle_proveedor
st_1 st_1
st_2 st_2
em_1 em_1
st_3 st_3
em_2 em_2
st_4 st_4
cbx_1 cbx_1
dw_reporte dw_reporte
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
end type
global w_fi719_saldo_proveedor w_fi719_saldo_proveedor

type variables

end variables

on w_fi719_saldo_proveedor.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_nom_proveedor=create st_nom_proveedor
this.cbx_todos=create cbx_todos
this.cb_reporte=create cb_reporte
this.sle_moneda=create sle_moneda
this.rb_detalle=create rb_detalle
this.rb_resumen=create rb_resumen
this.sle_proveedor=create sle_proveedor
this.st_1=create st_1
this.st_2=create st_2
this.em_1=create em_1
this.st_3=create st_3
this.em_2=create em_2
this.st_4=create st_4
this.cbx_1=create cbx_1
this.dw_reporte=create dw_reporte
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nom_proveedor
this.Control[iCurrent+2]=this.cbx_todos
this.Control[iCurrent+3]=this.cb_reporte
this.Control[iCurrent+4]=this.sle_moneda
this.Control[iCurrent+5]=this.rb_detalle
this.Control[iCurrent+6]=this.rb_resumen
this.Control[iCurrent+7]=this.sle_proveedor
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.em_1
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.em_2
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.cbx_1
this.Control[iCurrent+15]=this.dw_reporte
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_3
this.Control[iCurrent+18]=this.gb_2
end on

on w_fi719_saldo_proveedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nom_proveedor)
destroy(this.cbx_todos)
destroy(this.cb_reporte)
destroy(this.sle_moneda)
destroy(this.rb_detalle)
destroy(this.rb_resumen)
destroy(this.sle_proveedor)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_1)
destroy(this.st_3)
destroy(this.em_2)
destroy(this.st_4)
destroy(this.cbx_1)
destroy(this.dw_reporte)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
end on

event ue_retrieve;
if trim(sle_moneda.text) = '' then
	MessageBox('Error', 'Debe elegir una moneda primero', STopSign!)
	sle_moneda.SetFocus()
	return
end if

if rb_detalle.checked then
	if sle_moneda.text = gnvo_app.is_soles then
		dw_reporte.DataObject = 'd_rpt_prov_soles_tbl'
	else
		dw_reporte.DataObject = 'd_rpt_prov_dolares_tbl'
	end if
else
	if sle_moneda.text = gnvo_app.is_soles then
		dw_reporte.DataObject = 'd_rpt_total_sol_tbl'
	else
		dw_reporte.DataObject = 'd_rpt_total_dol_tbl'
	end if
end if

dw_reporte.setTransObject(SQLCA)
dw_reporte.Retrieve()

ib_preview = false
event ue_preview()

dw_reporte.object.p_logo.filename 		= gs_logo
dw_reporte.object.t_user.text     		= gs_user
dw_reporte.object.t_empresa.text     	= gs_empresa



	
	

end event

event resize;call super::resize;dw_reporte.width  = newwidth  - dw_reporte.x - 10
dw_reporte.height = newheight - dw_reporte.y - 10

end event

event ue_preview;call super::ue_preview;idw_1.ii_zoom_actual = 100
IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Registro de Compras " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Registro de Compras " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
Trigger Event ue_preview()

ib_preview = true
THIS.Event ue_preview()

sle_moneda.text = gnvo_app.is_dolares
end event

type st_nom_proveedor from statictext within w_fi719_saldo_proveedor
integer x = 2642
integer y = 156
integer width = 1344
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cbx_todos from checkbox within w_fi719_saldo_proveedor
integer x = 2011
integer y = 64
integer width = 626
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los proveedores"
boolean checked = true
end type

event clicked;if this.checked then
	sle_proveedor.enabled = false
else
	sle_proveedor.enabled = true
end if
end event

type cb_reporte from commandbutton within w_fi719_saldo_proveedor
integer x = 3630
integer y = 40
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(HourGlass!)
Event ue_retrieve()
SetPointer(Arrow!)
end event

type sle_moneda from singlelineedit within w_fi719_saldo_proveedor
event dobleclick pbm_lbuttondblclk
integer x = 2930
integer y = 52
integer width = 297
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean   lb_ret
string 	 ls_codigo, ls_data, ls_sql

ls_sql = "Select m.cod_moneda as codigo_moneda, "&
		 + "m.descripcion as descripcion_moneda "&
  		 + "from moneda m " &
		 + "Where m.flag_estado = 1"
				  
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	this.text = ls_codigo
end if
end event

type rb_detalle from radiobutton within w_fi719_saldo_proveedor
integer x = 23
integer y = 72
integer width = 699
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle por Proveedor"
boolean checked = true
end type

event clicked;//em_1.text=""
//em_2.text=""
//sle_buscar_prov.text=""
//em_1.SetFocus()
////dw_1.SetFilter("")
////dw_1.Filter( )
////dw_1.settransobject(sqlca)
////dw_1.retrieve()	
end event

type rb_resumen from radiobutton within w_fi719_saldo_proveedor
integer x = 23
integer y = 168
integer width = 699
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen por Proveedor"
end type

event clicked;//em_1.text=""
//em_2.text=""
//sle_buscar_prov.text=""
//em_1.SetFocus()
end event

type sle_proveedor from singlelineedit within w_fi719_saldo_proveedor
event dobleclick pbm_lbuttondblclk
integer x = 2309
integer y = 156
integer width = 329
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_fi719_saldo_proveedor
integer x = 2016
integer y = 164
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi719_saldo_proveedor
integer x = 841
integer y = 60
integer width = 311
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Inicial:"
boolean focusrectangle = false
end type

type em_1 from editmask within w_fi719_saldo_proveedor
integer x = 837
integer y = 128
integer width = 402
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###,###,##0.00"
end type

type st_3 from statictext within w_fi719_saldo_proveedor
integer x = 1317
integer y = 60
integer width = 311
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Final:"
boolean focusrectangle = false
end type

type em_2 from editmask within w_fi719_saldo_proveedor
integer x = 1312
integer y = 128
integer width = 402
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###,###,##0.00"
end type

type st_4 from statictext within w_fi719_saldo_proveedor
integer x = 2697
integer y = 72
integer width = 233
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda:"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_fi719_saldo_proveedor
integer x = 1842
integer y = 36
integer width = 87
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;//if cbx_1.checked = true then
//	sle_buscar_prov.Enabled = false
//	pb_1.Enabled = false
//	pb_2.Enabled = true
//	em_1.Enabled = true
//	em_2.Enabled = true
//	em_1.SetFocus()
//else
//	pb_1.Enabled = true
//	sle_buscar_prov.Enabled = true
//	sle_buscar_prov.SetFocus()
//	pb_2.Enabled = false
//	em_1.Enabled = false
//	em_2.Enabled = false
//	em_1.text = ""
//	em_2.text = ""
//end if
end event

type dw_reporte from u_dw_rpt within w_fi719_saldo_proveedor
integer y = 304
integer width = 4128
integer height = 1544
integer taborder = 30
string dataobject = "d_rpt_prov_soles_tbl"
boolean livescroll = false
end type

type gb_1 from groupbox within w_fi719_saldo_proveedor
integer width = 777
integer height = 284
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Reporte"
end type

type gb_3 from groupbox within w_fi719_saldo_proveedor
integer x = 791
integer width = 1175
integer height = 284
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar por saldo del proveedor:"
end type

type gb_2 from groupbox within w_fi719_saldo_proveedor
integer x = 1984
integer width = 2062
integer height = 284
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar Proveedor y Moneda"
end type

