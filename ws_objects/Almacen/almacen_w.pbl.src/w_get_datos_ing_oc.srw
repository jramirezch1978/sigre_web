$PBExportHeader$w_get_datos_ing_oc.srw
forward
global type w_get_datos_ing_oc from window
end type
type rb_2 from radiobutton within w_get_datos_ing_oc
end type
type rb_1 from radiobutton within w_get_datos_ing_oc
end type
type cb_cancelar from commandbutton within w_get_datos_ing_oc
end type
type cb_aceptar from commandbutton within w_get_datos_ing_oc
end type
end forward

global type w_get_datos_ing_oc from window
integer width = 1166
integer height = 424
boolean titlebar = true
string title = "Ingreso x Compra"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_aceptar ( )
event ue_cancelar ( )
rb_2 rb_2
rb_1 rb_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
end type
global w_get_datos_ing_oc w_get_datos_ing_oc

type variables
string 	is_almacen, is_tipo_mov
date   	id_fecha
Long		il_opcion

end variables

event ue_aceptar();string ls_opcion
str_parametros lstr_param

if rb_1.checked then
	ls_opcion = '1'
elseif rb_2.checked then
	ls_opcion = '2'
else
	MessageBox('Aviso', 'Debes seleccionar alguna de las opciones')
	return
end if

lstr_param.titulo = 's'
lstr_param.string1 = ls_opcion

CloseWithReturn(this, lstr_param)
end event

event ue_cancelar();str_parametros lstr_param

lstr_param.titulo = 'n'

CloseWithReturn(this, lstr_param)
end event

on w_get_datos_ing_oc.create
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.Control[]={this.rb_2,&
this.rb_1,&
this.cb_cancelar,&
this.cb_aceptar}
end on

on w_get_datos_ing_oc.destroy
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
end on

type rb_2 from radiobutton within w_get_datos_ing_oc
integer x = 46
integer y = 132
integer width = 677
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingreso x Transporte"
end type

type rb_1 from radiobutton within w_get_datos_ing_oc
integer x = 46
integer y = 40
integer width = 677
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingreso Normal"
boolean checked = true
end type

type cb_cancelar from commandbutton within w_get_datos_ing_oc
integer x = 745
integer y = 160
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;parent.event dynamic ue_cancelar()
end event

type cb_aceptar from commandbutton within w_get_datos_ing_oc
integer x = 745
integer y = 44
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event dynamic ue_aceptar()

end event

