$PBExportHeader$w_rsp_descripcion.srw
forward
global type w_rsp_descripcion from window
end type
type cb_2 from commandbutton within w_rsp_descripcion
end type
type cb_1 from commandbutton within w_rsp_descripcion
end type
type mle_1 from multilineedit within w_rsp_descripcion
end type
end forward

global type w_rsp_descripcion from window
integer width = 2185
integer height = 1028
boolean titlebar = true
string title = "Descripción de Concepto"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_2 cb_2
cb_1 cb_1
mle_1 mle_1
end type
global w_rsp_descripcion w_rsp_descripcion

on w_rsp_descripcion.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.mle_1=create mle_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.mle_1}
end on

on w_rsp_descripcion.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.mle_1)
end on

event open;mle_1.SetFocus()
long ll_nfila
ll_nfila = long(message.stringparm)

mle_1.text = string(w_rh046_abc_calificacion_desempeno.dw_detail.GetItemString(ll_nfila,'descripcion'))
end event

type cb_2 from commandbutton within w_rsp_descripcion
integer x = 1152
integer y = 784
integer width = 274
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
end type

event clicked;close(parent)
end event

type cb_1 from commandbutton within w_rsp_descripcion
integer x = 741
integer y = 784
integer width = 288
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;long ll_nfila
ll_nfila = long(message.stringparm)

w_rh046_abc_calificacion_desempeno.dw_detail.SetItem(ll_nfila,'descripcion',mle_1.text)
close(parent)
end event

type mle_1 from multilineedit within w_rsp_descripcion
integer x = 55
integer y = 44
integer width = 2066
integer height = 672
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
integer limit = 800
borderstyle borderstyle = stylelowered!
end type

