$PBExportHeader$uo_rpt1.sru
forward
global type uo_rpt1 from userobject
end type
type cb_2 from commandbutton within uo_rpt1
end type
type cb_1 from commandbutton within uo_rpt1
end type
type dw_1 from datawindow within uo_rpt1
end type
type cb_reporte from commandbutton within uo_rpt1
end type
type uo_fecha from u_ingreso_rango_fechas within uo_rpt1
end type
end forward

global type uo_rpt1 from userobject
integer width = 3333
integer height = 2372
long backcolor = 16777215
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event resize ( long al_with,  long al_height )
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
cb_reporte cb_reporte
uo_fecha uo_fecha
end type
global uo_rpt1 uo_rpt1

event resize(long al_with, long al_height);dw_1.width  = al_with  - dw_1.x - 10
dw_1.height = al_height - dw_1.y - 10
end event

on uo_rpt1.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.cb_reporte=create cb_reporte
this.uo_fecha=create uo_fecha
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_1,&
this.cb_reporte,&
this.uo_fecha}
end on

on uo_rpt1.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.cb_reporte)
destroy(this.uo_fecha)
end on

type cb_2 from commandbutton within uo_rpt1
integer x = 1911
integer y = 44
integer width = 279
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Imprimir"
end type

event clicked;dw_1.Print()
end event

type cb_1 from commandbutton within uo_rpt1
integer x = 1714
integer y = 44
integer width = 197
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "PDF"
end type

event clicked;String ls_file
//MessageBox('Información', 'Imprimir')
//dw_employee.print()

ls_file = "c:\temp.pdf"
dw_1.Object.DataWindow.Export.PDF.Method = Distill! 
dw_1.Object.DataWindow.Printer = "CutePDF Writer" 
dw_1.Object.DataWindow.Export.PDF.Distill.CustomPostScript="1"
dw_1.Modify("datawindow.Export.PDF.Method = '1'") 
dw_1.Modify("datawindow.Export.PDF.xslfop.print=no") 

dw_1.SaveAs(ls_file, PDF!, true)

//MessageBox('Aviso', 'Archivo exportado')

#if defined PBWEBFORM then
DownloadFile(ls_file, true)
#end if
end event

type dw_1 from datawindow within uo_rpt1
integer x = 5
integer y = 188
integer width = 3278
integer height = 2092
integer taborder = 60
string title = "none"
string dataobject = "d_rpt_avance_cst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_reporte from commandbutton within uo_rpt1
integer x = 1307
integer y = 44
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reporte"
end type

event clicked;date ld_Fecha1, ld_Fecha2

ld_Fecha1 = uo_Fecha.of_get_fecha1()
ld_Fecha2 = uo_Fecha.of_get_fecha2()

dw_1.setTransObject(SQLCA)
dw_1.retrieve(ld_Fecha1, ld_Fecha2)


end event

type uo_fecha from u_ingreso_rango_fechas within uo_rpt1
integer y = 48
integer taborder = 50
long backcolor = 16777215
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(date(f_fecha_actual()), date(f_fecha_Actual())) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

