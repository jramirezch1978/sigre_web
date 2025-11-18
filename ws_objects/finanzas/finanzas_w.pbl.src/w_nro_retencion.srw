$PBExportHeader$w_nro_retencion.srw
forward
global type w_nro_retencion from window
end type
type p_1 from picture within w_nro_retencion
end type
type cb_2 from commandbutton within w_nro_retencion
end type
type cb_1 from commandbutton within w_nro_retencion
end type
type sle_nro_retencion from singlelineedit within w_nro_retencion
end type
type st_1 from statictext within w_nro_retencion
end type
end forward

global type w_nro_retencion from window
integer width = 1961
integer height = 388
boolean titlebar = true
string title = "Nro de Retencion...."
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
p_1 p_1
cb_2 cb_2
cb_1 cb_1
sle_nro_retencion sle_nro_retencion
st_1 st_1
end type
global w_nro_retencion w_nro_retencion

type variables
boolean ib_change = false
end variables

on w_nro_retencion.create
this.p_1=create p_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_nro_retencion=create sle_nro_retencion
this.st_1=create st_1
this.Control[]={this.p_1,&
this.cb_2,&
this.cb_1,&
this.sle_nro_retencion,&
this.st_1}
end on

on w_nro_retencion.destroy
destroy(this.p_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_nro_retencion)
destroy(this.st_1)
end on

event open;str_parametros lstr_param

lstr_param = Message.PowerObjectParm

sle_nro_retencion.text = lstr_param.string1
ib_change = false
end event

type p_1 from picture within w_nro_retencion
integer x = 5
integer width = 622
integer height = 276
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_nro_retencion
integer x = 1499
integer y = 144
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;str_parametros lstr_param

lstr_param.i_return = -1

CloseWithReturn(parent, lstr_param)
end event

type cb_1 from commandbutton within w_nro_retencion
integer x = 1499
integer y = 16
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;str_parametros lstr_param

lstr_param.i_return 	= 1
lstr_param.boolean1 	= ib_change
lstr_param.string1 	= sle_nro_retencion.text

CloseWithReturn(parent, lstr_param)
end event

type sle_nro_retencion from singlelineedit within w_nro_retencion
integer x = 699
integer y = 108
integer width = 768
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;ib_change = true
end event

type st_1 from statictext within w_nro_retencion
integer x = 699
integer y = 16
integer width = 768
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Nro de Retencion"
alignment alignment = center!
boolean focusrectangle = false
end type

