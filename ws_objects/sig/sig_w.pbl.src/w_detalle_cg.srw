$PBExportHeader$w_detalle_cg.srw
forward
global type w_detalle_cg from window
end type
type lb_opcion from listbox within w_detalle_cg
end type
type pb_1 from picturebutton within w_detalle_cg
end type
type pb_2 from picturebutton within w_detalle_cg
end type
end forward

global type w_detalle_cg from window
integer width = 1810
integer height = 916
boolean titlebar = true
string title = "Detalle de Cuadro Gerencial"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_aceptar ( )
event ue_cancelar ( )
lb_opcion lb_opcion
pb_1 pb_1
pb_2 pb_2
end type
global w_detalle_cg w_detalle_cg

event ue_aceptar();sg_parametros	lstr_param

if lb_opcion.SelectedIndex ( ) <= 0 then
	MessageBox('Aviso', 'Debe Seleccionar un item primero')
	return
end if

lstr_param.titulo = 's'
lstr_param.string1 = lb_opcion.text( lb_opcion.selectedindex( ) )

CloseWithReturn(this, lstr_param)



end event

event ue_cancelar();sg_parametros lstr_param
lstr_param.titulo = 'n'

CloseWithReturn(this, lstr_param)
end event

on w_detalle_cg.create
this.lb_opcion=create lb_opcion
this.pb_1=create pb_1
this.pb_2=create pb_2
this.Control[]={this.lb_opcion,&
this.pb_1,&
this.pb_2}
end on

on w_detalle_cg.destroy
destroy(this.lb_opcion)
destroy(this.pb_1)
destroy(this.pb_2)
end on

type lb_opcion from listbox within w_detalle_cg
integer width = 1792
integer height = 620
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"1.- Producción por Planta","2.- Captura por Embarcación","3.- Rendimientos en HP y AP","4.- Costos Variables y precios de venta","5.- Stock de productos terminados","6.- Saldo valorizado x línea de producto","7.- Cuentas x cobrar","8.- Obligaciones y cuentas x pagar","9.- Caja y Bancos"}
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;parent.event ue_aceptar( )
end event

type pb_1 from picturebutton within w_detalle_cg
integer x = 553
integer y = 632
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()

end event

type pb_2 from picturebutton within w_detalle_cg
integer x = 928
integer y = 632
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_cancelar()
end event

