$PBExportHeader$w_ap313_pd_chata_qstn.srw
forward
global type w_ap313_pd_chata_qstn from window
end type
type p_1 from picture within w_ap313_pd_chata_qstn
end type
type cb_2 from commandbutton within w_ap313_pd_chata_qstn
end type
type cb_1 from commandbutton within w_ap313_pd_chata_qstn
end type
type st_2 from statictext within w_ap313_pd_chata_qstn
end type
type em_1 from editmask within w_ap313_pd_chata_qstn
end type
type st_pregunta from statictext within w_ap313_pd_chata_qstn
end type
end forward

global type w_ap313_pd_chata_qstn from window
integer width = 1682
integer height = 684
boolean titlebar = true
string title = "(AP313) Parte de Piso - Filtro de autollenado"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
p_1 p_1
cb_2 cb_2
cb_1 cb_1
st_2 st_2
em_1 em_1
st_pregunta st_pregunta
end type
global w_ap313_pd_chata_qstn w_ap313_pd_chata_qstn

on w_ap313_pd_chata_qstn.create
this.p_1=create p_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_2=create st_2
this.em_1=create em_1
this.st_pregunta=create st_pregunta
this.Control[]={this.p_1,&
this.cb_2,&
this.cb_1,&
this.st_2,&
this.em_1,&
this.st_pregunta}
end on

on w_ap313_pd_chata_qstn.destroy
destroy(this.p_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.em_1)
destroy(this.st_pregunta)
end on

event open;long ll_cols
ll_cols = Message.DoubleParm
if ll_cols >= 1 then
	st_pregunta.text = 'Al procesar esta opción, usted borrará todos los atributos asignados en el parte de piso.  ¿Desea proceder?'
	p_1.picturename = 'retrievecancel!'
else
	st_pregunta.text = 'Indique la cantidad de registros que desea que se generen de maenra automática en el detalle de los atributos asignados.'
	p_1.picturename = 'table!'
end if
end event

type p_1 from picture within w_ap313_pd_chata_qstn
integer x = 87
integer y = 200
integer width = 183
integer height = 176
string picturename = "RetrieveCancel!"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_ap313_pd_chata_qstn
integer x = 987
integer y = 460
integer width = 434
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;CloseWithReturn(parent, '0-' + right('0' + trim(em_1.text), 2))
end event

type cb_1 from commandbutton within w_ap313_pd_chata_qstn
integer x = 457
integer y = 460
integer width = 434
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Llenar Detalle"
end type

event clicked;CloseWithReturn(parent, '1-' + right('0' + trim(em_1.text), 2))
end event

type st_2 from statictext within w_ap313_pd_chata_qstn
integer x = 402
integer y = 308
integer width = 805
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Número de Controles a Tomar"
boolean focusrectangle = false
end type

type em_1 from editmask within w_ap313_pd_chata_qstn
integer x = 1225
integer y = 296
integer width = 192
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "7"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
string minmax = "1~~99"
end type

type st_pregunta from statictext within w_ap313_pd_chata_qstn
integer x = 306
integer y = 36
integer width = 1289
integer height = 212
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Al procesar esta opción, usted borrará todos los atributos asignados en el parte de piso.  ¿Desea proceder?"
alignment alignment = center!
boolean focusrectangle = false
end type

