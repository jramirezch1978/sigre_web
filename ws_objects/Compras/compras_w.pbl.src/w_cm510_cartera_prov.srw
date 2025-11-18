$PBExportHeader$w_cm510_cartera_prov.srw
forward
global type w_cm510_cartera_prov from w_report_smpl
end type
type rb_1 from radiobutton within w_cm510_cartera_prov
end type
type rb_2 from radiobutton within w_cm510_cartera_prov
end type
type uo_1 from u_ingreso_rango_fechas within w_cm510_cartera_prov
end type
type cb_1 from commandbutton within w_cm510_cartera_prov
end type
end forward

global type w_cm510_cartera_prov from w_report_smpl
integer width = 2779
integer height = 1952
string title = "(CM510) Catalogo de compras"
string menuname = "m_impresion"
long backcolor = 67108864
rb_1 rb_1
rb_2 rb_2
uo_1 uo_1
cb_1 cb_1
end type
global w_cm510_cartera_prov w_cm510_cartera_prov

on w_cm510_cartera_prov.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_1=create rb_1
this.rb_2=create rb_2
this.uo_1=create uo_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.cb_1
end on

on w_cm510_cartera_prov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.uo_1)
destroy(this.cb_1)
end on

event ue_retrieve;call super::ue_retrieve;Long 	ll_row
Date ld_desde, ld_hasta
String ls_cod, ls_error

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

if rb_2.checked then
	dw_report.DataObject = 'd_rpt_resumen_catalog_cmp_tbl'
	dw_report.SetTransObject(SQLCA)
	dw_report.Retrieve(ld_desde, ld_hasta)
else
	dw_report.DataObject = 'd_rpt_detalle_catalog_cmp_tbl'
	dw_report.SetTransObject(SQLCA)
	dw_report.Retrieve(ld_desde, ld_hasta)
	
end if
//ib_preview = false
//Event ue_preview()

dw_report.visible = true	
dw_report.object.datawindow.print.orientation = 1
dw_report.object.titulo_1.text = 'Del ' + STRING(LD_DESDE, "DD/MM/YYYY") +&
						' Al :' + STRING(LD_HASTA, "DD/MM/YYYY")
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user		



end event

type dw_report from w_report_smpl`dw_report within w_cm510_cartera_prov
integer x = 0
integer y = 208
integer width = 2395
integer height = 1344
string dataobject = "d_rpt_resumen_catalog_cmp_tbl"
end type

type rb_1 from radiobutton within w_cm510_cartera_prov
integer x = 1358
integer y = 16
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detallado"
end type

type rb_2 from radiobutton within w_cm510_cartera_prov
integer x = 1362
integer y = 112
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
boolean checked = true
end type

type uo_1 from u_ingreso_rango_fechas within w_cm510_cartera_prov
event destroy ( )
integer x = 23
integer y = 24
integer taborder = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_1 from commandbutton within w_cm510_cartera_prov
integer x = 1801
integer y = 28
integer width = 457
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(Hourglass!)
parent.event ue_retrieve( )
SetPointer(Arrow!)
end event

