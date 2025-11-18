$PBExportHeader$w_ve756_ventas_periodo.srw
forward
global type w_ve756_ventas_periodo from w_rpt
end type
type rb_2 from radiobutton within w_ve756_ventas_periodo
end type
type rb_1 from radiobutton within w_ve756_ventas_periodo
end type
type uo_1 from u_ingreso_rango_fechas within w_ve756_ventas_periodo
end type
type dw_reporte from u_dw_rpt within w_ve756_ventas_periodo
end type
type cb_1 from commandbutton within w_ve756_ventas_periodo
end type
type gb_1 from groupbox within w_ve756_ventas_periodo
end type
end forward

global type w_ve756_ventas_periodo from w_rpt
integer width = 3520
integer height = 2360
string title = "[VE756] Reporte de Ventas por periodo"
string menuname = "m_reporte"
rb_2 rb_2
rb_1 rb_1
uo_1 uo_1
dw_reporte dw_reporte
cb_1 cb_1
gb_1 gb_1
end type
global w_ve756_ventas_periodo w_ve756_ventas_periodo

on w_ve756_ventas_periodo.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.rb_2=create rb_2
this.rb_1=create rb_1
this.uo_1=create uo_1
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.dw_reporte
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.gb_1
end on

on w_ve756_ventas_periodo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.uo_1)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_fec_ini, ld_fec_fin
String	ls_flag

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

if rb_1.checked then
	ls_flag = '1'
else
	ls_flag = '2'
end if

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user
idw_1.object.t_texto.text    = 'Del ' + string(ld_fec_ini) + ' al ' + string(ld_fec_fin)

idw_1.retrieve(ld_fec_ini, ld_fec_fin, ls_flag)


end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

Event ue_preview()
//This.Event ue_retrieve()

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

event resize;call super::resize;dw_reporte.width  = newwidth - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

type rb_2 from radiobutton within w_ve756_ventas_periodo
integer x = 1490
integer y = 128
integer width = 475
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Emisión"
end type

type rb_1 from radiobutton within w_ve756_ventas_periodo
integer x = 1490
integer y = 48
integer width = 475
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Deposito"
boolean checked = true
end type

type uo_1 from u_ingreso_rango_fechas within w_ve756_ventas_periodo
event destroy ( )
integer x = 23
integer y = 84
integer taborder = 50
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type dw_reporte from u_dw_rpt within w_ve756_ventas_periodo
integer y = 240
integer width = 3319
integer height = 1556
integer taborder = 0
string dataobject = "d_rpt_ventas_periodo_tbl"
end type

type cb_1 from commandbutton within w_ve756_ventas_periodo
integer x = 2373
integer y = 36
integer width = 352
integer height = 172
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Event ue_retrieve()
end event

type gb_1 from groupbox within w_ve756_ventas_periodo
integer width = 2761
integer height = 224
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Periodo  y  Selecciona Origen"
end type

