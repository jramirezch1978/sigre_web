$PBExportHeader$w_abc_totales_factura.srw
forward
global type w_abc_totales_factura from w_abc
end type
type st_4 from statictext within w_abc_totales_factura
end type
type em_total from editmask within w_abc_totales_factura
end type
type em_seguro from editmask within w_abc_totales_factura
end type
type em_flete from editmask within w_abc_totales_factura
end type
type em_fob from editmask within w_abc_totales_factura
end type
type st_3 from statictext within w_abc_totales_factura
end type
type st_2 from statictext within w_abc_totales_factura
end type
type st_1 from statictext within w_abc_totales_factura
end type
type cb_cancelar from commandbutton within w_abc_totales_factura
end type
type cb_aceptar from commandbutton within w_abc_totales_factura
end type
end forward

global type w_abc_totales_factura from w_abc
integer width = 1509
integer height = 752
string title = "Confirmar Totales de Factura"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_4 st_4
em_total em_total
em_seguro em_seguro
em_flete em_flete
em_fob em_fob
st_3 st_3
st_2 st_2
st_1 st_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
end type
global w_abc_totales_factura w_abc_totales_factura

forward prototypes
public subroutine of_total ()
end prototypes

public subroutine of_total ();Decimal 	ldc_valor_fob, ldc_valor_seguro, ldc_valor_flete

ldc_valor_fob		= Dec(em_fob.Text)
ldc_valor_flete	= Dec(em_flete.Text)
ldc_valor_seguro	= Dec(em_seguro.Text)

em_total.Text		= String(ldc_valor_fob + ldc_valor_flete + ldc_valor_seguro, '###,##0.00')
end subroutine

on w_abc_totales_factura.create
int iCurrent
call super::create
this.st_4=create st_4
this.em_total=create em_total
this.em_seguro=create em_seguro
this.em_flete=create em_flete
this.em_fob=create em_fob
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.em_total
this.Control[iCurrent+3]=this.em_seguro
this.Control[iCurrent+4]=this.em_flete
this.Control[iCurrent+5]=this.em_fob
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_cancelar
this.Control[iCurrent+10]=this.cb_aceptar
end on

on w_abc_totales_factura.destroy
call super::destroy
destroy(this.st_4)
destroy(this.em_total)
destroy(this.em_seguro)
destroy(this.em_flete)
destroy(this.em_fob)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
end on

event ue_open_pre;call super::ue_open_pre;str_parametros 	lstr_param

lstr_param = Message.PowerObjectParm

em_fob.Text 	= string(lstr_param.valor_fob, '###,##0.00')
em_flete.Text 	= string(lstr_param.valor_flete, '###,##0.00')
em_seguro.Text = string(lstr_param.valor_seguro, '###,##0.00')

em_total.Text 	= string(lstr_param.valor_fob + lstr_param.valor_flete + lstr_param.valor_seguro, '###,##0.00')
end event

event ue_cancelar;call super::ue_cancelar;str_parametros		lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar;call super::ue_aceptar;str_parametros		lstr_param

of_total()

lstr_param.b_return = true

lstr_param.valor_fob		= Dec(em_fob.text)
lstr_param.valor_flete	= Dec(em_flete.text)
lstr_param.valor_seguro	= Dec(em_seguro.text)
lstr_param.decimal_1		= Dec(em_total.Text)


CloseWithReturn(this, lstr_param)
end event

type st_4 from statictext within w_abc_totales_factura
integer x = 41
integer y = 380
integer width = 640
integer height = 100
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Total :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_total from editmask within w_abc_totales_factura
integer x = 731
integer y = 380
integer width = 713
integer height = 100
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = right!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
double increment = 1
string minmax = "0~~"
end type

type em_seguro from editmask within w_abc_totales_factura
integer x = 731
integer y = 264
integer width = 713
integer height = 100
integer taborder = 20
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
boolean spin = true
double increment = 1
string minmax = "0~~"
end type

event modified;of_total()
cb_aceptar.enabled = true
end event

type em_flete from editmask within w_abc_totales_factura
integer x = 727
integer y = 144
integer width = 713
integer height = 100
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
boolean spin = true
double increment = 1
string minmax = "0~~"
end type

event modified;of_total()
cb_aceptar.enabled = true
end event

type em_fob from editmask within w_abc_totales_factura
integer x = 727
integer y = 24
integer width = 713
integer height = 100
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
boolean spin = true
double increment = 1
string minmax = "0~~"
end type

event modified;of_total()
cb_aceptar.enabled = true
end event

type st_3 from statictext within w_abc_totales_factura
integer x = 41
integer y = 264
integer width = 640
integer height = 100
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seguro :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_abc_totales_factura
integer x = 32
integer y = 144
integer width = 640
integer height = 100
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Flete :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_abc_totales_factura
integer x = 32
integer y = 24
integer width = 640
integer height = 100
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valor FOB :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_abc_totales_factura
integer x = 1024
integer y = 540
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type cb_aceptar from commandbutton within w_abc_totales_factura
integer x = 590
integer y = 540
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Aceptar"
boolean default = true
end type

event clicked;parent.event ue_Aceptar()
end event

