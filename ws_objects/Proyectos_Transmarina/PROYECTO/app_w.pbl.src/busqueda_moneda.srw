$PBExportHeader$busqueda_moneda.srw
forward
global type busqueda_moneda from window
end type
type cb_3 from commandbutton within busqueda_moneda
end type
type cb_2 from commandbutton within busqueda_moneda
end type
type cb_1 from commandbutton within busqueda_moneda
end type
type sle_buscar from singlelineedit within busqueda_moneda
end type
type st_2 from statictext within busqueda_moneda
end type
type st_1 from statictext within busqueda_moneda
end type
type ddlb_1 from dropdownlistbox within busqueda_moneda
end type
type dw_moneda from datawindow within busqueda_moneda
end type
end forward

global type busqueda_moneda from window
integer width = 2386
integer height = 924
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
sle_buscar sle_buscar
st_2 st_2
st_1 st_1
ddlb_1 ddlb_1
dw_moneda dw_moneda
end type
global busqueda_moneda busqueda_moneda

on busqueda_moneda.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_buscar=create sle_buscar
this.st_2=create st_2
this.st_1=create st_1
this.ddlb_1=create ddlb_1
this.dw_moneda=create dw_moneda
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.sle_buscar,&
this.st_2,&
this.st_1,&
this.ddlb_1,&
this.dw_moneda}
end on

on busqueda_moneda.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_buscar)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ddlb_1)
destroy(this.dw_moneda)
end on

event open;//conexion a la bbdd
ddlb_1.text="codigo_moneda"
//dw_moneda.settransobject(sqlca)
//dw_moneda.retrieve()
end event

type cb_3 from commandbutton within busqueda_moneda
integer x = 1865
integer y = 52
integer width = 457
integer height = 104
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Aceptar"
end type

event clicked;If dw_moneda.RowCount() < 1 Then Return // Nada para pasar
form_reporte.sle_moneda.text = dw_moneda.Object.codigo_moneda[dw_moneda.GetRow()]
Close( Parent )


end event

type cb_2 from commandbutton within busqueda_moneda
integer x = 1865
integer y = 304
integer width = 457
integer height = 104
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Cancelar"
end type

event clicked;close(parent)
end event

type cb_1 from commandbutton within busqueda_moneda
integer x = 1865
integer y = 184
integer width = 457
integer height = 104
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Buscar"
end type

event clicked;dw_moneda.settransobject(sqlca)
dw_moneda.retrieve()
string ls_buscar
ls_buscar=sle_buscar.text
if ls_buscar = "" then
	dw_moneda.SetFilter("")
	elseif ddlb_1.text = "codigo_moneda" then
		ls_buscar="%" + trim(sle_buscar.text)+"%"
		dw_moneda.SetFilter("upper(codigo_moneda) like '"+ ls_buscar +"' ")
	elseif ddlb_1.text = "descripcion_moneda" then
		ls_buscar="%" + trim(sle_buscar.text)+"%"
		dw_moneda.SetFilter("upper(descripcion_moneda) like '"+ ls_buscar +"' ")
	else
end if
dw_moneda.Filter( )




end event

type sle_buscar from singlelineedit within busqueda_moneda
integer x = 402
integer y = 180
integer width = 1422
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
end type

type st_2 from statictext within busqueda_moneda
integer x = 50
integer y = 180
integer width = 352
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Descripcion:"
boolean focusrectangle = false
end type

type st_1 from statictext within busqueda_moneda
integer x = 50
integer y = 72
integer width = 320
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busca Por:"
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within busqueda_moneda
integer x = 402
integer y = 64
integer width = 1422
integer height = 400
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
string item[] = {"codigo_moneda","descripcion_moneda"}
end type

type dw_moneda from datawindow within busqueda_moneda
integer x = 27
integer y = 372
integer width = 1810
integer height = 408
integer taborder = 10
string title = "none"
string dataobject = "monedas"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;If dw_moneda.RowCount() < 1 Then Return // Nada para pasar
form_reporte.sle_moneda.text = dw_moneda.Object.codigo_moneda[dw_moneda.GetRow()]
Close( Parent )
end event

