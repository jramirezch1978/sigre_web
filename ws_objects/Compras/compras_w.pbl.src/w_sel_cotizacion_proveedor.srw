$PBExportHeader$w_sel_cotizacion_proveedor.srw
forward
global type w_sel_cotizacion_proveedor from window
end type
type pb_2 from picturebutton within w_sel_cotizacion_proveedor
end type
type pb_1 from picturebutton within w_sel_cotizacion_proveedor
end type
type dw_1 from datawindow within w_sel_cotizacion_proveedor
end type
end forward

global type w_sel_cotizacion_proveedor from window
integer width = 1851
integer height = 884
boolean titlebar = true
string title = "Proveedores a cotizar"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
pb_2 pb_2
pb_1 pb_1
dw_1 dw_1
end type
global w_sel_cotizacion_proveedor w_sel_cotizacion_proveedor

type variables
str_parametros istr_par
end variables

on w_sel_cotizacion_proveedor.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_1=create dw_1
this.Control[]={this.pb_2,&
this.pb_1,&
this.dw_1}
end on

on w_sel_cotizacion_proveedor.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_1)
end on

event open;f_centrar( this)
str_parametros lst_par

if IsNull(Message.PowerObjectParm) or &
	Message.PowerObjectParm.ClassName() <> "str_parametros" then
	
	MessageBox('Aviso', 'Parametros mal pasados', Exclamation!)
	return
	
end if

lst_par = message.powerobjectparm

istr_par.string1 = lst_par.string1
istr_par.string2 = lst_par.string2

dw_1.SetTransObject(sqlca)
dw_1.retrieve( lst_par.string1, lst_par.string2)
end event

type pb_2 from picturebutton within w_sel_cotizacion_proveedor
integer x = 960
integer y = 560
integer width = 315
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\source\Bmp\Close_up.bmp"
alignment htextalign = left!
end type

event clicked;close( parent)
end event

type pb_1 from picturebutton within w_sel_cotizacion_proveedor
integer x = 631
integer y = 560
integer width = 315
integer height = 180
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\printer.bmp"
alignment htextalign = left!
end type

event clicked;if dw_1.getrow() > 0 then
	istr_par.string3 = dw_1.object.proveedor[dw_1.getrow()]
	OpenSheetWithParm( w_cm306_cotizacion_frm, istr_par, w_main, 0, Layered!)
	close( parent)
end if
end event

type dw_1 from datawindow within w_sel_cotizacion_proveedor
integer y = 8
integer width = 1801
integer height = 484
integer taborder = 10
string title = "none"
string dataobject = "d_sel_cotizacion_proveedor"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(CurrentRow, True)
THIS.SetRow(CurrentRow)

end event

