$PBExportHeader$busqueda_proveedor.srw
forward
global type busqueda_proveedor from window
end type
type st_3 from statictext within busqueda_proveedor
end type
type dw_proveedores_soles from datawindow within busqueda_proveedor
end type
type ddlb_1 from dropdownlistbox within busqueda_proveedor
end type
type st_1 from statictext within busqueda_proveedor
end type
type st_2 from statictext within busqueda_proveedor
end type
type sle_buscar from singlelineedit within busqueda_proveedor
end type
type cb_1 from commandbutton within busqueda_proveedor
end type
type cb_2 from commandbutton within busqueda_proveedor
end type
type cb_3 from commandbutton within busqueda_proveedor
end type
type dw_proveedores from datawindow within busqueda_proveedor
end type
end forward

global type busqueda_proveedor from window
integer width = 2761
integer height = 1376
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_3 st_3
dw_proveedores_soles dw_proveedores_soles
ddlb_1 ddlb_1
st_1 st_1
st_2 st_2
sle_buscar sle_buscar
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
dw_proveedores dw_proveedores
end type
global busqueda_proveedor busqueda_proveedor

on busqueda_proveedor.create
this.st_3=create st_3
this.dw_proveedores_soles=create dw_proveedores_soles
this.ddlb_1=create ddlb_1
this.st_1=create st_1
this.st_2=create st_2
this.sle_buscar=create sle_buscar
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.dw_proveedores=create dw_proveedores
this.Control[]={this.st_3,&
this.dw_proveedores_soles,&
this.ddlb_1,&
this.st_1,&
this.st_2,&
this.sle_buscar,&
this.cb_1,&
this.cb_2,&
this.cb_3,&
this.dw_proveedores}
end on

on busqueda_proveedor.destroy
destroy(this.st_3)
destroy(this.dw_proveedores_soles)
destroy(this.ddlb_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_buscar)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.dw_proveedores)
end on

event open;//dw_proveedores.settransobject(sqlca)
//dw_proveedores.retrieve()
ddlb_1.text = "codigo_proveedor"

//sle_3.text = form_reporte.text
if  form_reporte.sle_moneda.text = "US$" then
	dw_proveedores.Visible =true
	dw_proveedores_soles.Visible =false
elseif form_reporte.sle_moneda.text = "S/." then
	dw_proveedores.Visible =false
	dw_proveedores_soles.Visible =true
//else
end if
end event

type st_3 from statictext within busqueda_proveedor
integer x = 146
integer y = 328
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type dw_proveedores_soles from datawindow within busqueda_proveedor
integer x = 27
integer y = 448
integer width = 2688
integer height = 804
integer taborder = 30
string title = "none"
string dataobject = "proveedores_soles"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;If dw_proveedores_soles.RowCount() < 1 Then Return // Nada para pasar
form_reporte.sle_buscar_prov.text = dw_proveedores_soles.Object.nom_proveedor[dw_proveedores_soles.GetRow()]
Close( Parent )
end event

event doubleclicked;If dw_proveedores_soles.RowCount() < 1 Then Return // Nada para pasar
form_reporte.sle_buscar_prov.text = dw_proveedores_soles.Object.nom_proveedor[dw_proveedores_soles.GetRow()]
Close( Parent )
end event

type ddlb_1 from dropdownlistbox within busqueda_proveedor
integer x = 457
integer y = 64
integer width = 1646
integer height = 400
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
string item[] = {"codigo_proveedor","razon_social_o_nombre_proveedor"}
end type

type st_1 from statictext within busqueda_proveedor
integer x = 50
integer y = 72
integer width = 402
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

type st_2 from statictext within busqueda_proveedor
integer x = 50
integer y = 180
integer width = 402
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

type sle_buscar from singlelineedit within busqueda_proveedor
integer x = 457
integer y = 180
integer width = 1646
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
end type

type cb_1 from commandbutton within busqueda_proveedor
integer x = 2249
integer y = 184
integer width = 457
integer height = 104
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Buscar"
end type

event clicked;dw_proveedores.settransobject(sqlca)
dw_proveedores.retrieve()
string ls_buscar
ls_buscar=sle_buscar.text
if ls_buscar = "" then
	dw_proveedores.SetFilter("")
	elseif ddlb_1.text = "codigo_proveedor" then
		ls_buscar="%" + trim(sle_buscar.text)+"%"
		dw_proveedores.SetFilter("upper(cod_relacion) like '"+ ls_buscar +"' ")
	elseif ddlb_1.text = "razon_social_o_nombre_proveedor" then
		ls_buscar="%" + trim(sle_buscar.text)+"%"
		dw_proveedores.SetFilter("upper(nom_proveedor) like '"+ ls_buscar +"' ")
	else
end if
dw_proveedores.Filter( )


dw_proveedores_soles.settransobject(sqlca)
dw_proveedores_soles.retrieve()
string ls_buscar_1
ls_buscar_1=sle_buscar.text
if ls_buscar_1 = "" then
	dw_proveedores_soles.SetFilter("")
	elseif ddlb_1.text = "codigo_proveedor" then
		ls_buscar_1="%" + trim(sle_buscar.text)+"%"
		dw_proveedores_soles.SetFilter("upper(cod_relacion) like '"+ ls_buscar_1 +"' ")
	elseif ddlb_1.text = "razon_social_o_nombre_proveedor" then
		ls_buscar_1="%" + trim(sle_buscar.text)+"%"
		dw_proveedores_soles.SetFilter("upper(nom_proveedor) like '"+ ls_buscar_1 +"' ")
	else
end if
dw_proveedores_soles.Filter( )
end event

type cb_2 from commandbutton within busqueda_proveedor
integer x = 2249
integer y = 304
integer width = 457
integer height = 104
integer taborder = 60
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

type cb_3 from commandbutton within busqueda_proveedor
integer x = 2249
integer y = 52
integer width = 457
integer height = 104
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Aceptar"
end type

event clicked;if dw_proveedores.Visible = true then
	If dw_proveedores.RowCount() < 1 Then Return // Nada para pasar
	form_reporte.sle_buscar_prov.text = dw_proveedores.Object.nom_proveedor[dw_proveedores.GetRow()]
	Close( Parent )
elseif dw_proveedores_soles.Visible = true then
	If dw_proveedores_soles.RowCount() < 1 Then Return // Nada para pasar
	form_reporte.sle_buscar_prov.text = dw_proveedores_soles.Object.nom_proveedor[dw_proveedores_soles.GetRow()]
	Close( Parent )
end if


end event

type dw_proveedores from datawindow within busqueda_proveedor
integer x = 27
integer y = 444
integer width = 2688
integer height = 808
integer taborder = 20
string title = "none"
string dataobject = "proveedores"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;If dw_proveedores.RowCount() < 1 Then Return // Nada para pasar
form_reporte.sle_buscar_prov.text = dw_proveedores.Object.nom_proveedor[dw_proveedores.GetRow()]
Close( Parent )
end event

