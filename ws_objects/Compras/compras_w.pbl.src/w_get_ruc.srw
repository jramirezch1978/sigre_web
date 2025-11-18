$PBExportHeader$w_get_ruc.srw
forward
global type w_get_ruc from w_abc
end type
type sle_RUC from singlelineedit within w_get_ruc
end type
type st_1 from statictext within w_get_ruc
end type
type cb_cancelar from commandbutton within w_get_ruc
end type
type cb_aceptar from commandbutton within w_get_ruc
end type
end forward

global type w_get_ruc from w_abc
integer width = 1893
integer height = 512
sle_RUC sle_RUC
st_1 st_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
end type
global w_get_ruc w_get_ruc

on w_get_ruc.create
int iCurrent
call super::create
this.sle_RUC=create sle_RUC
this.st_1=create st_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_RUC
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_cancelar
this.Control[iCurrent+4]=this.cb_aceptar
end on

on w_get_ruc.destroy
call super::destroy
destroy(this.sle_RUC)
destroy(this.st_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
end on

type sle_RUC from singlelineedit within w_get_ruc
integer y = 104
integer width = 1815
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

type st_1 from statictext within w_get_ruc
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
string text = "INGRESE RUC"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_get_ruc
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

type cb_aceptar from commandbutton within w_get_ruc
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

