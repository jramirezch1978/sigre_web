$PBExportHeader$w_get_nro_ov.srw
forward
global type w_get_nro_ov from w_abc
end type
type cb_1 from commandbutton within w_get_nro_ov
end type
type sle_nro_ov from singlelineedit within w_get_nro_ov
end type
type st_1 from statictext within w_get_nro_ov
end type
type cb_cancelar from commandbutton within w_get_nro_ov
end type
type cb_aceptar from commandbutton within w_get_nro_ov
end type
end forward

global type w_get_nro_ov from w_abc
integer width = 1865
integer height = 488
string title = "Ingrese Nro OV"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_1 cb_1
sle_nro_ov sle_nro_ov
st_1 st_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
end type
global w_get_nro_ov w_get_nro_ov

on w_get_nro_ov.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.sle_nro_ov=create sle_nro_ov
this.st_1=create st_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_nro_ov
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_cancelar
this.Control[iCurrent+5]=this.cb_aceptar
end on

on w_get_nro_ov.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.sle_nro_ov)
destroy(this.st_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
end on

type cb_1 from commandbutton within w_get_nro_ov
integer x = 1650
integer y = 104
integer width = 169
integer height = 124
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana pop
str_parametros sl_param

sl_param.dw1    = 'd_lista_orden_venta_tbl'
sl_param.titulo = 'Ordenes de Venta'
sl_param.field_ret_i[1] = 2

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	sle_nro_ov.text = sl_param.field_ret[1]
END IF
end event

type sle_nro_ov from singlelineedit within w_get_nro_ov
integer y = 104
integer width = 1641
integer height = 124
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_get_nro_ov
integer width = 1815
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "INGRESE NRO ORDEN VENTA"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_get_nro_ov
integer x = 1403
integer y = 252
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;str_parametros lstr_return

lstr_Return.b_return = false

CloseWithReturn(parent, lstr_return)
end event

type cb_aceptar from commandbutton within w_get_nro_ov
integer x = 987
integer y = 252
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;str_parametros lstr_return

lstr_Return.b_return = true
lstr_return.string1 = sle_nro_ov.text

CloseWithReturn(parent, lstr_return)
end event

