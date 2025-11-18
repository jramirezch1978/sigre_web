$PBExportHeader$w_cn712_eleccion_reporte.srw
forward
global type w_cn712_eleccion_reporte from window
end type
type rb_moneda from radiobutton within w_cn712_eleccion_reporte
end type
type rb_cnta_prov from radiobutton within w_cn712_eleccion_reporte
end type
type rb_prov_doc from radiobutton within w_cn712_eleccion_reporte
end type
type rb_articulo from radiobutton within w_cn712_eleccion_reporte
end type
type rb_proveedor from radiobutton within w_cn712_eleccion_reporte
end type
type rb_libro from radiobutton within w_cn712_eleccion_reporte
end type
type rb_2 from radiobutton within w_cn712_eleccion_reporte
end type
type rb_1 from radiobutton within w_cn712_eleccion_reporte
end type
type cb_2 from commandbutton within w_cn712_eleccion_reporte
end type
type cb_1 from commandbutton within w_cn712_eleccion_reporte
end type
type gb_1 from groupbox within w_cn712_eleccion_reporte
end type
end forward

global type w_cn712_eleccion_reporte from window
integer width = 1403
integer height = 1056
boolean titlebar = true
string title = "Elegir Tipo de Reporte"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_aceptar ( )
event ue_cancelar ( )
rb_moneda rb_moneda
rb_cnta_prov rb_cnta_prov
rb_prov_doc rb_prov_doc
rb_articulo rb_articulo
rb_proveedor rb_proveedor
rb_libro rb_libro
rb_2 rb_2
rb_1 rb_1
cb_2 cb_2
cb_1 cb_1
gb_1 gb_1
end type
global w_cn712_eleccion_reporte w_cn712_eleccion_reporte

event ue_aceptar();str_parametros lstr_param

if rb_1.checked then
	lstr_param.titulo = '1'
	lstr_param.string1 = rb_1.text
	
elseif rb_2.checked then
	lstr_param.titulo = '2'
	lstr_param.string1 = rb_2.text
	
elseif rb_libro.checked then
	lstr_param.titulo = '3'
	lstr_param.string1 = rb_libro.text
	
elseif rb_proveedor.checked then
	lstr_param.titulo = '4'
	lstr_param.string1 = rb_proveedor.text
	
elseif rb_prov_doc.checked then
	lstr_param.titulo = '5'
	lstr_param.string1 = rb_prov_doc.text
	
elseif rb_cnta_prov.checked then
	lstr_param.titulo = '6'
	lstr_param.string1 = rb_cnta_prov.text

elseif rb_moneda.checked then
	lstr_param.titulo = '7'
	lstr_param.string1 = rb_moneda.text

else
	
	lstr_param.titulo = '0'
	
end if



CloseWithReturn(this, lstr_param)
end event

event ue_cancelar();str_parametros lstr_param
lstr_param.titulo = '0'
CloseWithReturn(this, lstr_param)
end event

on w_cn712_eleccion_reporte.create
this.rb_moneda=create rb_moneda
this.rb_cnta_prov=create rb_cnta_prov
this.rb_prov_doc=create rb_prov_doc
this.rb_articulo=create rb_articulo
this.rb_proveedor=create rb_proveedor
this.rb_libro=create rb_libro
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_1=create gb_1
this.Control[]={this.rb_moneda,&
this.rb_cnta_prov,&
this.rb_prov_doc,&
this.rb_articulo,&
this.rb_proveedor,&
this.rb_libro,&
this.rb_2,&
this.rb_1,&
this.cb_2,&
this.cb_1,&
this.gb_1}
end on

on w_cn712_eleccion_reporte.destroy
destroy(this.rb_moneda)
destroy(this.rb_cnta_prov)
destroy(this.rb_prov_doc)
destroy(this.rb_articulo)
destroy(this.rb_proveedor)
destroy(this.rb_libro)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type rb_moneda from radiobutton within w_cn712_eleccion_reporte
integer x = 46
integer y = 632
integer width = 1243
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Res. por Razon Social y Documento (Inc. Moneda)"
end type

type rb_cnta_prov from radiobutton within w_cn712_eleccion_reporte
integer x = 46
integer y = 540
integer width = 1243
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumido por Cuenta Contable y Razon Social"
end type

type rb_prov_doc from radiobutton within w_cn712_eleccion_reporte
integer x = 46
integer y = 448
integer width = 1243
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumido por Razon Social y Documento"
end type

type rb_articulo from radiobutton within w_cn712_eleccion_reporte
integer x = 46
integer y = 724
integer width = 1243
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Resumido por Artículo"
end type

type rb_proveedor from radiobutton within w_cn712_eleccion_reporte
integer x = 46
integer y = 356
integer width = 1243
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumido por Razon Social"
end type

type rb_libro from radiobutton within w_cn712_eleccion_reporte
integer x = 46
integer y = 264
integer width = 1243
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumido por Libro Contable"
end type

type rb_2 from radiobutton within w_cn712_eleccion_reporte
integer x = 46
integer y = 172
integer width = 1243
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detallado por Documento y Cuenta Contable"
end type

type rb_1 from radiobutton within w_cn712_eleccion_reporte
integer x = 46
integer y = 80
integer width = 1243
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detallado por movimientos"
boolean checked = true
end type

type cb_2 from commandbutton within w_cn712_eleccion_reporte
integer x = 759
integer y = 852
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar( )
end event

type cb_1 from commandbutton within w_cn712_eleccion_reporte
integer x = 265
integer y = 852
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event ue_aceptar( )
end event

type gb_1 from groupbox within w_cn712_eleccion_reporte
integer width = 1371
integer height = 820
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Elegir un tipo de reporte"
end type

